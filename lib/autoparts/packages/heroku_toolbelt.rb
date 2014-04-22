# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class HerokuToolbelt < Package
      name 'heroku_toolbelt'
      # TODO: update to latest 3.6.0 once its stand-alone install is fixed, see
      # https://github.com/heroku/heroku/issues/1085
      version '3.5.0'
      description 'CLI tool for creating and managing Heroku apps'
      category Category::DEPLOYMENT
      source_url 'https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.5.0.tgz'
      source_sha1 '9896b7d45a872f21b191102a56afec9567f2713a'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'heroku-client', prefix_path
      end
    end
  end
end
