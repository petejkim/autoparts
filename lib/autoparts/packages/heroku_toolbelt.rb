# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class HerokuToolbelt < Package
      name 'heroku_toolbelt'
      version '3.9.0'
      description 'CLI tool for creating and managing Heroku apps'
      category Category::DEPLOYMENT
      source_url 'https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.9.0.tgz'
      source_sha1 'd5a27602a139bd6e71618418b0f4668ed483fcaf'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'heroku-client', prefix_path
      end
    end
  end
end
