class EventFile < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  has_one_attached :file

  after_destroy :purge_attached

  def file_path
    # short helper to get the path of the file
    # it is not the file object in itself, it takes it from it
    # via ActiveStorage
    ActiveStorage::Blob.service.path_for(file.key)
  end

  private

  def purge_attached
    file.purge_later
  end
end
