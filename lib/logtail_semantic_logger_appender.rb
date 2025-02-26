
require 'semantic_logger'
require 'logtail'

class LogtailSemanticLoggerAppender < SemanticLogger::Subscriber
  def initialize(logtail_logger)
    super()
    @logtail_logger = logtail_logger
  end

  # This method is called by Semantic Logger to log messages
  def log(log)
    # Map Semantic Logger log levels to Logtail log levels
    logtail_level = case log.level
                    when :trace, :debug then :debug
                    when :info then :info
                    when :warn then :warn
                    when :error then :error
                    when :fatal then :fatal
                    else :info
                    end

    # Send the log message to Logtail
    @logtail_logger.add(logtail_level, log.message, log.payload)
  end
end
