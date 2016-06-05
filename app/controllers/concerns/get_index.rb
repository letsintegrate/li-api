# Setting the default URL options on the serializer context. This is required
# for the serializers to be able to generate link URLs.
#
module Concerns
  module GetIndex
    def get_index(klass, options = {})
      options.reverse_merge!(
        destinct: true
      )
      filter   = klass.ransack(params[:filter])
      relation = filter.result(options)
      relation = get_index_id_filter(relation)
      relation = get_index_pagination(relation)
      relation = get_index_sorting(relation)
      relation
    end

    def get_index_id_filter(relation)
      return relation unless params[:ids]
      ids = params[:ids]
      ids = ids.split(',') unless ids.kind_of?(Array)
      relation.where(id: ids)
    end

    def get_index_pagination(relation)
      return relation unless params[:page]
      relation = relation.limit(params[:page][:limit]) if params[:page][:limit]
      relation = relation.offset(params[:page][:offset]) if params[:page][:offset]
      relation
    end

    def get_index_sorting(relation)
      return relation unless params[:sort]
      params[:sort].split(',').map do |c|
        dir = c.starts_with?('-') ? :desc : :asc
        relation = relation.order("#{c.gsub(/[^\w\.]/, '')} #{dir}")
      end
      relation
    end
  end
end
