module Types
  class SendMessageInput < Types::BaseInputObject
    description 'send a message to a ticket'
    argument :id, ID, required: true
    argument :message, String, required: true
  end
end

module Mutations
  class SendMessage < Mutations::BaseMutation
    description 'send a message to a specific ticket'

    argument :input, Types::SendMessageInput, required: true
    field :ticket, Types::Ticket, null: false

    def resolve(input:)
      return GraphQL::ExecutionError.new('Your identity was not recognized.') unless current_identity

      ticket = Ticket.find(input[:id])
      body = input[:message]

      SendMessageService.new(
        identity: current_identity,
        ticket: ticket,
        body: body
      ).perform

      {
        ticket: ticket
      }
    end
  end
end