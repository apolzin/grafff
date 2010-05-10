module Grafff
  module Controller
  require 'digest/md5'
    def get_facebook_user
      fb_info = extract_fb_info
      if fb_info
        facebook_user = FacebookUser.new
        fb_info.each do |key,value|
          facebook_user.send("#{key}=",value)
        end
        @facebook_user = facebook_user
        return true
      else
        @facebook_user = nil
        false
      end
    end
    def extract_fb_info
      key = facebook_credentials[:api_key]
      secret = facebook_credentials[:secret]
      unless cookie = cookies["fbs_#{key}"]
      	return nil
      end
      return_hash= {}
      work_hash = {}
      challenge_response = ""
      cookie.split("&").each do |split|
	value = split.split("=")
        if value[0] == "sig"
          challenge_response = value[1].gsub(/\"/,"")
        else
          cleaned_value = value[1].gsub(/\"/,"")
          return_hash[value[0].gsub(/\"/,"").to_sym] = cleaned_value
          work_hash[value[0]] = "=" + cleaned_value
        end
      end
      work_hash = work_hash.sort.to_s.gsub(/\"/,"")
      if challenge_response ==  Digest::MD5.hexdigest(work_hash + secret)
        return return_hash
      else
        return nil
      end
    end
    def facebook_credentials
      if FACEBOOK_API_KEY.is_a?(Hash)
        {
          :api_key => FACEBOOK_API_KEY[@grafff_locale || "en-US"],
          :secret => FACEBOOK_SECRET[@grafff_locale || "en-US"]
        }
      else
        {
          :api_key => FACEBOOK_API_KEY,
          :secret => FACEBOOK_SECRET
        }
      end
    end
  end
end
