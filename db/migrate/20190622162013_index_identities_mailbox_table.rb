class IndexIdentitiesMailboxTable < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :identities, :mailbox, algorithm: :concurrently
  end
end
