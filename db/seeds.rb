require 'bcrypt'
password_hash = BCrypt::Password.create('password')

ActiveRecord::Base.transaction do
  # first customer
  identity = Identity.create!(
    email: 'laurent@askalfred.to',
    role: 'customer',
    encrypted_password: password_hash,
    first_name: 'Laurent',
    last_name: 'Schaffner',
  )

  identity.update! mailbox: MailboxService::Setup.new(identity).perform

  # admin
  identity_admin = Identity.create!(
    email: 'admin@askalfred.to',
    role: 'admin',
    encrypted_password: password_hash,
    first_name: 'Admin',
    last_name: 'Schaffner',
  )

  identity_admin.update! mailbox: MailboxService::Setup.new(identity_admin).perform

  # bonus credit
  credit = Credit.create!(
    identity: identity,
    time: 1200,
    origin: 'registration_bonus'
  )

  %w(opened processing opened processing canceled completed canceled processing canceled completed canceled).each_with_index do |status, index|
    attributes = {
      identity: identity,
      subject: 'This is a random subject'
    }

    if status == 'canceled'
      attributes.merge!(
        canceled_at: Time.now
      )
    end

    if status == 'completed'
      attributes.merge!(
        completed_at: Time.now
      )
    end

    unless index.zero?
      attributes.merge!(
       title: 'This is a ticket !'
      )
    end

    ticket = Ticket.create!(attributes)

    # if it's just opened
    # we don't need more than that
    next if ticket.status == 'opened'

    5.times do |time|
      Event.create!(
        ticket: ticket,
        identity: [identity, identity_admin].sample,
        eventable: EventMessage.create!(
          body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip'
        )
      )
    end

    # Event.create!(
    #   ticket: ticket,
    #   identity: identity,
    #   eventable: EventFile.new(
    #     url: 'https://url-of-image.svg'
    #   )
    # )
  end
end