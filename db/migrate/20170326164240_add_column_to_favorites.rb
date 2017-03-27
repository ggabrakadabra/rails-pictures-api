class AddColumnToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_column :favorites, :title, :string
    add_column :favorites, :date, :string
    add_column :favorites, :explanation, :string
    add_column :favorites, :hdurl, :string
    add_column :favorites, :copyright, :string
    add_column :favorites, :media_type, :string
  end
end
