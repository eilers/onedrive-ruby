require 'open-uri'

module Onedrive
  class Element
    include Utils

    attr :connection

    def initialize(attributes, connection)
      @attributes = attributes
      @connection = connection
    end

    def id
      @attributes['id']
    end

    def name
      @attributes['name']
    end

    def path
      @attributes['parentReference']['path']
    end

    def size
      @attributes['size']
    end

    def folder?
      !@attributes['folder'].nil? ? true : false
    end

    def user_account
      @attributes['owner']['user']
    end

    def children
      items = connection.get(children_path)
      new_items items
    end

    def download_file(remote_path, local_path)
      uri = "#{remote_path}:/content"
      file_name = remote_path.split('/').last
      item = connection.get(uri)
      uri = URI.encode(item['location'])
      open("#{local_path}/#{file_name}", 'wb') do |file|
        file << open(uri).read
      end
    end

    def delete_file(remote_path)
      uri = "drive/root:/#{remote_path}"
      connection.delete(uri)
    end

    def upload_file(local, remote_parent_id)
      filename = local.split('/').last
      uri = "drive/root:/#{remote_parent_id}/#{filename}:/content"
      file_stream = open(local)
      header = {'Content-Type' => 'text/plain',
                'Content-Length'=> file_stream.size.to_s}
      connection.put(uri, file_stream, header)
    end

    def rename_file(remote_path, new_remote_path)
      file_name = new_remote_path.split('/').last
      uri = "drive/root:/#{remote_path}"
      body = {'name' => file_name,'parentReference' => {'path' => "/drive/root:/#{File.dirname(new_remote_path)}"}}
      header = {'Content-Type' => 'application/json'}
      body = body.to_json
      connection.patch(uri, body, header)
    end
  end
end
