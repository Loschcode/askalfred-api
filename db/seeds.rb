require 'bcrypt'
password_hash = BCrypt::Password.create('password')

ActiveRecord::Base.transaction do
  # first customer
  identity = Identity.create!(
    email: 'laurent@askalfred.app',
    role: 'customer',
    encrypted_password: password_hash,
    first_name: 'Laurent',
    last_name: 'Schaffner',
  )

  # bonus credit
  credit = Credit.create!(
    identity: identity,
    time: 1200
  )

  %w(opened processing opened processing canceled completed canceled).each_with_index do |status, index|
    ticket = if index.zero?
      Ticket.create!(
        identity: identity,
        status: status
      )
    else
      Ticket.create!(
      identity: identity,
      title: 'This is a ticket !',
      status: status
    )
    end

    5.times do |time|
      Event.create!(
        ticket: ticket,
        identity: identity,
        eventable: EventMessage.create!(
          body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip'
        )
      )
    end

    Event.create!(
      ticket: ticket,
      identity: identity,
      eventable: EventFile.create!(
        url: 'https://url-of-image.svg'
      )
    )
  end
end