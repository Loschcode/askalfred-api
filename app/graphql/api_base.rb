module ApiBase
  def current_identity
    context[:current_identity]
  end

  def refresh_service
    @refresh_service ||= RefreshService.new(current_identity)
  end

  def tracking_service
    @tracking_service ||= TrackingService.new(current_identity)
  end
end
