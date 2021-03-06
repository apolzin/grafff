class FacebookUser
  attr_accessor :uid, :session_key, :secret, :expires, :base_domain, :access_token
  def name
    get_attributes["name"]
  end
  def timezone
    get_attributes["timezone"]
  end
  def birthday
    get_attributes["birthday"]
  end
  def last_name
    get_attributes["last_name"]
  end
  def first_name
    get_attributes["first_name"]
  end
  def verified
    get_attributes["verified"]
  end
  def updated_time
    get_attributes["updated_time"]
  end
  def gender
    get_attributes["gender"]
  end
  def email
    get_attributes["email"]
  end
  def picture
    picture_square
  end
  def albums
    get_albums
  end
  def picture_large
    "https://graph.facebook.com/#{self.uid}/picture?type=large"
  end
  def picture_square
    "https://graph.facebook.com/#{self.uid}/picture?type=square"
  end
  def picture_small
    "https://graph.facebook.com/#{self.uid}/picture?type=small"
  end
  def get_attributes
    unless @cached_attributes
      @cached_attributes = FacebookRequest.new.get_userdata(self.access_token)
    end
    return @cached_attributes
  end
  def get_albums
    unless @user_albums
      @user_albums = FacebookRequest.new.get_albums(self.access_token)
    end
    return @user_albums
  end
  def upload_profile_picture(options = {})
    FacebookRequest.new.upload_profile_picture(self.access_token, self.uid, options)
  end
  def profile_pictures
    get_profile_pictures
  end
  def get_profile_pictures
    unless @user_profile_pictures
      @user_profile_pictures = FacebookRequest.new.get_profile_pictures(self.access_token, self.uid)
    end
    return @user_profile_pictures
  end
  def wallpost(options = {})
    FacebookRequest.new.wallpost(self.access_token, options)
  end
end

class FacebookRequest
  require 'rubygems'
  require 'httmultiparty'
  include HTTMultiParty
  def get_userdata(access_token)
    self.class.get("https://graph.facebook.com/me?access_token=#{CGI.escape(access_token)}&locale=en_US")
  end
  def get_userpicture(access_token)
    self.class.get("https://graph.facebook.com/me/photo?access_token=#{CGI.escape(access_token)}")
  end
  def get_albums(access_token)
    self.class.get("https://graph.facebook.com/me/albums?access_token=#{CGI.escape(access_token)}&metadata=1")
  end
  def wallpost(access_token, options = {})
    query = {:body => options.merge({:access_token => access_token})}
    self.class.post("https://graph.facebook.com/me/feed", query)
  end
  def upload_profile_picture(access_token, user_id, options)
    query = {:body => options.merge({:access_token => access_token})}
    self.class.post("https://graph.facebook.com/#{user_id}/photos", query)
  end
  def get_profile_pictures(access_token,user_id)
    query = "SELECT src_small, src_big FROM photo where aid IN (SELECT aid FROM album WHERE owner = #{user_id} AND type = 'profile')"
    self.class.get("https://api.facebook.com/method/fql.query?access_token=#{CGI.escape(access_token)}&query=#{CGI.escape(query)}&format=json")
  end
end
