class MoveRatingField < ActiveRecord::Migration
  def self.up
    remove_column :comments,	  :rating
    add_column	   :posts,	  :rating,	   :float
    add_column	   :posts,	  :rating_count,  :integer
  end

  def self.down
    add_column		:comments,  :rating, :integer
    remove_column	:posts,	  :rating
    remove_column	:posts,	  :rating_count
  end
end
