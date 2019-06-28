class IndexTicketStatus < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :tickets, :canceled_at, algorithm: :concurrently
    add_index :tickets, :completed_at, algorithm: :concurrently
  end
end
