class SendFileService < Base
  attr_reader :identity, :ticket, :file

  def initialize(identity:, ticket:, file:)
    @identity = identity
    @ticket = ticket
    @file = file
  end

  def perform
    Aws.use_bundled_cert!

    transaction do
      event_file.file.attach(file)

      throw_errors('We could not store this file.') unless event_file.file.attached?
      throw_errors(event.errors) if event.errors.any?

      refresh_service.ticket(ticket)
      refresh_service.tickets_list
    end
  end

  private

  def event_file
    @event_file ||= EventFile.create
  end

  def event
    @event ||= Event.create(
      ticket: ticket,
      identity: identity,
      eventable: event_file
    )
  end

  # the refresh should always
  # be for the author of the ticket
  def refresh_service
    @refresh_service ||= RefreshService.new(ticket.identity)
  end
end
