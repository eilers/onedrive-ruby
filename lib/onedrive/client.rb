module Onedrive

  # Exceptions
  class MissingToken < StandardError; end

  class Client
    include Utils
    def initialize(options = {})
      raise MissingToken unless options[:token]
      @token = options[:token]
    end

    def drive(id = nil)
      return default_drive unless id
      find_drive(id)
    end

    def connection
      @connection ||= Onedrive::Connection.new(@token)
    end
    private
    def default_drive
      drive = connection.get('drive')
      new_drive drive
    end

    def find_drive(id)
      drive = connection.get("drives/#{id}")
      new_drive drive
    end

  end
end
