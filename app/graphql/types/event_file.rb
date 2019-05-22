module Types
  class EventFile < Types::BaseObject
    field :id, ID, null: false
    field :file_path, String, null: false

    def file_path
      # short helper to get the path of the file
      # it is not the file object in itself, it takes it from it
      # via ActiveStorage
      ActiveStorage::Blob.service.path_for(object.file.key)
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :event, Types::Event, null: false
  end
end

