module Autoparts
  module Packages
    class Lua < Package
      name 'lua'
      version '5.2.2'
      description 'Lua is a powerful, fast, lightweight, embeddable scripting language.'
      source_url 'http://www.lua.org/ftp/lua-5.2.2.tar.gz'
      source_sha1 '0857e41e5579726a4cb96732e80d7aa47165eaf5'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/lua-5.2.2-binary.tar.gz'
      binary_sha1 '25bf645ee5dfffdb448b942a1873e653283fdd23'

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
