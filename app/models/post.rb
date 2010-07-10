require 'rss/2.0'
require 'rss/itunes'

class Post < ActiveRecord::Base
  belongs_to :user
  has_many   :comments
  
  validates_uniqueness_of   :song
  
  # das wird bei create gar nicht aufgerufen der scheiss !
  def initialise(params = nil)
    super
    self.rating ||= 0
    self.rating_count ||= 0 
  end
  
  
  def has_comments?
    comments.size > 0
  end
  
  def self.last_post
	 Post.find(:first, :order => "created_at DESC", :limit => 1)
  end
  
  def self.make_rss

    author = "Feenyl"
	 title  = "Feenyl Feed"
	 link = URL
	 #link = "0.0.0.0:3000"
	 description = "recommend Music and share it with your friends"
	 ada = "http://feenyl.wrfl.de/images/ada.jpg"
   
    rss = RSS::Rss.new("2.0")
    channel = RSS::Rss::Channel.new
   
    category = RSS::ITunesChannelModel::ITunesCategory.new("Arts")
    category.itunes_categories <<   \
                    RSS::ITunesChannelModel::ITunesCategory.new("Music")
    channel.itunes_categories << category
   
    channel.title = title
    channel.description = description
    channel.link = link
    channel.language = "en-uk"
    channel.copyright = "Copyright #{Date.today.year} JonSte"
    channel.lastBuildDate = Post.last_post.created_at unless Post.last_post.nil?

    channel.image = RSS::Rss::Channel::Image.new
    channel.image.url = ada
    channel.image.title = title
    channel.image.link = link

    channel.itunes_author = author
    channel.itunes_owner = RSS::ITunesChannelModel::ITunesOwner.new
    channel.itunes_owner.itunes_name=author
    channel.itunes_owner.itunes_email = EMAIL

    channel.itunes_keywords = %w( no words)

    channel.itunes_subtitle = description             
    channel.itunes_summary = "bla bla bla, what to write, i don't no, share music --> have fun"

     # below is what iTunes uses for your "album art", different from RSS standard
    channel.itunes_image = RSS::ITunesChannelModel::ITunesImage.new(ada)
    channel.itunes_explicit = "No"
    # above could also be "Yes" or "Clean"
	 
	 @posts = Post.find(:all)
	 unless @posts.nil?
		@posts.each do |post|  
			 item = RSS::Rss::Channel::Item.new

			 tmp_link  = link + post.filename.gsub(REMOVE_REWRITE, "")


			 item.title  = "#{post.artist} -- #{post.song}"
			 item.link	  = tmp_link
			 item.itunes_keywords = ""
			 item.guid	  = RSS::Rss::Channel::Item::Guid.new
			 item.guid.content = tmp_link
			 item.guid.isPermaLink	  = true
			 item.pubDate = post.created_at

			 tmp_description = "Album: #{post.album} \n" + "Comment: #{post.comment} \n"
			 item.description = tmp_description
			 item.itunes_summary = tmp_description
			 item.itunes_subtitle = post.comment
			 item.itunes_explicit = "No"
			 item.itunes_author	  = post.artist

			 size = File.size?(post.filename)



			 item.enclosure = \
					 RSS::Rss::Channel::Item::Enclosure.new(tmp_link, size, 'audio/mpeg')     

					 channel.items << item    
		end
	 end
	 
    rss.channel = channel
	 
	 File.open(FEED_PATH, "w") do |f| 
      f.write(rss.to_s)
    end
	    
  end
  

  
end
