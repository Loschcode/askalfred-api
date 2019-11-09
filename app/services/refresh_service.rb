class RefreshService
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  # for specific resource
  # we need specific response
  def myself
    dispatch(
      channel: 'refreshCurrentIdentity',
      response: { current_identity: identity }
    )
  end

  # for specific resource
  # we need specific response
  def ticket(ticket)
    dispatch(
      channel: 'refreshTicket',
      arguments: { id: ticket.id },
      response: { ticket: ticket }
    )
  end

  def tickets_list
    dispatch(
      channel: 'refreshTicketsList'
    )
  end

  def credits
    dispatch(
      channel: 'refreshCredits'
    )
  end

  private

  def dispatch(channel:, arguments: {}, response: { success: true }, async: true)
    if async
      DispatchSubscriptionWorker.perform_async(
        channel,
        arguments,
        serialize_response_for_worker(response),
        scope
      )
    else
      AskalfredApiSchema.subscriptions.trigger(
        channel,
        arguments,
        response,
        scope
      )
    end
  end

  def serialize_response_for_worker(response)
    response.reduce({}) do |acc, hash|
      key = hash.first
      value = hash.last

      if value.respond_to? :id
        acc.merge(
          "#{key}": {
            id: value.id,
            class_name: value.class.name
          }
        )
      else
        acc.merge("#{key}": value)
      end
    end
  end

  def scope
    {
      scope: identity.id
    }
  end
end
