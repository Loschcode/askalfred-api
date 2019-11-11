class AddIdentityLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :location, :jsonb
  end
end
