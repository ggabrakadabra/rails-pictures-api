# frozen_string_literal: true
class Favorite < ApplicationRecord
  belongs_to :picture
  belongs_to :user
  validates :user, presence: true
  validates :picture, presence: true
end
