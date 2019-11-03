class AddIdentitiesOrigin < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :origin, :jsonb
  end
end
