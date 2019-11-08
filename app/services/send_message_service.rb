class SendMessageService < ::Base
  attr_reader :identity, :ticket, :body

  def initialize(identity:, ticket:, body:)
    @identity = identity
    @ticket = ticket
    @body = body
  end

  def perform
    transaction do
      throw_errors(event_message.errors) if event_message.errors.any?
      throw_errors(event.errors) if event.errors.any?

      refresh_service.ticket(ticket)
      refresh_service.tickets_list
    end
  end

  private

  def event_message
    @event_message ||= EventMessage.create(body: body)
  end

  def event
    @event ||= Event.create(
      ticket: ticket,
      identity: identity,
      eventable: event_message
    )
  end

  # the refresh should always
  # be for the author of the ticket
  def refresh_service
    @refresh_service ||= RefreshService.new(ticket.identity)
  end
end
