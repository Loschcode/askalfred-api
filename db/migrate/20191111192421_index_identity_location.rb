class IndexIdentityLocation < ActiveRecord::Migration[5.2]
  def change
    add_index :identities, :location
  end
end
