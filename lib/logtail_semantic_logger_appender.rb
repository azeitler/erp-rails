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
                    when :trace, :debug then Logtail::Logger::DEBUG
                    when :info then Logtail::Logger::INFO
                    when :warn then Logtail::Logger::WARN
                    when :error then Logtail::Logger::ERROR
                    when :fatal then Logtail::Logger::FATAL
                    else Logtail::Logger::INFO
                    end

    # Send the log message to Logtail
    @logtail_logger.add(logtail_level, log.message, log.payload)
  end
end
