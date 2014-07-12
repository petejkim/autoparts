# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class LibSodium < Package
      name 'libsodium'
      version '0.6.0'
      description 'Sodium: a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more.'
      category Category::LIBRARIES

      source_url 'https://download.libsodium.org/libsodium/releases/libsodium-0.6.0.tar.gz'
      source_sha1 'd3e321bd3ca216ad7a2404aa05b31daf2b58e1c6'
      source_filetype 'tar.gz'

      def compile
          Dir.chdir('libsodium-0.6.0') do
          args = [
              "--prefix=#{prefix_path}",
          ]

          execute './configure', *args
          execute 'make'
          execute 'make', 'check'
        end
      end

      def install
          Dir.chdir('libsodium-0.6.0') do
            prefix_path.parent.mkpath
            FileUtils.rm_rf prefix_path
            args = [
                "install",
            ]
            execute 'make', *args
          end
      end

    end
  end
end
