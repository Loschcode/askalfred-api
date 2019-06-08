class EventFile < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  has_one_attached :file

  after_destroy :purge_attached

  def file_path
    if from_amazon?
      file.service.url(file.key,
        disposition: :attachment,
        content_type: file.content_type,
        expires_in: 1.day,
        filename: file.filename
      ).gsub('askalfred.fra1.digitaloceanspaces.com', 'cdn.askalfred.to')
    else
      ActiveStorage::Blob.service.path_for(file.key)
    end
  end

  private

  def purge_attached
    file.purge_later
  end

  def from_amazon?
    file.service.class == ActiveStorage::Service::S3Service
  end
end
