class MakeCommentTextBigger < ActiveRecord::Migration
  def self.up
	 remove_column :comments, :comment_text
	 add_column :comments, :comment_text, :text
  end

  def self.down
	 remove_column :comments, :comment_text
	 add_column :comments, :comment_text, :string
  end
end
