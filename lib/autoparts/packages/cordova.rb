# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Cordova < Package
      name "cordova"
      version "3.4.0"

      description "Apache Cordova is a set of device APIs that allow a mobile app developer to" <<
                 " access native device functions."
      category Category::DEVELOPMENT_TOOLS

      source_url "https://www.apache.org/dist/cordova/cordova-3.4.0-src.zip"
      source_sha1 "d65d042339783db988db39a887de05a9ed83923a"
      source_filetype 'zip'

      depends_on "nodejs"

      def install
        prefix_path.parent.mkpath
        execute "npm install -g cordova"
        FileUtils.rm_rf prefix_path
        execute "mv", extracted_archive_path + "#{name}-#{version}", prefix_path
      end

      def post_uninstall
        execute "sudo npm uninstall cordova --prefix /home/action/.parts/lib/"
      end
      
      def tips
        <<-STR.unindent
        
          To create your app with Cordova:
            $ cordova create hello com.example.hello HelloWorld

          In order to build your app, you will need to install a set of target platforms*:
            $ cd hello
            $ cordova platform add amazon-fireos
            $ cordova platform add android
            $ cordova platform add firefoxos
            $ cordova platform add ubuntu
            $ cordova build                                                                                                                                                       
            $ cordova serve android      

          *IMPORTANT: Your ability to run these commands depends on whether you have already installed each SDK.

        STR
      end      
    end
  end
end
