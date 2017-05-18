class Import < ApplicationRecord
    mount_uploader :filename, ImportUploader
    belongs_to :importsession 
end
