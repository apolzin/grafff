class Grafff < Struct.new(:cookie, :secret)

  def user
    return @user if defined? @user

    if cookie or credentials = extract_credentials
      @user = nil
    else
      @user = Grafff::User.new credentials
    end
  end

  protected

    def extract_credentials
      credentials, salt = {}, ''

      cookie.split('&').each do |split|
        split.delete! '"'
        key, value = split.split '='

        unless key == 'sig'
          credentials[key.to_sym] = value
          salt << split
        else
          signature = value
        end
      end

      credentials if Digest::MD5.hexdigest(salt + secret) == signature
    end

end

require 'cgi'
require 'digest/md5'
require 'open-uri'

require 'grafff/client'
require 'grafff/record'
require 'grafff/user'
# TODO require 'grafff/user/photo'

if defined? Crack
  Grafff::Record.decode('text/javascript') do |d|
    Crack::JSON.decode(d).inject({}) { |m, (k, v)| m.update k.to_sym => v }
  end
elsif defined? Yajl
  parser = Yajl::Parser.new

  Grafff::Record.decode('text/javascript') do |d|
    parser.decode(d).inject({}) { |m, (k, v)| m.update k.to_sym => v }
  end
end
