require 'unindent'
require 'etc'

module Autoparts
  class Package
    class << self
      def installed
        hash = {}
        Path.packages.each_child do |pkg|
          if pkg.directory?
            pkg.each_child do |ver|
              if ver.directory? && !ver.children.empty?
                hash[pkg.basename.to_s] ||= []
                hash[pkg.basename.to_s].push ver.basename.to_s
              end
            end
          end
        end
        hash
      end

      def packages
        @@packages ||= {}
      end

      def find(name)
        packages[name]
      end

      def name(val)
        @name = val
        packages[val] = self
      end

      def version(val)
        @version = val
      end

      def source_url(val)
        @source_url = val
      end

      def source_sha1(val)
        @source_sha1 = val
      end

      def source_type(val)
        @source_type = val
      end
    end

    def name
      self.class.instance_variable_get(:@name)
    end

    def version
      self.class.instance_variable_get(:@version)
    end

    def name_with_version
      "#{name}-#{version}"
    end

    def source_url
      self.class.instance_variable_get(:@source_url)
    end

    def source_sha1
      self.class.instance_variable_get(:@source_sha1)
    end

    def source_type
      self.class.instance_variable_get(:@source_type)
    end

    def user
      Etc.getlogin
    end

    def prefix_path
      Path.packages + name + version
    end

    %w(bin sbin include lib libexec share).each do |d|
      define_method :"#{d}_path" do
        prefix_path + d
      end
    end

    def info_path
      share_path + 'info'
    end

    def man_path
      share_path + 'man'
    end

    (1..8).each do |i|
      define_method :"man#{i}_path" do
        man_path + "man#{i}"
      end
    end

    def doc_path
      share_path + 'doc' + name
    end

    def execute(*args)
      cmd = args.join ' '
      unless system cmd
        raise ExecutionFailedError.new "\"#{cmd}\" failed"
      end
    end

    def payload_filename
      "#{name_with_version}.#{source_type}"
    end

    def download_path
      Path.tmp + payload_filename
    end

    def source_path
      Path.archives + payload_filename
    end

    def extracted_source_path
      Path.tmp + "#{name_with_version}"
    end

    def download_source
      execute 'curl', source_url, '-L', '-o', download_path
      execute 'mv', download_path, source_path
    end

    def verify_source
      raise VerificationFailedError.new('SHA1 verification failed') if `shasum -p #{source_path}`[/^([0-9a-f]*)/, 1] != source_sha1
    end

    def extract_source
      extracted_source_path.mkpath
      case source_type
      when 'tar', 'tar.gz', 'tar.bz2', 'tar.bz', 'tgz', 'tbz2', 'tbz'
        execute 'tar', 'xf', source_path, '-C', extracted_source_path
      when 'zip'
        execute 'unzip', '-qq', source_path, '-d', extracted_source_path
      end
    end

    def symlink_recursively(from, to) # Pathname, Pathname
      to.mkpath
      from.each_child do |f|
        t = to + f.basename
        if f.directory? && !f.symlink?
          symlink_recursively f, t
        else
          execute('rm', '-rf', t) if t.exist?
          execute 'ln', '-s', f, t
        end
      end if from.directory? && from.executable?
    end

    def symlink_files
      symlink_recursively(bin_path,     Path.bin)
      symlink_recursively(sbin_path,    Path.sbin)
      symlink_recursively(lib_path,     Path.lib)
      symlink_recursively(include_path, Path.include)
      symlink_recursively(share_path,   Path.share)
    end

    def install_from_source
      begin
        ENV['CHOST'] = "x86_64-pc-linux-gnu"
        ENV['CFLAGS'] = "-march=x86-64 -O2 -pipe -fomit-frame-pointer"
        ENV['CXXFLAGS'] = ENV['CFLAGS']
        ENV['MAKEFLAGS'] = '-j 2'
        unless File.exist? source_path
          puts "=> Downloading #{source_url}..."
          download_source
        end
        puts "=> Verifying download..."
        verify_source
        puts "=> Extracting source..."
        extract_source
        Dir.chdir(extracted_source_path) do
          puts "=> Compiling..."
          compile
          puts "=> Installing..."
          Path.etc
          Path.var
          install
        end
        Dir.chdir(prefix_path) do
          post_install
          puts "=> Symlinking..."
          symlink_files
        end
      rescue AutopartsError => e
        case e
        when VerificationFailedError
          source_path.unlink
        end
        abort "ERROR: #{e}\nAborting..."
      else
        puts "=> Installed #{name} #{version}\n"
        puts tips
      end
    end

    # -- override these methods --
    def compile # compile source code - runs in source directory
    end

    def install # install compiled code - runs in source directory
    end

    def post_install # run post install commands - runs in installed package directory
    end

    def tips
      ''
    end

    def information
      ''
    end
    # -----
  end
end
