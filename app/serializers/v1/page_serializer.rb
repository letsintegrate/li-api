module V1
  class PageSerializer < BaseSerializer
    attributes :id, :slug, :title_translations, :content_translations
  end
end
