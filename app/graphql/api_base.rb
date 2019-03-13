module ApiBase
  def current_user
    context[:current_user]
  end
end
