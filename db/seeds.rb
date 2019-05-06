require 'bcrypt'
password_hash = BCrypt::Password.create('password')

# first customer
identity = Identity.create!!(
  email: 'laurent@askalfred.app',
  role: 'customer',
  encrypted_password: password_hash,
  first_name: 'Laurent',
  last_name: 'Schaffner',
)

# bonus credit
credit = Credit.create!(
  time: 1200
)

# first ticket 
ticket  = Ticket.create!(
  identity: identity,
  title: 'This is a ticket !',
  status: 'waiting'
)

# message inside the ticket 
message = EventMessage.create!(
  body: 'This is a message!'
)

# we link the ticket  with the message through event
event = Event.create!(
  ticket : ticket ,
  identity: identity,
  eventable: message
)