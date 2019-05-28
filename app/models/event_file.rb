class EventFile < ActiveRecord::Base
  has_one :event, as: :eventable
  accepts_nested_attributes_for :event

  has_one_attached :file

  def file_path
    # short helper to get the path of the file
    # it is not the file object in itself, it takes it from it
    # via ActiveStorage
    ActiveStorage::Blob.service.path_for(file.key)
  end
end
