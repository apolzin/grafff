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
  def email
    get_attributes["email"]
  end
  def picture
    picture_square
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
end

class FacebookRequest
  require 'rubygems'
  require 'httparty'
  include HTTParty
  def get_userdata(access_token)
    self.class.get("https://graph.facebook.com/me?access_token=#{CGI.escape(access_token)}")
  end
  def get_userpicture(access_token)
    self.class.get("https://graph.facebook.com/me/photo?access_token=#{CGI.escape(access_token)}")
  end
end
