class CommentsController < ApplicationController
  before_filter :find_post
  before_filter :login_required
  layout "music"

  def show
    @comments = @post.comments(:order => "created_at DESC")
  end
  
  def index
    @comments = Comment.find(:all, :order => "created_at DESC")
  end  
  
  def new
    @comment = Comment.new(
      :post_id => params[:id],
      :comment_text => "", 
      :user_id => current_user.id
    )
  end
  
  def create
    # save comment when no errors occur, otherwise go back to form
    @comment = Comment.new(params[:comment])
    if @comment.save
      
      # notify poster and all commenters of this post 
      if @comment.post.user.login != @comment.user.login
        Thread.new(@comment) do |comment|  
          Notify.deliver_notify_poster(comment)
        end
      end

      @other_commenters = @comment.post.comments.collect{ |c| c.user }.uniq
      @other_commenters = @other_commenters - [@comment.post.user, @comment.user]
      
      Thread.new(@comment, @other_commenters) do |comment, others|
        others.each do |other|
          p "huhuuuuuu"
          Notify.deliver_notify_commenter(comment, other)
          p "vorbei"
        end
      end
      
      flash[:notice] = "comment added"
      redirect_to :controller => "music", :action => "index"
    else
      render :action => "new", :id => params[:id]
    end
  end

  private
  def find_post
    @post = Post.find(params[:id]) if params[:id]
  end
end