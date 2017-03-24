class AddPictureIdToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_reference :favorites, :picture, index: true, foreign_key: true
  end
end
