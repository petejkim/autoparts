# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class LibSodium < Package
      name 'libsodium'
      version '0.7.1'
      description 'Sodium: a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more.'
      category Category::LIBRARIES

      source_url 'http://download.libsodium.org/libsodium/releases/libsodium-0.7.1.tar.gz'
      source_sha1 'd0a4cfcc1f5a0717d5b3e77e6c4489595a15089e'
      source_filetype 'tar.gz'

      def compile
          Dir.chdir('libsodium-0.7.1') do
          args = [
              "--prefix=#{prefix_path}",
          ]

          execute './configure', *args
          execute 'make'
          execute 'make', 'check'
        end
      end

      def install
          Dir.chdir('libsodium-0.7.1') do
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
