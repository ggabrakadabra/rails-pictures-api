# frozen_string_literal: true
class FavoriteSerializer < ActiveModel::Serializer
  attributes :id
  has_one :picture
end
