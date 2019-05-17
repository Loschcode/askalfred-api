class EventMessagesEdgeType < GraphQL::Types::Relay::BaseEdge
  node_type(Types::EventMessage)
end

module Types
  class EventMessagesConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: true

    def total_count
      object.nodes.size
    end

    edge_type(EventMessagesEdgeType)
  end
end