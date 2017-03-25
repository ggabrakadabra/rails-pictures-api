# frozen_string_literal: true
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :note
  has_one :picture
  has_one :user
end
