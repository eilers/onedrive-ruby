module GoodData
  module Connectors
    module Onedrive
      class OnedriveClass

        def initialize(token)
          opts[:token] = token
          @client = Client.new (opts)
        end


        def bytes_to_mb (bytes)
          (bytes / (1024.0 * 1024.0)).to_f.round(2)
        end

        def connect
          #getting user drive
          @drive = @client.drive
          #handle unauthenticated access
          raise @drive.error_message unless @drive.logged?
          puts 'Connected to Onedrive'
          puts "Account id #{@drive.user_account['id']}"; @logger.info "Display name #{@drive.user_account['displayName']}"
        end

        def list_files_metadata (children)
          folders_count, files_count = 0, 0
          children.each do |item|
            if item.folder?
              folders_count = folders_count + 1
            else
              files_count = files_count + 1
            end
          end
          puts "Folders count : #{folders_count}"
          puts "Files count : #{files_count}"
        end

        #method is used to list directory provided, otherwise it lists root of drive
        #method returns an array of hashes
        def list(path='root')
          puts "#list('#{path}')"
          listed_files =[]
          @drive.folder = path
          children = @drive.children
          list_files_metadata(children)
          raise 'There are no files in directory' if children.count < 1
          children.each do |item|
            listed_files << "#{item.path.gsub('/drive/', 'drive/')}/#{item.name}" unless item.folder?
          end
          @logger.info 'Children list acquired.'
          pp listed_files
        end


        def read (remote_path, local_path)
          FileUtils.mkdir_p local_path
          puts "#read('#{remote_path}', '#{local_path}')"
          @drive.download_file(remote_path, local_path)
        end

        def upload_file (remote_path, path_to_file) #remote_path, path_to_file
          raise 'Remote path is not declared' if remote_path.empty?
          @drive.folder = remote_path
          raise "File #{path_to_file} does not exist." unless File.file?(path_to_file)
          puts "#upload('#{path_to_file}','#{remote_path}')"
          @drive.upload_file(path_to_file, remote_path)
        end

        def rename(remote_path, new_remote_path)
          puts "rename('#{remote_path}' , '#{new_remote_path}'"
          @drive.rename_file(remote_path, new_remote_path)
        end


        def delete(remote_path)
          puts "#delete('#{remote_path}')"
          @drive.delete_file(remote_path)
        end


        puts 'Prcocessing has finished'
      end
    end
  end
end
