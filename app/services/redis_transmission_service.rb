class RedisTransmissionService
  class << self
    def serialize(response)
      response.reduce({}) do |acc, hash|
        key = hash.first
        value = hash.last

        if value.respond_to? :id
          acc.merge(
            "#{key}": {
              id: value.id,
              class_name: value.class.name
            }
          )
        else
          acc.merge("#{key}": value)
        end
      end
    end

    def deserialize(response)
      response.reduce({}) do |acc, hash|
        key = hash.first.to_sym
        value = hash.last.symbolize_keys

        if value.is_a?(Hash) && value[:class_name].present?
          entry = value[:class_name].constantize.find(value[:id])
          acc.merge({ "#{key}": entry })
        else
          acc.merge({ "#{key}": value })
        end
      end
    end
  end
end