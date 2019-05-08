# class Types::TicketEdge < GraphQL::Types::Relay::BaseEdge
#   node_type(Types::Ticket)
# end

# class PostConnectionWithTotalCountType < GraphQL::Types::Relay::BaseConnection
#   edge_type(Types::TicketEdge)

#   field :total_count, Integer, null: false
#   def total_count
#     object.nodes.size
#   end
# end

module Types
  class Ticket < Types::BaseObject
    description 'ticket'

    field :id, ID, null: false

    field :identity, Types::Identity, null: false
    field :title, String, null: true
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :messages, [Types::EventMessage], null: true do
      argument :input, Types::EventMessageInput, required: false
    end

    def messages(input: {})
      messages = object.event_messages
      messages = messages.limit(input[:limit]) if input[:limit].present?
      messages
    end

    field :page_info, Types::PageInfo, null: true

    def page_info
      {
        total_count: 10,
        has_next_page: false,
        has_previous_page: false
      }
    end
  end
end
