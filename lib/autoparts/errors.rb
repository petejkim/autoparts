module Autoparts
  class AutopartsError < StandardError
  end

  class ExecutionFailedError < AutopartsError
  end

  class VerificationFailedError < AutopartsError
  end
end
