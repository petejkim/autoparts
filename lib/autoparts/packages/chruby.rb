# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Chruby < Package
      name 'chruby'
      version '0.3.8'
      description 'Chruby: Changes the current ruby'
      source_url 'https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz'
      source_sha1 '320d13bacafeae72631093dba1cd5526147d03cc'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('chruby-0.3.8') do
          execute "make", "install", "PREFIX=#{prefix_path}"
        end
      end

      def required_env
        [
          'PREFIX="$AUTOPARTS_ROOT" source "$AUTOPARTS_ROOT/share/chruby/chruby.sh"',
          'source "$AUTOPARTS_ROOT/share/chruby/auto.sh"'
        ]
      end

      def tips
        <<-EOF.unindent
          To activate chruby, please restart your shell session.
        EOF
      end

      def rubies_dir
        Path.mkpath(Path.opt + 'rubies')
      end
    end
  end
end
