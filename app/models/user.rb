require 'digest/sha1'

class User < ActiveRecord::Base
  
  has_many :posts
  has_many :comments
  has_many :ratings
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # username validation (we get problems with apostroph and stuff in the
  # digest) TODO geht leider noch nicht, mann muss da irgendwas mit unicode
  # codepoint bla bla machen
   validates_format_of :login, :with		 => /[:word:]/,
    :message  => 'please use only letters and numbers in your name'
  
  # email validation
  validates_format_of     :email,
    :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message    => 'email must be valid'
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :last_post
  attr_accessible :activated, :reminded, :remind_me, :last_login
  
  
  # checks wether a user has allready rated for a post
  def has_rated_for(post)
    @rating = Rating.find_by_user_id(self.id, :conditions => ["post_id = #{post}"])
    not @rating.nil?
  end
  
  
  # this mothod removes the digest of a user is used when a former activated
  # user is deleted
  def remove_digest
    tmpfile		 = File.open("#{DIGEST}_tmp", "w")
    digest_file = File.open(DIGEST)
    digest_file.each { |line| 
      tmpfile.print(line) unless line.match(/^#{self.login}.*/)
    }
    tmpfile.close
    digest_file.close
    File.delete(DIGEST)
    File.rename("#{DIGEST}_tmp", DIGEST)
  end
  
  # this method deletes every contribution of the user
  def delete_all_posted
    Post.find(:all, :conditions => "user_id = #{self.id}").each { |post| 
      File.delete(post.filename)
    }
    Post.delete_all "user_id = #{self.id}"
    Comment.delete_all "user_id = #{self.id}"
    Post.make_rss			# damit er konsistent bleibt
  end

  
  # method to make the user an htacces user, will be calle after activation
  def make_htaccess_users
    File.open(DIGEST, "a") do |df|
      df.print("#{login}:#{digest}\n")
    end
  end

  
  # #this method deletes a unposted file
  def delete_unposted_file
    filename = "#{ENCLOSURE_PATH}tmp_#{self.login}"
    if(File.exist?(filename))
      File.delete(filename)
    end
    filename = "#{ENCLOSURE_PATH}#{self.login}_cover.png"
    if(File.exist?(filename))
      File.delete(filename)
    end
  end
  
  # all users who haven't posted during the last 3 weeks
  def self.lazy_users
    self.find(:all).select { |e|
      if e.last_post.nil?
        res = false
      else
        res = (Date.today - e.last_post).to_i > DAYS_TO_REMEMBER
      end
      res
    } 	
  end
  
  def is_admin?
    self.login == "admin"
  end

  
  # Authenticates a user by their login name and unencrypted password.  Returns
  # the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between
  # browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  protected
  		
  
  # before filter
  def encrypt_password
    return if password.blank?
    # save also digest for later use in make_htacces_user
    self.salt	  = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    #    self.digest	  = Digest::MD5.hexdigest("#{login}:music:#{password}")
    self.digest  = password.crypt(self.salt[0..1])
    self.crypted_password = encrypt(password)
  end
      
  def password_required?
    crypted_password.blank? || !password.blank?
  end
    
    
end
