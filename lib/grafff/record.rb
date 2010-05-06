class Grafff::Record
  include Grafff::Client

  attr_accessor :access_token,
      :uid, :session_key, :secret, :expires, :base_domain

  def initialize(credentials)
    credentials.each { |key, value| send :"#{ key }=", value }
  end

  def attributes
    @__attributes = get_attributes unless defined? @__attributes
    @__attributes
  end

  protected

    def get_attributes(uri)
      get("#{ uri }?access_token=#{ CGI.escape access_token }").
          inject({}) { |mem, (k, v)| mem.update k.to_sym => v }
    end

end
