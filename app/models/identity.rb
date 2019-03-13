class Identity < ActiveRecord::Base
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: EMAIL_FORMAT },
                    if: -> { role != 'anonymous' }

  validates :encrypted_password, presence: true
  validates :role, presence: true

  validates :token, presence: false

  before_create :ensure_token

  private

  def ensure_token
    self.token = BCrypt::Password.create(token_chain)
  end

  def token_chain
    "#{email}#{encrypted_password}#{Time.now}"
  end
end
