class ChangeIdentitiesMailboxTable < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :mailbox, :string
  end
end
