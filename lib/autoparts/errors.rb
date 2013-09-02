module Autoparts
  class AutopartsError < StandardError
  end

  class ExecutionFailedError < AutopartsError
    def initialize(cmd)
      super("\"#{cmd}\" failed")
    end
  end

  class VerificationFailedError < AutopartsError
    def initialize(msg = nil)
      super(msg || 'SHA1 verification failed')
    end
  end

  class PackageNotFoundError < AutopartsError
    def initialize(name)
      super("Package \"#{name}\" not found")
    end
  end

  class PackageNotInstalledError < AutopartsError
    def initialize(name = nil)
      super("Package \"#{name}\" not installed")
    end
  end
end
