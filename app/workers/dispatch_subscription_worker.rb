# this worker trigger subscription updates for AskAlfred in an asynchronous way
# it speed up the step by step processing at tremendous speed.
class DispatchSubscriptionWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'critical'

  def perform(channel, arguments, response, scope)
    AskalfredApiSchema.subscriptions.trigger(
      channel,
      arguments,
      deserialize_response_for_worker(response),
      scope
    )
  end

  def deserialize_response_for_worker(response)
    response.reduce({}) do |acc, hash|
      key = hash.first.to_sym
      value = hash.last.symbolize_keys

      if value.is_a?(Hash) && value[:class_name].present?
        entry = value[:class_name].constantize.find(value[:id])
        acc.merge({ "#{key}": entry })
      else
        acc.merge({ "#{key}": value })
      end
    end
  end
end
