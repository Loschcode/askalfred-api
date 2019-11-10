# this worker trigger subscription updates for AskAlfred in an asynchronous way
# it speed up the step by step processing at tremendous speed.
class DispatchSubscriptionWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'critical'

  def perform(channel, arguments, response, scope)
    AskalfredApiSchema.subscriptions.trigger(
      channel,
      arguments,
      RedisTransmissionService.deserialize(response),
      scope.deep_symbolize_keys
    )
  end
end
