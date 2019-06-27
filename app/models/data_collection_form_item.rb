class DataCollectionFormItem < ActiveRecord::Base
  belongs_to :data_collection
  belongs_to :event_data_collection_form
end
