module V1
  class PageSerializer < BaseSerializer
    attributes :id, :title_translations, :content_translations

    # Relationships
    has_many_link :menu_items, filter: :page_id_eq
    has_many_link :widgets, filter: :page_id_eq
  end
end
