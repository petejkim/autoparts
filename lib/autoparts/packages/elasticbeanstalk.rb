# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Elasticbeanstalk < Package
      name 'elasticbeanstalk'
      version '2.6.2'
      description "Elastic Beanstalk Command Line Tool: A command line client for interacting with the AWS Elastic Beanstalk APIs"
      category Category::UTILITIES

      source_url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.6.2.zip'
      source_sha1 '35e91aed51cc3d39cffe5e557de05d403f30edfc'
      source_filetype 'zip'

      depends_on 'python2'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'AWS-ElasticBeanstalk-CLI-2.6.2/eb/linux/python2.7', prefix_path
      end

      def symlink_all
        symlink_recursively(prefix_path, Path.bin, only_executables: true)
      end
    end
  end
end
