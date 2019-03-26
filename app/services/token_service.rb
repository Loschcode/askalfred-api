class TokenService
  attr_reader :identity

  def initialize(identity)
    @identity = identity
  end

  def perform
    BCrypt::Password.create(token_chain)
  end

  private

  def token_chain
    "#{identity.email}#{identity.encrypted_password}#{Time.now}"
  end
end