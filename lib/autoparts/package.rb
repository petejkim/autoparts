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

      def installed?(name)
        installed.has_key? name
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

      def source_filetype(val)
        @source_filetype = val
      end

      def binary_url(val)
        @binary_url = val
      end

      def binary_sha1(val)
        @binary_sha1 = val
      end
    end

    def initialize
      @source_install = false
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

    def source_filetype
      self.class.instance_variable_get(:@source_filetype)
    end

    def binary_url
      self.class.instance_variable_get(:@binary_url)
    end

    def binary_sha1
      self.class.instance_variable_get(:@binary_sha1)
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
        raise ExecutionFailedError.new cmd
      end
    end

    def archive_filename
      name_with_version + (@source_install ? ".#{source_filetype}" : '-binary.tar.gz')
    end

    def temporary_archive_path
      Path.tmp + archive_filename
    end

    def archive_path
      Path.archives + archive_filename
    end

    def extracted_archive_path
      Path.tmp + "#{name_with_version}"
    end

    def download_archive
      url = @source_install ? source_url : binary_url
      execute 'curl', url, '-L', '-o', temporary_archive_path
      execute 'mv', temporary_archive_path, archive_path
    end

    def verify_archive
      raise VerificationFailedError if Util.sha1(archive_path) != (@source_install ? source_sha1 : binary_sha1)
    end

    def extract_archive
      extracted_archive_path.rmtree if extracted_archive_path.exist?
      extracted_archive_path.mkpath
      Dir.chdir(extracted_archive_path) do
        if @source_install
          case source_filetype
          when 'tar', 'tar.gz', 'tar.bz2', 'tar.bz', 'tgz', 'tbz2', 'tbz'
            execute 'tar', 'xf', archive_path
          when 'zip'
            execute 'unzip', '-qq', archive_path
          end
        else
          execute 'tar', 'xf', archive_path
        end
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

    def archive_installed_package
      @source_install = false
      Dir.chdir(prefix_path) do
        execute 'tar -c . | gzip -n >', temporary_archive_path
      end
      execute 'mv', temporary_archive_path, archive_path
    end

    def symlink_files
      symlink_recursively(bin_path,     Path.bin)
      symlink_recursively(sbin_path,    Path.sbin)
      symlink_recursively(lib_path,     Path.lib)
      symlink_recursively(include_path, Path.include)
      symlink_recursively(share_path,   Path.share)
    end

    def perform_install(source_install=false)
      begin
        ENV['CHOST'] = "x86_64-pc-linux-gnu"
        ENV['CFLAGS'] = "-march=x86-64 -O2 -pipe -fomit-frame-pointer"
        ENV['CXXFLAGS'] = ENV['CFLAGS']
        ENV['MAKEFLAGS'] = '-j 2'
        @source_install = source_install ||= binary_url.nil?

        unless File.exist? archive_path
          puts "=> Downloading #{@source_install ? source_url : binary_url}..."
          download_archive
        end
        puts "=> Verifying archive..."
        verify_archive
        puts "=> Extracting archive..."
        extract_archive

        Path.etc
        Path.var

        if @source_install # install from source
          Dir.chdir(extracted_archive_path) do
            puts "=> Compiling..."
            compile
            puts "=> Installing..."
            install
            extracted_archive_path.rmtree if extracted_archive_path.exist?
          end
        else # install using pre-compiled binary
          puts "=> Installing..."
          prefix_path.rmtree if prefix_path.exist?
          prefix_path.parent.mkpath
          execute 'mv', extracted_archive_path, prefix_path
        end

        Dir.chdir(prefix_path) do
          post_install
          puts "=> Symlinking..."
          symlink_files
        end

      rescue => e
        archive_path.unlink if e.kind_of? VerificationFailedError
        prefix_path.rmtree if prefix_path.exist?
        extracted_archive_path.rmtree if extracted_archive_path.exist?
        raise e
      else
        puts "=> Installed #{name} #{version}\n"
        puts tips
      end
    end

    def archive_installed
      puts "=> Archiving #{name} #{version}..."
      archive_installed_package
      file_size = archive_path.size
      puts "=> Archived: #{archive_path}"
      puts "Size: #{archive_path.size} bytes (#{sprintf "%.2f MiB", file_size / 1024.0 / 1024.0})"
      puts "SHA1: #{Util.sha1 archive_path}"
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
