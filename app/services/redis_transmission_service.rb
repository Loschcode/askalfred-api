class RedisTransmissionService
  class << self
    def serialize(response)
      response.reduce({}) do |acc, hash|
        key = hash.first
        value = hash.last

        end_value = if to_serialize?(value)
          serialized_hash_from value
        else
          value
        end

        acc.merge("#{key}": end_value)
      end
    end

    def deserialize(response)
      response.reduce({}) do |acc, hash|
        key = hash.first.to_sym
        value = hash.last.symbolize_keys

        end_value = if to_deserialize?(value)
          record_from value
        else
          value
        end

        acc.merge "#{key}": end_value
      end
    end

    private

    def serialized_hash_from(value)
      {
        id: value.id,
        class_name: value.class.name
      }
    end

    def to_serialize?(value)
      value.respond_to? :id
    end

    def to_deserialize?(value)
      value.is_a?(Hash) && value[:class_name].present?
    end

    def record_from(value)
      value[:class_name].constantize.find(value[:id])
    end
  end
end