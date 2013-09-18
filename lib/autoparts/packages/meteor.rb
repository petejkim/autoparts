module Autoparts
  module Packages
    class Meteor < Package
      name 'meteor'
      version '0.6.5.1'
      description 'Meteor: A real-time web development platform'
      source_url 'https://warehouse.meteor.com/bootstrap/0.6.5.1/meteor-bootstrap-Linux_x86_64.tar.gz'
      source_sha1 'fe4c63b1bf4fad6d166c1e5639201a992fbbac9d'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/meteor-0.6.5.1-binary.tar.gz'
      binary_sha1 '20c5d9d9129bd6548499b16626d146d20c8d3215'

      def install
        Dir.chdir('.meteor') do
          prefix_path.mkpath
          execute "mv * #{prefix_path}"
        end
      end

      def post_install
        meteor_bin_path.unlink if meteor_bin_path.exist?

        bin_path.mkpath
        File.open(meteor_bin_path, 'w') do |f|
          f.write meteor_bin_file
        end

        execute 'chmod', '0755', meteor_bin_path
        execute 'ln', '-s', prefix_path, home_meteor_path
      end

      def post_uninstall
        home_meteor_path.unlink if home_meteor_path.symlink?
      end

      def home_meteor_path
        Path.home + '.meteor'
      end

      def meteor_bin_path
        bin_path + 'meteor'
      end

      def meteor_bin_file
        <<-EOF.unindent
          #!/bin/bash

          exec "#{prefix_path}/meteor" "$@"
        EOF
      end
    end
  end
end
