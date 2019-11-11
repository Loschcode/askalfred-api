class StoreLocationWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'medium'

  def perform(identity_id)
    identity = Identity.find(identity_id)
    response = IpStackService.new(identity.ip).perform

    return if response.empty?

    identity.update!(
      country: response[:country_name],
      region: response[:region_name],
      city: response[:city],
      location: response
    )
  end
end
