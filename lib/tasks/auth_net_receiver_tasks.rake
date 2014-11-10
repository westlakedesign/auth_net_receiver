# desc "Explaining what the task does"
# task :auth_net_receiver do
#   # Task goes here
# end

namespace :auth_net_receiver do

  desc 'Process raw Authorize.Net transactions'
  task :process => :environment do
    logger.debug 'Processing Authorize.Net transactions...'
    result = AuthNetReceiver::RawTransaction.process_all!
    logger.debug 'Done!'
    logger.debug "- #{result[:authentic]} authentic"
    logger.debug "- #{result[:errors]} errrors"
    logger.debug "- #{result[:forgeries]} forgeries"
  end

  def logger
    @_logger = Logger.new(STDOUT) if @_logger.nil?
    return @_logger
  end

end
