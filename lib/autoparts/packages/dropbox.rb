module Autoparts
  module Packages
    class Dropbox < Package
      name 'dropbox'
      version '2.6.27'
      description 'Dropbox: a cloud synchronization service.'
      category Category::UTILITIES

      source_url 'http://www.dropbox.com/download/?plat=lnx.x86_64'
      source_sha1 '004a72d46ebd8a28cc96cc9baf05b233219aba3c'
      source_filetype 'tar.gz'

      def install
        bin_path.mkpath
        execute 'mv', extracted_archive_path + '.dropbox-dist', prefix_path
        execute 'wget', '-O', manage_script, "https://www.dropbox.com/download?dl=packages/dropbox.py"
        execute 'chmod', '+x', manage_script
        execute 'wget', '-O', bin_path + 'dropbox_init', 'https://gist.githubusercontent.com/MaximKraev/9929674/raw/3b979dbed8fc93346d87fcab87da9e3b60c513d0/dropbox_init'
        execute 'chmod', '+x', bin_path + 'dropbox_init'
      end

      def manage_script
        bin_path + 'dropbox.py'
      end
      
      def post_install
        # put dropbox on proper location
        execute 'ln', '-s', dropbox_dist, dropbox_user_dist 
      end
      
      def dropbox_dist
        prefix_path + '.dropbox-dist'
      end
      
      def dropbox_user_dist
        Path.home + '.dropbox-dist'
      end
      
      def post_uninstall        
          FileUtils.rm_rf(dropbox_user_dist) if dropbox_user_dist.symlink?
      end
      
      def stop
        execute manage_script, 'stop'
      end
      
      def start
        execute manage_script, 'start'
      end
      
      def running?
        !system( manage_script.to_s, 'running', out: '/dev/null', err: '/dev/null')
      end
      
      def purge
        FileUtils.rm_rf Path.home + '.dropbox' if File.exist?(Path.home + '.dropbox')
      end
      
      def tips
        <<-EOS.unindent
        
        Please refer to https://codio.com/s/docs/specifics/dropbox/ for a comprehensive explanation of how to configure Codio for Dropbox operations.
            
        EOS
      end
    end
  end
end

