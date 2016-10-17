require 'faraday'
require 'json'


module Onedrive

  class Connection
    def initialize(token)
      options = {url: 'https://api.gooddata_connectors_onedrive.com/v1.0/'}

      @connection = Faraday.new(options) do |faraday|
        faraday.request :url_encoded # form-encode POST params
        faraday.headers['Authorization'] = "Bearer #{token}"
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
    end

    def get(uri)
      uri = URI.encode(uri)
      response = @connection.get(uri)
      response.body.empty? ? response.to_hash[:response_headers] : JSON.parse(response.body)
    end

    def put(uri, file_stream,header)
      response = @connection.put uri, file_stream, header
      raise 'The request size exceeds the maximum limit.' if response.to_hash[:status] == 413
      raise "Error : #{response.to_hash[:body]}" if response.to_hash[:status] >= 400
    end

    def delete(uri)
      response = @connection.delete(uri)
      raise 'Error during deleting file' if response.to_hash[:status] >= 400
    end

    def patch(uri, body,header)
      response = @connection.patch(uri,body,header)
      raise 'Error during renaming of file' if response.to_hash[:status] >= 400
    end
  end
end
