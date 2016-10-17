require 'gooddata_connectors_onedrive/utils'
require 'gooddata_connectors_onedrive/client'
require 'gooddata_connectors_onedrive/connection'
require 'gooddata_connectors_onedrive/element'
require 'gooddata_connectors_onedrive/version'
require 'gooddata_connectors_onedrive/drive'
require 'gooddata_connectors_onedrive/item'
require 'gooddata_connectors_onedrive/onedrive'
require 'fileutils'
require 'logger'
require 'pp'

module GoodData
  module Connectors
    module Onedrive
      class OnedriveMiddleware < GoodData::Bricks::Middleware
        def call(params)
          $log = params['GDC_LOGGER']
          $log.info 'Initializing OnedriveMiddleware'
          ads_storage = OnedriveClass.new(params['metadata_wrapper'], params)
          @app.call(params.merge('onedrive_wrapper' => ads_storage))
        end
      end
    end
  end
end
