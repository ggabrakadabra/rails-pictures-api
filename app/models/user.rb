# frozen_string_literal: true
class User < ApplicationRecord
  include Authentication
  has_many :favorites
  has_many :pictures, through: :comments
  has_many :comments
end
