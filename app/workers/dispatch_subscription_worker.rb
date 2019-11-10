# this worker trigger subscription updates for AskAlfred in an asynchronous way
# it speed up the step by step processing at tremendous speed.
class DispatchSubscriptionWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'critical'

  def perform(channel, arguments, response, scope)
    TrackingService::Slack.new(Identity.first).track('DISPATCH SUBSCRIPTION WORKER', {'random': true})
    AskalfredApiSchema.subscriptions.trigger(
      channel,
      arguments,
      RedisTransmissionService.deserialize(response),
      scope
    )
    TrackingService::Slack.new(Identity.first).track("END DISPATCH SUBSCRIPTION WORKER", { 'random': true })
  end
end
