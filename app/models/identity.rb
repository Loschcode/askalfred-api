class Identity < ActiveRecord::Base
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
  validates :email, presence: true, if: -> { role != 'guest' }
  validates :email, uniqueness: true, format: { with: EMAIL_FORMAT }

  validates :encrypted_password, presence: true, if: -> { role != 'guest' }
  validates :role, presence: true

  validates :token, presence: false
  validates :confirmed_at, presence: false

  before_create :ensure_token

  private

  def ensure_token
    self.token = BCrypt::Password.create(token_chain)
  end

  def token_chain
    "#{email}#{encrypted_password}#{Time.now}"
  end
end
