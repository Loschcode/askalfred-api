class IndexLocationDataToIdentity < ActiveRecord::Migration[5.2]
  def change
    add_index :identities, :city
    add_index :identities, :country
    add_index :identities, :region
    add_index :identities, :timezone
    add_index :identities, :user_agent
    add_index :identities, :ip
  end
end
