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
        env = ["source #{prefix_path}/share/chruby/chruby.sh"]
        if rubies_dir.entries.length > 2
          env << "export RUBIES=(#{rubies_dir + "*"})"
        end
        env
      end

      def tips
        <<-EOF.unindent
        You have succesfully installed chruby

        To activate chruby in the current shell:
          $ eval "$(parts init -)"
        EOF
      end

      def rubies_dir
        path = Path.share + "ruby" + "rubies"
        path.mkpath unless path.exist?
        path
      end
    end
  end
end
