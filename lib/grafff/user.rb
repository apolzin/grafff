class Grafff::User < Grafff::Record

  GRAPH_URI   = 'https://graph.facebook.com/me'
  PICTURE_URI = 'https://graph.facebook.com/%s/picture?type=%s'

  def name
    attributes[:name]
  end
  def timezone
    attributes[:timezone]
  end
  def birthday
    attributes[:birthday]
  end
  def last_name
    attributes[:last_name]
  end
  def first_name
    attributes[:first_name]
  end
  def verified
    attributes[:verified]
  end
  def updated_time
    attributes[:updated_time]
  end
  def email
    attributes[:email]
  end

  def picture_uri(format = :square)
    PICTURE_URI % [ uid, format ]
  end

  protected

    def get_attributes
      super GRAPH_URI
    end

end
