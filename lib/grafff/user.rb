class Grafff::User < Grafff::Record

  properties :name, :first_name, :last_name, :email, :verified,
      :timezone, :updated_time, :birthday

  connect :picture, :with => :type, :where => {
    :type => %w[ square small large ]
  }

  protected

    PROPERTIES_PATH = 'me'
    def properties_path; PROPERTIES_PATH end

end
