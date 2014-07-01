# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'unindent/unindent'
require 'net/http'
require 'etc'

module Autoparts
  class Package
    BINARY_HOST = 'http://parts.nitrous.io'.freeze
    BINARY_BUCKET = 'nitrousio-autoparts-use1'.freeze
    WEB_HOOK_URL = 'https://www.nitrous.io/autoparts/webhook'.freeze
    BOX_ID_PATH = '/etc/action/box_id'.freeze
    include PackageDeps

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

      def factory(name)
        begin
          require "autoparts/packages/#{name}"
        rescue LoadError
        end
        if package_class = packages[name]
          package_class.new
        else
          raise Autoparts::PackageNotFoundError.new(name)
        end
      end

      def name(val)
        @name = val
        packages[val] = self
      end

      def start_all
        # migrate old style config
        init_path = Path.root + 'init'
        if init_path.exist?
          init_path.children.each do |package_conf_path|
            package_name = package_conf_path.basename.sub_ext('').to_s
            FileUtils.touch(Path.config_autostart + package_name)
          end
          FileUtils.rm_rf init_path
        end

        # new style config
        if Path.config_autostart.exist?
          Path.config_autostart.children.each do |package_pathname|
            begin
              Commands::Start.start(package_pathname.basename.to_s, true)
            rescue
              # ignore exceptions
            end
          end
        end
      end

      # returns a hash of required environment variables that each package
      # needs to be able to run properly. Its helpful when some package
      # requires:
      # - env variables to be set
      # - sourcing commands / libraries from the terminal
      def package_envs
        envs = installed.map do |package_name, versions|
          package = factory package_name
          if package.respond_to? :required_env
            package.send :required_env
          end
        end.flatten.compact
        if envs
          envs.uniq
        else
          []
        end
      end

      def version(val)
        @version = val
      end

      def description(val)
        @description = val

      end
      def category(val)
        @category = val
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
    end

    # if we found AUTOPARTS_HOST variable, use that as the binary host value,
    # otherwise use the default production host.
    #
    # This is useful when we want to stage a test package but dont want the
    # package to be on production bucket.
    def binary_host
      ENV['AUTOPARTS_HOST'] || BINARY_HOST
    end

    # if we found AUTOPARTS_BUCKET variable, use that as the bucket host,
    # otherwise use the default production value.
    #
    # This is useful when we want to upload a package to staging bucket.
    def binary_bucket
      ENV['AUTOPARTS_BUCKET'] || BINARY_BUCKET
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

    def description
      self.class.instance_variable_get(:@description)
    end

    def category
      self.class.instance_variable_get(:@category)
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

    def binary_present?
      @binary_present = (remote_file_exists?(binary_url) && remote_file_exists?(binary_sha1_url)) if @binary_present.nil?
      @binary_present
    end

    def binary_url
      "#{binary_host}/#{name_with_version}-binary.tar.gz"
    end

    def binary_sha1_url
      "#{binary_host}/#{binary_sha1_filename}"
    end

    def binary_sha1
      if binary_present?
        download binary_sha1_url, binary_sha1_path
        File.read(binary_sha1_path.to_s).strip
      else
        raise BinaryNotPresentError.new(name)
      end
    end

    def user
      Etc.getlogin
    end

    def prefix_path
      Path.packages + name + active_version
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
      args = args.map(&:to_s)
      unless system(*args)
        raise ExecutionFailedError.new args.join(' ')
      end
    end

    def execute_with_result(*args)
      args = args.map(&:to_s)
      system(*args)
    end

    def archive_filename
      name_with_version + (@source_install ? ".#{source_filetype}" : '-binary.tar.gz')
    end

    def binary_sha1_filename
      name_with_version + '-binary.sha1'
    end

    def temporary_archive_path
      Path.tmp + archive_filename
    end

    def binary_sha1_path
      Path.tmp + binary_sha1_filename
    end

    def archive_path
      Path.archives + archive_filename
    end

    def extracted_archive_path
      Path.tmp + "#{name_with_version}"
    end

    def download_archive
      url  = @source_install ? source_url  : binary_url
      sha1 = @source_install ? source_sha1 : binary_sha1

      download url, archive_path, sha1
    end

    def extract_archive
      extracted_archive_path.rmtree if extracted_archive_path.exist?
      extracted_archive_path.mkpath
      Dir.chdir(extracted_archive_path) do
        if @source_install
          case source_filetype
          when 'tar', 'tar.gz', 'tar.bz2', 'tar.bz', 'tgz', 'tbz2', 'tbz', 'tar.xz', 'txz'
            execute 'tar', 'xf', archive_path
          when 'zip'
            execute 'unzip', '-qq', archive_path
          else
            execute 'cp', archive_path, extracted_archive_path
          end
        else
          execute 'tar', 'xf', archive_path
        end
      end
    end

    def active_version
      return @active_version unless @active_version.nil?

      config_active_package_path = Path.config_active + name
      package_path = Path.packages + name

      if config_active_package_path.exist?
        v = File.read(config_active_package_path).strip
        return v if (package_path + v).exist?
      end

      unless package_path.exist? && package_path.children.size > 0
        return self.version
      end

      v = package_path.children.sort_by(&:mtime).last.basename.to_s
      activate(v)
      v
    end

    def activate(version)
      File.open(Path.config_active + name, 'w') do |f|
        f.write version
      end
    end

    def deactivate
      FileUtils.rm_f(Path.config_active + name)
    end

    def symlink_recursively(from, to, options={}) # Pathname, Pathname
      only_executables = !!options[:only_executables]
      to.mkpath unless to.exist?
      from.each_child do |f|
        t = to + f.basename
        if f.directory? && !f.symlink?
          symlink_recursively f, t, options
        else
          if !only_executables || (only_executables && (f.executable? || f.symlink?))
            execute 'ln', '-sf', f, t
          end
        end
      end if from.directory? && from.executable?
    end

    def unsymlink_recursively(from, to) # Pathname, Pathname
      if to.exist?
        from.each_child do |f|
          t = to + f.basename
          if f.directory? && !f.symlink?
            unsymlink_recursively f, t
          else
            t.rmtree if t.exist?
          end
        end
        to.rmtree if to.children.empty?
      end if from.directory? && from.executable?
    end

    def symlink_all
      symlink_recursively(bin_path,     Path.bin,  only_executables: true)
      symlink_recursively(sbin_path,    Path.sbin, only_executables: true)
      symlink_recursively(lib_path,     Path.lib)
      symlink_recursively(include_path, Path.include)
      symlink_recursively(share_path,   Path.share)
    end

    def unsymlink_all
      unsymlink_recursively(bin_path,     Path.bin)
      unsymlink_recursively(sbin_path,    Path.sbin)
      unsymlink_recursively(lib_path,     Path.lib)
      unsymlink_recursively(include_path, Path.include)
      unsymlink_recursively(share_path,   Path.share)
    end

    def archive_installed_package
      @source_install = false
      pre_archive
      Dir.chdir(prefix_path) do
        execute "tar -c . | gzip -n > #{temporary_archive_path}"
      end
      execute 'mv', temporary_archive_path, archive_path
    end

    def perform_install(source_install=false)
      begin
        ENV['CPPFLAGS'] = '-D_FORTIFY_SOURCE=2'
        ENV['CHOST'] = 'x86_64-pc-linux-gnu'
        ENV['CFLAGS'] = '-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4'
        ENV['CXXFLAGS'] = ENV['CFLAGS']
        ENV['LDFLAGS'] = '-Wl,-O1,--sort-common,--as-needed,-z,relro'
        ENV['MAKEFLAGS'] = '-j2'

        if !source_install && !Util.binary_package_compatible?
          puts "Warning: This system is incompatible with Nitrous.IO binary packages; installing from source."
          source_install = true
        end

        @source_install = source_install ||= (binary_present? == false)

        unless File.exist? archive_path
          puts "=> Downloading #{@source_install ? source_url : binary_url}..."
          download_archive
        end
        puts "=> Extracting archive..."
        extract_archive

        Path.etc
        Path.var

        unsymlink_all # unsymlink existing installation

        @active_version = self.version # override active_version so that prefix_path returns path for the latest version

        if @source_install # install from source
          Dir.chdir(extracted_archive_path) do
            puts "=> Compiling..."
            compile
            puts "=> Installing..."
            install
          end
        else # install using pre-compiled binary
          puts "=> Installing..."
          prefix_path.rmtree if prefix_path.exist?
          prefix_path.parent.mkpath
          execute 'mv', extracted_archive_path, prefix_path
        end

        extracted_archive_path.rmtree if extracted_archive_path.exist?

        Dir.chdir(prefix_path) do
          post_install
          puts '=> Activating...'
          activate(version)
          symlink_all
          post_symlink
        end
      rescue => e
        archive_path.unlink if e.kind_of?(VerificationFailedError) && archive_path.exist?
        prefix_path.rmtree if prefix_path.exist?
        raise e
      else
        puts "=> Installed #{name} #{version}\n"
        puts tips
        call_web_hook :installed
      ensure
        @active_version = nil
      end
    end

    def perform_uninstall
      begin
        if respond_to?(:stop) && respond_to?(:running?) && running?
          puts "=> Stopping #{name}..."
          stop
        end
      rescue
      end
      puts '=> Deactivating...'
      unsymlink_all
      deactivate

      puts '=> Uninstalling...'
      prefix_path.rmtree if prefix_path.exist?
      parent = prefix_path.parent
      parent.rmtree if parent.children.empty?
      post_uninstall

      puts "=> Uninstalled #{name} #{active_version}\n"
      call_web_hook :uninstalled
    end

    def upload_archive
      binary_file_name = "#{name_with_version}-binary.tar.gz"
      binary_sha1_file_name = "#{name_with_version}-binary.sha1"

      binary_path = Path.archives + binary_file_name
      binary_sha1_path = Path.archives + binary_sha1_file_name

      if File.exists?(binary_path) && File.exists?(binary_sha1_path)
        puts "=> Uploading #{name} #{version}..."
        [binary_file_name, binary_sha1_file_name].each do |f|
          local_path = Path.archives + f
          `s3cmd put --acl-public --guess-mime-type #{local_path} s3://#{binary_bucket}/#{f}`
        end
        puts "=> Done"
      else
        puts "=> Error: Can't find package, archive it by running AUTOPARTS_DEV=1 parts archive #{name}"
      end
    end

    def archive_installed
      puts "=> Archiving #{name} #{version}..."
      archive_installed_package
      file_size = archive_path.size
      puts "=> Archived: #{archive_path}"
      puts "Size: #{archive_path.size} bytes (#{sprintf "%.2f MiB", file_size / 1024.0 / 1024.0})"
      sha1 = Util.sha1 archive_path
      # Write the SHA1 to the archive_path too
      File.open(File.join(Path.archives, "#{name_with_version}-binary.sha1"), 'w') { |f| f.puts (sha1) }
      puts "SHA1: #{sha1}"
    end

    def download(url, to, sha1=nil)
      tmp_download_path = Path.tmp + ("#{to.basename}.partsdownload")
      execute 'curl', url, '-L', '-o', tmp_download_path
      if sha1 && sha1 != Util.sha1(tmp_download_path)
        raise VerificationFailedError
      end
      execute 'mv', tmp_download_path, to
    end

    def remote_file_exists?(url)
      `curl -IsL -w \"%{http_code}\" '#{url}' -o /dev/null 2> /dev/null`.strip == '200'
    end

    # notify the web IDE when a package is installed / uninstalled
    def call_web_hook(action)
      return unless File.exist?(BOX_ID_PATH)
      begin
        box_id = File.read(BOX_ID_PATH).strip
        autoparts_version = Autoparts::Commands::Help.version

        url = URI.parse(WEB_HOOK_URL)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(url.path)
        req.form_data = {
          type: action.to_s,
          part_name: self.name,
          part_version: self.version,
          box_id: box_id,
          autoparts_version: autoparts_version
        }
        http.request(req)
      rescue => e
        # We gulp the webhook exceptions,
        # so command would finish with a successful exit status.
      end
    end

    # -- implement these methods --
    def compile # compile source code - runs in source directory
    end

    def install # install compiled code - runs in source directory
    end

    def post_install # run post install commands - runs in installed package directory
    end

    def post_symlink # run post symlink commands - run in installed package directory
    end

    def post_uninstall # run post uninstall commands
    end

    def purge # remove leftover config/data files
    end

    #def start
    #end

    #def stop
    #end

    #def running?
    #end

    def tips
      ''
    end

    def information
      tips
    end

    def required_env # required env for package to function correctly
    end

    def pre_archive # running before archive
    end
    # -----
  end
end
