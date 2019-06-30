module Types
  class DataCollectionInput < Types::BaseInputObject
    argument :id, ID, required: true
    argument :value, String, required: true
  end
end

module Types
  class SendDataCollectionFormInput < Types::BaseInputObject
    argument :event_id, ID, required: true
    argument :data_collections, [Types::DataCollectionInput], required: true
  end
end

module Mutations
  class SendDataCollectionForm < Mutations::BaseMutation
    argument :input, Types::SendDataCollectionFormInput, required: true
    field :success, Boolean, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ActiveRecord::Base.transaction do
        event = Event.find(input[:event_id])
        data_collection_form = event.eventable
        ticket = event.ticket

        input[:data_collections].map do |data_collection|
          current_identity.data_collections.find(data_collection[:id]).update(
            value: data_collection[:value]
          )
        end

        data_collection_form.update sent_at: Time.now

        if data_collection_form.errors.any?
          raise GraphQL::ExecutionError.new data_collection_form.errors.full_messages.join(', ')
        end

        refresh_service.ticket(ticket)

        {
          success: true
        }
      end
    end
  end
end
