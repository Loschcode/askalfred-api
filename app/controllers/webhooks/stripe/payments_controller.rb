class Webhooks::Stripe::PaymentsController < ApiController
  def create
    return render json: { success: false }, status: :bad_request unless event

    case type
    when 'payment_intent.succeeded'
      amount = intent['amount']
      time = 3 * amount

      Credit.create!(
        identity: current_identity,
        stripe_intent_id: intent.id,
        time: time,
        origin: 'charge_customer'
      )
    when 'payment_intent.payment_failed'
      error = intent['last_payment_error']
      tracking_service.payment_failed(error)
    end

    refresh_service.credits
    refresh_service.myself

    render json: { success: true }, status: :ok
  end

  private

  def payload
    request.body.read
  end

  def signature_header
    request.env['HTTP_STRIPE_SIGNATURE']
  end

  def event
    @event ||= begin
      Stripe::Webhook.construct_event(payload, signature_header, stripe_webhook_secret)
    rescue JSON::ParserError => exception
      false
    rescue Stripe::SignatureVerificationError => exception
      false
    end
  end

  def stripe_webhook_secret
    ENV['STRIPE_WEBHOOK_SECRET']
  end

  def intent
    event['data']['object']
  end

  def type
    event['type']
  end

  def current_identity
    @current_identity ||= Identity.find(intent['metadata']['identity_id'])
  end

  def refresh_service
    @refresh_service ||= RefreshService.new(current_identity)
  end

  def tracking_service
    @tracking_service ||= TrackingService.new(current_identity)
  end
end
