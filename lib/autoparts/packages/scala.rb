module Autoparts
  module Packages
    class Scala < Package
      name 'scala'
      version '2.10.2'
      description 'Scala: An object-functional programming language'
      source_url 'http://www.scala-lang.org/files/archive/scala-2.10.2.tgz'
      source_sha1 '86b4e38703d511ccf045e261a0e04f6e59e3c926'
      source_filetype 'tgz'

      def install
        Dir.chdir('scala-2.10.2') do
          prefix_path.mkpath
          execute 'cp', '-R', '.', prefix_path
        end
      end
    end
  end
end