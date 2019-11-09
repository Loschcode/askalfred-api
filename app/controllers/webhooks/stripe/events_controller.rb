class Webhooks::Stripe::EventsController < ApiController
  def create
    return render json: { success: false }, status: :bad_request unless event

    case type
    when 'setup_intent.succeeded'
      set_stripe_payment_method_with intent['payment_method']
    when 'payment_intent.succeeded'
      amount = intent['amount']
      time = 3 * amount

      set_stripe_payment_method_with intent['payment_method']

      Credit.create!(
        identity: current_identity,
        stripe_payment_intent_id: intent.id,
        time: time,
        origin: 'charge_customer'
      )
    when 'payment_intent.payment_failed'
      error = intent['last_payment_error']
    end

    refresh_service.credits
    refresh_service.myself

    render json: { success: true }, status: :ok
  end

  private

  def set_stripe_payment_method_with(stripe_payment_method_id)
    if current_identity.stripe_payment_method_id != stripe_payment_method_id
      Stripe::PaymentMethod.attach(
        stripe_payment_method_id,
        customer: current_identity.stripe_customer_id
      )
    end

    # we don't forget to store the last payment method
    # as the payment method reusable after
    current_identity.update! stripe_payment_method_id: stripe_payment_method_id
  end

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
end
