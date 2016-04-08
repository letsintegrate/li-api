module JsonapiHelper
  module ResponseParsing
    def json
      JSON.parse(response.body)
    rescue
      nil
    end

    def data
      json['data']
    rescue
      nil
    end
  end

  module RequestBuilder
    def get(*args)
      super(*json_args(*args))
    end

    def post(*args)
      super(*json_args(*args))
    end

    def update(*args)
      super(*json_args(*args))
    end

    def patch(*args)
      super(*json_args(*args))
    end

    def put(*args)
      super(*json_args(*args))
    end

    def delete(*args)
      super(*json_args(*args))
    end

    def json_args(path, params = {}, headers = {})
      [
        path,
        dasherize_keys(params).to_json,
        headers.merge('CONTENT_TYPE' => 'application/vnd.api+json')
      ]
    end

    # dasherize all keys of the request recursively
    #
    def dasherize_keys(data)
      return nil if data.nil?
      return data.map { |obj| dasherize_keys obj } if data.is_a? Array
      if data.is_a? Hash
        return Hash[data.map {|k, v| [k.to_s.dasherize, dasherize_keys(v)] }]
      end
      return data
    end
  end

  RSpec.configure do |config|
    config.include ResponseParsing, type: :controller
    config.include RequestBuilder, type: :request
  end
end
