require 'id3lib'
require 'rss'

class MusicController < ApplicationController
  
  before_filter :login_required, :except => ['rss','index']
  
  
  # link to the feed and short explanation
  def feed
  end

  # show the feed explanation and help page
  def feed_explanation
  end


  # index page which is showing the post of the last seven days
  def index 
    if not current_user.nil? and current_user != :false
    
    # wenn ich von post_in_feed komme das remind_me neu setzen das ist die
    # erinnerung nach ablauf der 7 tages frist
    unless params[:user].nil?
      unless params[:user][:remind_me].nil?
        current_user.remind_me = params[:user][:remind_me]
        current_user.reminded  = false
        current_user.save
      end

    end
    
    # wenn ich von edit_tag oder aehnlichem komme und abgebrochen wurde
    if params[:delete_file] == "true"
      current_user.delete_unposted_file
    end

    @posts = Post.find(:all,:order => "created_at DESC")
    
    @posts.reject! do |p|
      current_user.has_rated_for(p.id)
    end
    params[:id] = current_user.id
  end
    
  end


  # show a page with all posts
  def all_posts
    # alle posts mit gewuenschter sortierung aus der DB holen
    @posts = Post.find(:all, :order => "#{params[:sort]} DESC")
    
    # aktuelle sortierung rausgeben um sie im view anzeigen zu koennen
    @active_sort = [
      params[:sort] == "created_at" ? "act_sort" : "not_act_sort",
      params[:sort] == "rating"     ? "act_sort" : "not_act_sort",
      params[:sort] == "user_id"    ? "act_sort" : "not_act_sort"
    ]
  end
  
  
  # post the new file in the feed (save to DB)
  def post_in_feed
    # update tag
    @tag = ID3Lib::Tag.new(tmp_filename)
    @tag.artist  = params["tag"]["artist"]
    @tag.album   = params["tag"]["album"]
    @tag.title   = params["tag"]["title"]
    @tag.comment = params["tag"]["comment"]
    @tag.update!
    
    # neuen, endgueltigen dateinamen bestimmen
    new_filename = get_filename(@tag.artist, @tag.title)
   
    # store the post in database
    # bis jetzt wurden die informationen im tag der datei mitgefuehrt
    @post = Post.create({
        :user     => current_user,
        :song     => @tag.title,
        :artist   => @tag.artist,
        :album    => @tag.album,
        :comment  => @tag.comment,
        :rating       => 0,
        :rating_count => 0,
        :filename     => new_filename
      })
                       
    if @post.save
      if File.rename(tmp_filename, new_filename) and File.chmod(0644, new_filename)
     
        # wenn speichern klappt und datei auch umbenennt werden kann
        # leg auch gleich noch ein neues, erstes kommentar fuer den post an
        Comment.new(
          :post_id => @post.id,
          :comment_text => @tag.comment,
          :user_id => current_user.id
        ).save

        # store the time when user posted
        current_user.last_post = Date.today
        current_user.save
                
        # verhindern, dass man die eigenen posts bewerten darf
        @rating = Rating.new(
          :user_id => current_user.id,
          :post_id => @post.id
        )
        @rating.save

        @user  = current_user

        # create the new feed
        Post.make_rss

      else
        flash[:notice]  = "renaming problem"   #sollte nicht passieren
        logger.info("a problem occured while renaming the temporary file")
        redirect_to :action => "index"
      end
    else
      
      # speichern hat nicht funktioniert, zurueck zum upload formular
      @original_name = params["original_name"]
      render :action => "upload_file"
    end
     
  end
  
  
  # save uploaded file to disk
  def upload_file
   
    # remember the filename
    tempfile = params["file_to_upload"]

    # wenn ich keinen string bekommen habe und auch ueberhaupt was ankam (kein tag_edit)
    unless tempfile.nil?
      
      # if just a string arrived
      if tempfile.instance_of?(String)
        flash[:notice] = "please select a valid file"
        redirect_to :action => "index"
      
      # when a file arrived
      elsif tempfile.instance_of?(Tempfile)
        
        # delete file if too big
        if File.size?(tempfile) > MAX_FILESIZE
          File.delete(tempfile.local_path)
          flash[:notice] = "File too large (maximal 10 MB allowed)"
          redirect_to :action => "index"

        # if it is a valid mp3
        elsif tempfile.original_filename.ends_with?(".mp3")
          # save variable for view
          @original_name = tempfile.original_filename
          # read id3 information
          @tag = ID3Lib::Tag.new(tempfile.local_path)
          # copy the file to the upload directory
          FileUtils.copy(params[:file_to_upload].local_path, tmp_filename)
          logger.info("new file from #{current_user.login} copied to : #{tmp_filename}")

          # TODO bild auslesen funktioniert noch nicht
          #          unless @tag.frame(:APIC)[:data].nil? and false
          #            image = File.open("#{ENCLOSURE_PATH}#{current_user.login}_cover.png", "w")
          #            image.print(@tag.frame(:APIC)[:data])
          #            image.close
          #            params["cover"] = :true
          #          end

          flash[:notice] = "File Uploaded"
        else 
          flash[:notice] = "This file is no mp3 file"
          redirect_to :action => "index"
        end
      end
    else
      
      # hier komme ich hin, wenn nichts hochgeladen wurde, sondern der tag editiert
      @original_name = params["original_name"]
      @tag = ID3Lib::Tag.new(tmp_filename)
    end
  end
      
      
  private

  # built filename out of artist and songtitel
  def get_filename(artist, song)
    "#{ENCLOSURE_PATH}#{proper_filename(artist)}__#{proper_filename(song)}.mp3"
  end
  
  # get the tempfilename for the current_user
  def tmp_filename(user = current_user)
    "#{ENCLOSURE_PATH}tmp_#{user.login}"
  end
  
  # replace all non-alphanumeric, underscore or periods with underscores
  def proper_filename(file)
    file.gsub(/[^\w]/,'_')
  end
  
end
