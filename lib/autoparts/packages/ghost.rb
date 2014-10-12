module Autoparts
	module Packages
		class Ghost < Package
			name 'ghost'
			version '0.5.2'
      description "Ghost: Just A Blogging Platform"
      category Category::WEB_DEVELOPMENT

      source_url 'https://ghost.org/zip/ghost-0.5.2.zip'
      source_sha1 '1505a962395eef123e813a8c24052288013b8d81'
      source_filetype 'zip'

      # Dependencies
      depends_on 'nodejs'

      # Installation
      def install
        Dir.chdir(extracted_archive_path) do
          ghost_path.mkpath
          execute "mv * #{ghost_path}"
        end
        Dir.chdir(ghost_path) do
          execute "npm", "install", "--production"
        end
      end

      def post_install
        Dir.chdir(ghost_path) do
          execute "cp config.example.js config.js"
          execute "sed -i \"s/host: '127.0.0.1',/host: '0.0.0.0',/\" config.js"
          execute "sed -i \"s/port: '2368'/port: '4000'/\" config.js"
          # execute "sed -i \"s/url: 'http:\/\/my-ghost-blog.com',/url: 'http:\/\/#{hostname}:4000',/\" config.js"
          # execute "sed -i \"s/url: 'http:\/\/localhost:2368',/url: 'http:\/\/#{hostname}:4000',/\" config.js"
          execute "sed -i \"s/my-ghost-blog.com/#{hostname}.use1-2.nitrousbox.com:4000/\" config.js"
          execute "sed -i \"s/localhost:2368/#{hostname}.use1-2.nitrousbox.com:4000/\" config.js"
        end
      end

      def ghost_path
        prefix_path
      end

      def hostname
        `hostname`.chop
      end

      def start
        Dir.chdir(ghost_path) do
          execute 'npm start'
        end
      end
      
      # This won't work - use Ctrl+C to terminate process.
      def stop
        Dir.chdir(ghost_path) do
          execute 'npm stop'
        end
      end

      def running?
        !!system(ghost_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-EOS.unindent
          You're ready to blog with Ghost!
          
          To start Ghost up, use:
            $parts start ghost

          To terminate your Ghost instance, use Ctrl+C.

          By default, Ghost runs on port 4000 and is bound to all interfaces (0.0.0.0).
          These settings can be changed inside your config.js. 

          ENJOY!
        EOS
      end
    end
  end
end
