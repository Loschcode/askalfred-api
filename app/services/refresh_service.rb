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

  def dispatch(channel:, arguments: {}, response: { success: true })
    AskalfredApiSchema.subscriptions.trigger(
      channel,
      arguments,
      response,
      scope: identity.id
    )
  end
end
