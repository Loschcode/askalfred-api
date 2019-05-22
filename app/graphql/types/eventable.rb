module Types
  class Eventable < Types::BaseUnion
    possible_types Types::EventMessage, Types::EventFile

    def self.resolve_type(object, context)
      if object.is_a?(::EventMessage)
        Types::EventMessage
      elsif object.is_a?(::EventFile)
        Types::EventFile
      else
        raise "Unexpected Eventable: #{object.inspect}"
      end
    end
  end
end