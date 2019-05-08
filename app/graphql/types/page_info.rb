module Types
  class PageInfo < Types::BaseObject
    description 'page info'

    field :total_count, Integer, null: false
    field :has_previous_page, Boolean, null: false
    field :has_next_page, Boolean, null: false
  end
end
