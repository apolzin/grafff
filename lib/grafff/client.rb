module Grafff::Client

  # FIXME make this procedure more robust
  if defined? ActiveSupport::JSON
    def get(uri)
      uri = URI uri
      ActiveSupport::JSON.decode Net::HTTP.get(uri)
    end

  elsif defined? Crack::JSON
    def get(uri)
      uri = URI uri
      Crack::JSON.parse Net::HTTP.get(uri)
    end

  elsif defined? Yajl::HttpStream
    def get(uri)
      uri = URI uri
      Yajl::HttpStream.get uri
    end

  elsif (require 'crack/json' rescue false)
    def get(uri)
      uri = URI uri
      Crack::JSON.parse Net::HTTP.get(uri)
    end

  elsif %w[ gzip deflate http_stream ].all? { |l| require "yajl/#{ l }" rescue false }
    def get(uri)
      uri = URI uri
      Yajl::HttpStream.get uri
    end

  else
    raise LoadError, 'Cannot load JSON dependency.'

  end
end
