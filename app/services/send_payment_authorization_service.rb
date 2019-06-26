class SendPaymentAuthorizationService < Base
  class Error < StandardError; end
  BASE_FEES = 1.4 # %

  attr_reader :identity, :ticket, :body, :line_items, :fees_formula

  def initialize(identity:, ticket:, body:, line_items:, fees_formula:)
    @identity = identity
    @ticket = ticket
    @body = body
    @line_items = sanitize_items_from line_items
    @fees_formula = fees_formula
  end

  def perform
    transaction do
      throw_errors(event_payment_authorization.errors) if event_payment_authorization.errors.any?
      throw_errors(event.errors) if event.errors.any?

      refresh_service.ticket(ticket)
      refresh_service.tickets_list
    end
  end

  private

  def sanitize_items_from(items)
    items.map do |item|
      next if item['amount_in_cents'].empty? || item['label'].empty?

      {
        amount_in_cents: item['amount_in_cents'].to_i,
        label: item['label']
      }
    end.compact
  end

  def amount_in_cents
    line_items.map { |item| item[:amount_in_cents] }.sum
  end

  def fees_in_cents
    case fees_formula
    when :automatic
      (amount_in_cents * (BASE_FEES / 100)).ceil
    when :free
      0
    else
      raise Error, 'Fee option not recognized. Please choose between automatic and free.'
    end
  end

  def event_payment_authorization
    @event_payment_authorization ||= EventPaymentAuthorization.create(
      body: body,
      line_items: line_items,
      fees_in_cents: fees_in_cents
    )
  end

  def event
    @event ||= Event.create(
      ticket: ticket,
      identity: identity,
      eventable: event_payment_authorization
    )
  end

  # the refresh should always
  # be for the author of the ticket
  def refresh_service
    @refresh_service ||= RefreshService.new(ticket.identity)
  end
end
