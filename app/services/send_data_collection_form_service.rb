class SendDataCollectionFormService < Base
  class Error < StandardError; end

  attr_reader :identity, :ticket, :body, :data_collections

  def initialize(identity:, ticket:, body:, data_collections:)
    @identity = identity
    @ticket = ticket
    @body = body
    @data_collections = turn_data_collections_from data_collections
  end

  def perform
    transaction do
      throw_errors(event_data_collection_form.errors) if event_data_collection_form.errors.any?
      throw_errors(event.errors) if event.errors.any?

      data_collections.each do |data_collection|
        data_collection.save!

        DataCollectionFormItem.create!(
          data_collection: data_collection,
          event_data_collection_form: event_data_collection_form
        )
      end

      refresh_service.ticket(ticket)
      refresh_service.tickets_list
    end
  end

  private

  def turn_data_collections_from(items)
    items.map do |item|
      next if item['slug'].empty? || item['label'].empty? || item['scope'].empty?

      DataCollection.new(
        identity: ticket.identity,
        ticket: ticket,
        slug: item['slug'],
        label: item['label'],
        scope: item['scope']
      )
    end.compact
  end

  def event_data_collection_form
    @event_data_collection_form ||= EventDataCollectionForm.create(
      body: body,
    )
  end

  def event
    @event ||= Event.create(
      ticket: ticket,
      identity: identity,
      eventable: event_data_collection_form
    )
  end

  # the refresh should always
  # be for the author of the ticket
  def refresh_service
    @refresh_service ||= RefreshService.new(ticket.identity)
  end
end
