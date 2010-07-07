class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :song,			    :string
      t.column :artist,			    :string
      t.column :album,			    :string
      t.column :user_id,		    :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end


