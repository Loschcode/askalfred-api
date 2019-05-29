class Base
  def transaction(&block)
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def throw_errors(errors)
    as_string = if errors.respond_to? :full_messages
                  errors.full_messages.join(', ')
                elsif errors.respond_to? :join
                  errors.join(', ')
                else
                  errors.to_s
                end

    raise GraphQL::ExecutionError.new as_string
  end
end