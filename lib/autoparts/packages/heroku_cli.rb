module Autoparts
  module Packages
    class HerokuCli < Package
      name 'heroku-cli'
      version '3.3.0'
      description 'The Heroku CLI is used to manage Heroku apps from the command line.'
      source_url 'https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client.tgz'
      source_sha1 '5c4760414623b3e92bb0deaf5d49da695f8c7ad4'
      source_filetype 'tgz'

      def install
        prefix_path.mkpath
        Dir.chdir('heroku-client') do
          execute 'cp', '-r', '.', prefix_path
        end
      end
    end
  end
end

