# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Upgrade
      def initialize(args, options)
        begin
          puts 'Upgrade parameter is in testing now, please provide a feedback if something fails.'.red
          puts 'Also please stop all packages depended from packages for upgrade.'.red

          packages = args.length > 0 ? args : Autoparts::Package.installed

          packages = filter_upgrade_available(packages)
          puts 'Everything is up-to-date' if (packages.length == 0)
          upgrade(packages) if (packages.length > 0)
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end

      def filter_upgrade_available(packages)
        hash = {}
        packages.map do |package, version|
          latest_version = get_latest_version(package)
          installed_versions = Autoparts::Package.installed_versions(package)
          #puts package, latest_version, installed_versions
          if installed_versions.length > 0 && !installed_versions.include?(latest_version)
            hash[package] = latest_version
          end
        end
        hash
      end

      def get_latest_version(name)
        package = Autoparts::Package.factory(name)
        package.version
      end

      def upgrade(packages)
        puts 'Packages to upgarde: '
        packages.each_pair do |package, version|
          puts package + ' ' + version
        end

        print "Would you like to upgrade? [N/y]: "
        case $stdin.gets.chomp
          when 'Y', 'y', 'yes'
            perform_upgrade(packages)
          else
            puts 'Upgrade Canceled! To perform the upgrade type "y"'
        end
      end

      def perform_upgrade(packages)
        packages.each_pair do |package, version|
          instance = Package.factory(package)
          instance.stop if instance.respond_to? :stop
          stop_dependencies instance
          instance.perform_uninstall
          instance.perform_install_with_dependencies
        end
      end


      def stop_dependencies(package)
        package.dependencies.install_order.each do |pkg|
          instance = Package.factory(pkg)
          instance.stop if instance.respond_to? :stop
        end
      end
    end
  end
end
