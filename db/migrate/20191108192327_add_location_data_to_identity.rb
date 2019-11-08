class AddLocationDataToIdentity < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :city, :string
    add_column :identities, :country, :string
    add_column :identities, :region, :string
    add_column :identities, :timezone, :string
    add_column :identities, :user_agent, :string
    add_column :identities, :ip, :string
  end
end
