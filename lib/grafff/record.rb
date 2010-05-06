class Grafff::Record

  GRAPH_URI   = 'https://graph.facebook.com'

  @@decoders  = Hash.new { |decoders, type|
    warn "No decoder for #{ type } found!"
    proc { |data| data }
  }
  def self.decode(type, &block) @@decoders[type] = block end

  attr_accessor :access_token,
      :uid, :session_key, :secret, :expires, :base_domain

  def self.generate_signature_and_constraints(arguments, definitions)
    constraints = {}

    signature = arguments.map do |argument|
      constraint = Array definitions[argument]

      default_value = case constraint.length
      when 0
      when 1; constraints.shift
      else
        constraints[argument] = constraints
        constraints.first
      end

      default_value ? "#{ argument } = '#{ default_value }'" : argument
    end

    return signature * ', ', constraints
  end

  PROPERTIES = 'def %s; properties[:%s] end'
  def self.properties(*names)
    names.each { |name| class_eval PROPERTIES % [ name, name ] }
  end

  def self.connect(connection_name, options = {})
    args = Array options[:with]
    defs = options[:where] || {}

    unless args.empty?
      # TODO do something with the constraints
      sig, _ = generate_signature_and_constraints args, defs
      path_args = "?#{ args.map { |a| '%s=#{ %s }' % [a, a] } * '&' }"
    end

    # Call:
    #   connect :picture, :with => :type, :where => {
    #     :type => %w[ square small large ]
    #   }
    # Result:
    #   def picture_uri(type = 'square')
    #     build_uri "#{ uid }/picture?type=#{ type }"
    #   end
    #   def picture(type = 'square')
    #     get picture_path(type)
    #   end
    class_eval(<<-RUBY)
      def #{ connection_name }_uri(#{ sig })
        build_uri "##{ uid }/#{ connection_name }#{ path_args }"
      end
      # TODO make this like :composed_of
      def #{ connection_name }(#{ sig })
        get #{ connection_name }_uri(#{ args * ', ' })
      end
    RUBY
  end

  def initialize(credentials)
    @client = Grafff::Client.new
    credentials.each { |key, value| send :"#{ key }=", value }
  end

  def properties
    @properties = get build_uri(properties_path) unless defined? @properties
    @properties
  end

  protected

    def build_uri(path)
      path, arguments = path.split '?'
      path = path.split '/'
      path.map! { |p| CGI.escape p }

      arguments = arguments.split '&'
      arguments.map! { |a| a.split('=').map { |v| CGI.escape v } * '=' }
      arguments << "access_token=#{ access_token }"

      "#{ GRAPH_URI }/#{ path * '/' }?#{ arguments * '&' }"
    end
    def get(uri)
      data, type = @client.get uri
      @@decoders[type].call data
    end
    def post
      raise NotImplementedError
    end
    def put
      raise NotImplementedError
    end
    def delete
      raise NotImplementedError
    end

end
