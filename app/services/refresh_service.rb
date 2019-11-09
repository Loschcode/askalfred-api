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
      response: { current_identity: identity },
    )
  end

  # for specific resource
  # we need specific response
  def ticket(ticket)
    dispatch(
      channel: 'refreshTicket',
      arguments: { id: ticket.id },
      response: { ticket: ticket },
    )
  end

  def tickets_list
    dispatch(
      channel: 'refreshTicketsList',
      async: false
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
        RedisTransmissionService.serialize(response),
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

  def scope
    {
      scope: identity.id
    }
  end
end
