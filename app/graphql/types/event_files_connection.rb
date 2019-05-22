class EventFilesEdgeType < GraphQL::Types::Relay::BaseEdge
  node_type(Types::EventFile)
end

module Types
  class EventFilesConnection < GraphQL::Types::Relay::BaseConnection
    field :total_count, Integer, null: true

    def total_count
      object.nodes.size
    end

    edge_type(EventFilesEdgeType)
  end
end