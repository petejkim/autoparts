module Autoparts
  module Util
    class << self
      def sha1(path)
        `shasum -p #{path}`[/^([0-9a-f]*)/, 1]
      end
    end
  end
end
