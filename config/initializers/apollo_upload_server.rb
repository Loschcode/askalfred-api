module ApolloUploadServer
  class GraphQLDataBuilder
    def assign_file(field, splited_path, file)
      if field.is_a? Hash
        field.merge!(splited_path.last => file)
      elsif field.is_a? Array
        field[splited_path.last.to_i] = file
      end
    end
  end

  remove_const :Upload
  Upload = GraphQL::ScalarType.define do
    name "Upload"

    coerce_input ->(value, _ctx) { value }
    coerce_result lambda { |value, _ctx|
      return if value.nil?

      def value.as_json(options = nil)
        instance_values.except("tempfile").as_json(options)
      end
      value
    }
  end
end