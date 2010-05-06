class Grafff::Client

  def get(uri)
    URI(uri).open { |io| [ io.read, io.content_type ] }
  end

=begin
  # FIXME make this procedure more robust
  if defined? ActiveSupport::JSON
    def get(uri)
      ActiveSupport::JSON.decode URI(uri).read
    end

  elsif defined? Crack::JSON
    def get(uri)
      Crack::JSON.parse URI(uri).read
    end

  elsif defined? Yajl::HttpStream
    def get(uri)
      Yajl::HttpStream.get URI(uri)
    end

  elsif (require 'crack/json' rescue false)
    def get(uri)
      Crack::JSON.parse URI(uri).read
    end

  elsif %w[ gzip deflate http_stream ].all? { |l| require "yajl/#{ l }" rescue false }
    def get(uri)
      Yajl::HttpStream.get URI(uri)
    end

  else
    raise LoadError, 'Cannot load JSON dependency.'

  end
=end

end
