module Autoparts
  module Packages
    class TeeClc < Package
      name 'tee-clc'
      version '12.0.0'
      description 'Command-line Client for Team Foundation Server'
      source_url 'http://download.microsoft.com/download/F/0/4/F04E054B-9DB5-4C24-AF84-DF1A290F5C73/TEE-CLC-12.0.0.zip'
      source_sha1 '3089f6d1b233a015aa05c9ad12dd4ac653f9ad8a'
      source_filetype 'zip'
      category Category::DEPLOYMENT

      def install
          bin_path.mkpath
          clc_install_path.mkpath
        Dir.chdir('TEE-CLC-12.0.0') do
          execute 'cp', '-r', '.', clc_install_path
        end
        #execute 'ln', '-s', (clc_install_path + 'tf'), (bin_path + 'tf')
        File.open(clc_bin_path, 'w') { |f| f.write clc_wrapper }
        execute 'chmod', '+x', clc_bin_path
      end

      def clc_wrapper
        <<-EOS.unindent
          #!/bin/bash
          #{clc_install_path}/tf "$@"
        EOS
      end

      def clc_bin_path
        bin_path + 'tf'
      end

      def clc_install_path
        prefix_path + 'tee-clc'
      end
    end
  end
end
