class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
	   t.column :comment_text,		:string
	   t.column :rating,			:integer
	   t.column :user_id,			:integer
	   t.column :post_id,			:integer
	   t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
