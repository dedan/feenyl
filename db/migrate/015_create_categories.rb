class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :cat_name, :string
      t.column :desc,     :string
    end
    
    add_column :posts, :category, :integer
    
    Category.create(:cat_name => "Cover", 
      :desc => "Sometimes the Cover is even better than the original" )
    Category.create(:cat_name => "Party-Burner", 
      :desc => "Vom Barhocker Locker" )
    Category.create(:cat_name => "Alltime Favourite", 
      :desc => "One of the greatest Songs ever" )
    Category.create(:cat_name => "Strange Song", 
      :desc => "I don't know why, but I like this song" )
  end

  def self.down
    drop_table    :categories
    remove_column :posts, :category
  end
end


