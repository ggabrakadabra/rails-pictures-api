# frozen_string_literal: true
class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :picture_id
  has_one :picture
end
