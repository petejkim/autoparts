# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Meteor < Package
      name 'meteor'
      version '0.7.1.2'
      description 'Meteor: A real-time web development platform'
      source_url 'https://warehouse.meteor.com/bootstrap/0.7.1.2/meteor-bootstrap-Linux_x86_64.tar.gz'
      source_sha1 '7fc5616f89f2c56d7af545c38f424e7b32e19365'
      source_url 'https://warehouse.meteor.com/bootstrap/0.7.1.2/meteor-bootstrap-Linux_x86_64.tar.gz'
      source_sha1 '7fc5616f89f2c56d7af545c38f424e7b32e19365'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + ".meteor", prefix_path
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
