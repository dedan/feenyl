class RatingController < ApplicationController
  
  def rate
	 
    @post = Post.find(params[:id])
    @rating = Rating.find_by_user_id(current_user.id, :conditions => ["post_id = #{@post.id}"])
	 
    if @rating.nil?
      # hier mache ich die bewertung
      @post.rating = ((@post.rating * @post.rating_count) + params[:rating].to_i * 0.5) / (@post.rating_count + 1)
      @post.rating_count += 1
    
      @rating = Rating.new(
        :user_id => current_user.id,
        :post_id => params[:id]
      )
      @rating.save
      @post.save
    elsif @post.user_id == current_user.id 
      flash[:notice] = "You are not allowed to rate your own post!"
    else
      flash[:notice] = "You've allready rated (mööp)"
    end
  end
  
  
end
