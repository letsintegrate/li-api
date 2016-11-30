class V1::PageSerializer < ActiveModel::Serializer
  attributes :id, :slug, :title_translations, :content_translations
end
