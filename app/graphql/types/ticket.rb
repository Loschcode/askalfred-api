module Types
  class Ticket < Types::BaseObject
    description 'ticket'

    field :id, ID, null: false

    field :identity, Types::Identity, null: false
    field :title, String, null: true
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages_connection, Types::EventMessage.connection_type, null: true
    def messages_connection
      object.event_messages
    end

    # field :page_info, Types::PageInfo, null: true

    # def page_info
    #   {
    #     total_count: 10,
    #     has_next_page: false,
    #     has_previous_page: false
    #   }
    # end
  end
end
