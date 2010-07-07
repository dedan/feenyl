class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
	  
  validates_presence_of :comment_text,
				    :message => 'you cannot post empty comments ! (depp)'
  
end
