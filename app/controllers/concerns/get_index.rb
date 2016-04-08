# Setting the default URL options on the serializer context. This is required
# for the serializers to be able to generate link URLs.
#
module Concerns
  module GetIndex
    def get_index(klass)
      filter   = klass.ransack(params[:filter])
      relation = filter.result
      relation = get_index_id_filter(relation)
      relation
    end

    def get_index_id_filter(relation)
      return relation unless params[:ids]
      ids = params[:ids]
      ids = ids.split(',') unless ids.kind_of?(Array)
      relation.where(id: ids)
    end
  end
end
