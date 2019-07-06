class Identity < ActiveRecord::Base
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze
  validates :email, presence: true, unless: -> { guest? }
  validates :email, uniqueness: true, format: { with: EMAIL_FORMAT }, if: -> { email.present? }

  validates :encrypted_password, presence: true, unless: -> { guest? || recovery_token.present? }
  validates :role, presence: true

  validates :mailbox, presence: false
  validates :token, presence: false

  validates :confirmed_at, presence: false
  validates :confirmation_sent_at, presence: false
  validates :confirmation_token, presence: false
  validates :recovery_sent_at, presence: false
  validates :recovery_token, presence: false

  validates :stripe_customer_id, presence: false
  validates :stripe_payment_method_id, presence: false

  validates :terms_accepted_at, presence: false
  validates :email_opt_out_at, presence: false

  has_many :data_collections, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :mailbox_mails, dependent: :destroy

  before_create :ensure_token

  def guest?
    role == 'guest'
  end

  private

  def ensure_token
    self.token = TokenService.new(self).perform
  end
end
