module Onedrive
  class Drive < Element
    attr_accessor :folder

    def logged?
      @attributes.include?('error') ? false : true
    end

    def error_message
      @attributes['error']['message']
    end

    def children_path
      if folder.empty? or folder.nil?
        "drives/#{id}/root/children"
      else
        self.folder = folder + ':' unless folder.end_with? ':'
        "drive/root:/#{folder}/children"
      end
    end

  end
end
