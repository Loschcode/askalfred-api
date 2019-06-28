class ChangeTicketStatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :status

    add_column :tickets, :canceled_at, :datetime
    add_column :tickets, :completed_at, :datetime
  end
end
