require "autoparts/string"

module Autoparts
  module Commands
    class Search
      def initialize(args, options)
        begin
          Pathname.new("#{PROJECT_ROOT}/lib/autoparts/packages").children.sort.each do |f|
            require "autoparts/packages/#{f.basename.sub_ext('')}" if f.extname == '.rb'
          end
        rescue LoadError
        end
        packages = Package.packages
        if args.length > 0
          packages = packages.select { |name, _| name.include? args[0] }
        end
        if packages.length > 0
          list = {}
          packages.each_pair do |name, package_class|
            package = package_class.new
            list["#{name}".bold.magenta + " (#{package.version})".green] = package.description
          end
          unless list.empty?
            colors_length = ''.bold.magenta.green.length
            ljust_length = list.keys.map(&:length).max + 1
            columns = `tput cols`.to_i
            format = "%-#{ljust_length}s %s\n"
            list.each_pair do |name, description|
              if (description.length + ljust_length < columns)
                printf format, name, description
              else
                descriptions = split_description description, columns - ljust_length + colors_length - 4
                descriptions.each do |description|
                  printf format, name, description
                  name = ' '.bold.magenta.green
                end
              end
            end
          end
        else
          abort "parts: no package found for \"#{args[0]}\""
        end
      end

      def split_description(description, length)
        words = description.strip.split(' ');
        result = []
        line = ""
        words.each do |word|
          if line.length + word.length > length
            result.push(line)
            line = ""
          end
          if line.length > 0
            line = [line, word].join(' ')
          else
            line = word
          end
        end
        result.push(line) if line.length > 0
        result
      end
    end
  end
end