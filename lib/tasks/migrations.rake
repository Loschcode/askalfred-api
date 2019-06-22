namespace :migrations do
  desc 'ensure mailboxes for identites without mailbox'
  task ensure_mailboxes: :environment do
    Identity.where(role: 'customer', mailbox: nil).find_each do |identity|
      identity.update mailbox: MailboxService.new(identity).perform
    end
  end
end