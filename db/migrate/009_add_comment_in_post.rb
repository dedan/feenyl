class AddCommentInPost < ActiveRecord::Migration
  def self.up
    add_column		:posts, :comment,	    :text
    add_column		:posts, :filename,	    :string
  end

  def self.down
    remove_column	:posts, :comment
    remove_column	:posts, :filename
  end
end
