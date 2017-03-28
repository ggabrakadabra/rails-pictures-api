# frozen_string_literal: true
class PictureSerializer < ActiveModel::Serializer
  attributes :id, :title, :date, :explanation, :hdurl
end
