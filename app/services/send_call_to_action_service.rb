class SendCallToActionService < ::Base
  attr_reader :identity, :ticket, :body, :link, :label

  def initialize(identity:, ticket:, body:, link:, label:)
    @identity = identity
    @ticket = ticket
    @body = body
    @link = link
    @label = label
  end

  def perform
    transaction do
      throw_errors(event_call_to_action.errors) if event_call_to_action.errors.any?
      throw_errors(event.errors) if event.errors.any?

      refresh_service.ticket(ticket)
      refresh_service.tickets_list
    end
  end

  private

  def event_call_to_action
    @event_call_to_action ||= EventCallToAction.create(body: body, label: label, link: link)
  end

  def event
    @event ||= Event.create(
      ticket: ticket,
      identity: identity,
      eventable: event_call_to_action
    )
  end

  # the refresh should always
  # be for the author of the ticket
  def refresh_service
    @refresh_service ||= RefreshService.new(ticket.identity)
  end
end