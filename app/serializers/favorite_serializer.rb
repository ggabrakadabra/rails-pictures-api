# frozen_string_literal: true
class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :picture_id, :title, :date, :explanation, :copyright, :media_type
  has_one :picture
end
