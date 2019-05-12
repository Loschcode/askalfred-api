class TicketsEdgeType < GraphQL::Types::Relay::BaseEdge
  node_type(Types::Ticket)
end

module Types
  class TicketsConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: true

    def total_count
      object.nodes.size
    end

    edge_type(TicketsEdgeType)
  end
end