class Api::V1::GroupSerializer < ActiveModel::Serializer
  attributes :id, :title, :ancestry
end
