module Autoparts
  module Packages
    class Grails < Package
      name 'grails'
      version '2.3.7'
      description 'Grails: an Open Source, full stack, web application framework for the JVM.'
      source_url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.3.7.zip'
      source_sha1 '295f37fe989e8b3784258fcc14d2749737d8a2d0'
      source_filetype 'zip'

      depends_on 'groovy'

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'cp', '-r', '.', prefix_path
        end
        Dir.glob(prefix_path.to_s + '/bin/*.bat').each { |f| File.delete(f) }
      end

      def env_content
        <<-EOS.unindent
          export JAVA_HOME=/usr
          export GRAILS_HOME=#{prefix_path}
        EOS
      end
      def env_file
        Path.env + 'grails'
      end

      def post_install
        File.write(env_file, env_content)
      end

      def post_uninstall
        env_file.unlink if env_file.exist?
      end

      def tips
        <<-EOS.unindent

         Close and open terminal to have grails working after the install.

         Or run:
          . ~/.bash_profile
        EOS
      end
    end
  end
end

