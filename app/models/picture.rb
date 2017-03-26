# frozen_string_literal: true
class Picture < ApplicationRecord
  has_many :users, through: :pictures
  has_many :pictures
end
