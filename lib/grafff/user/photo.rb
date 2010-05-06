class Grafff::User::Photo << Grafff::Record

  protected

    def get_attributes
      super 'https://graph.facebook.com/me/photo'
    end

end