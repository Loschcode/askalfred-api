module Types
  class DataCollection < Types::BaseObject
    field :id, ID, null: false
    field :label, String, null: false
    field :scope, String, null: false
    field :slug, String, null: false
    field :value, String, null: true
  end
end