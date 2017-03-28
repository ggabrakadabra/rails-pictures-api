class AddColumnToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :date, :string
    add_column :pictures, :explanation, :string
    add_column :pictures, :hdurl, :string
    add_column :pictures, :copyright, :string
    add_column :pictures, :media_type, :string
  end
end
