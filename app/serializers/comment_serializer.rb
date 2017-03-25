class CommentSerializer < ActiveModel::Serializer
  attributes :id, :note
  has_one :picture
end
