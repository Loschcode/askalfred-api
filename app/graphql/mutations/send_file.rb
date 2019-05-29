module Types
  class SendFileInput < Types::BaseInputObject
    description 'send a message to a ticket'
    argument :id, ID, required: true
    argument :file, ApolloUploadServer::Upload, required: true
  end
end

module Mutations
  class SendFile < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::SendFileInput, required: true
    field :ticket, Types::Ticket, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ticket = Ticket.find(input[:id])
      file = input[:file]

      SendFileService.new(
        identity: current_identity,
        ticket: ticket,
        file: file
      ).perform

      {
        ticket: ticket
      }
    end
  end
end