module Types
  class Ticket < Types::BaseObject
    description 'ticket'

    field :id, ID, null: false

    field :identity, Types::Identity, null: false
    field :title, String, null: true
    field :subject, String, null: true
    field :status, String, null: true

    field :origin, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :events_connection, Types::EventsConnection, null: true

    def events_connection
      object.events.order(created_at: :asc)
    end

    field :messages_connection, Types::EventMessagesConnection, null: true

    def messages_connection
      object.event_messages.order(created_at: :asc)
    end

    # field :files_connection, Types::EventFilesConnection, null: true

    # def files_connection
    #   object.event_files.order(created_at: :asc)
    # end

    field :last_message_from_alfred, Types::EventMessage, null: true

    def last_message_from_alfred
      object.event_messages.where.not(events: { identity: context[:current_identity] }).order(created_at: :desc).first
    end
  end
end
