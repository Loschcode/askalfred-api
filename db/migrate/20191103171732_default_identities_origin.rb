class DefaultIdentitiesOrigin < ActiveRecord::Migration[5.2]
  def change
    change_column_default :identities, :origin, {}
  end
end
