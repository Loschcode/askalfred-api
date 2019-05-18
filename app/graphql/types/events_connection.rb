class EventsEdgeType < GraphQL::Types::Relay::BaseEdge
  node_type Types::Event
end

module Types
  class EventsConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: true

    def total_count
      object.nodes.size
    end

    edge_type EventsEdgeType
  end
end
