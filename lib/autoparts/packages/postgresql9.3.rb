# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'postgresql')

module Autoparts
  module Packages
    class PostgreSQL93 < PostgreSQL
      name 'postgresql9.3'
      version '9.3.4'
      description "PostgreSQL: The world's most advanced open-source database system"
      category Category::DATA_STORES

      source_url 'http://ftp.postgresql.org/pub/source/v9.3.4/postgresql-9.3.4.tar.gz'
      source_sha1 '9f80b3cfebc434ca0860fc8489923cea73456081'
      source_filetype 'tar.gz'

      def archive_dir
        'postgresql-9.3.4'
      end
    end
  end
end
