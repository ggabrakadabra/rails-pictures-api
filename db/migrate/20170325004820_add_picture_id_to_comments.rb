class AddPictureIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :picture, index: true, foreign_key: true
  end
end
