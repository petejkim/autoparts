module Autoparts
  module Packages
    class Lua < Package
      name 'lua'
      version '5.2.2'
      description 'Lua: A powerful, fast, lightweight, embeddable scripting language'
      source_url 'http://www.lua.org/ftp/lua-5.2.2.tar.gz'
      source_sha1 '0857e41e5579726a4cb96732e80d7aa47165eaf5'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('lua-5.2.2') do
          execute 'make', 'linux'
        end
      end

      def install
        Dir.chdir('lua-5.2.2') do
          execute 'make', 'install', "INSTALL_TOP=#{prefix_path}", "INSTALL_MAN=#{man_path}/man1"
        end
      end
    end
  end
end
