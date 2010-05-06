module Grafff::Rails
  module Helper

    FB_GRAPH_INCLUDE = <<-HTML
<script src="http://connect.facebook.net/en_US/all.js"></script>
HTML

    FB_INIT = <<-HTML
<script>
  jQuery(function() {
    FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
  });
</script>
HTML

    FB_LOGIN_SCRIPT = <<-HTML
<script>
  function facebook_login() {
    #{ FB_INIT }
    FB.login(function(response) {
      if (response.session) {
        if (response.perms) {
          %s;
        } else {
          %s;
        }
      }
    }, {perms:'%s'});
  }
</script>
HTML

  FB_ROOT_TAG = <<-HTML
<div id="fb-root">%s</div>
HTML

  FB_SUBSCRIBE = <<-HTML
<script>
  $(document).ready(function() {
    FB.Event.subscribe('%s', function(response) {
      %s; // check for response failure
    }, { perms:'%s' });
  });
</script>
%s
HTML

    def fb_graph_include
      FB_GRAPH_INCLUDE
    end
    def fb_init
      FB_INIT % facebook_credentials[:api_key]
    end
    def fb_subscribe(event, *permissions)
      options = permissions.extract_options!
      on_success = options[:on_success] || 'window.location.reload()'
      on_failure = options[:on_failure] || 'window.location.reload()'

      FB_SUBSCRIBE % [event, on_success, permissions * ',']
    end
    def fb_login_script(*permissions)
      options = permissions.extract_options!
      on_success = options[:on_success] || 'window.location.reload()'
      on_failure = options[:on_failure] || 'window.location.reload()'

      FB_LOGIN_SCRIPT % [
        facebook_credentials[:api_key], permissions.join(','),
        on_success, on_failure
      ]
    end
    def fb_root_tag(content)
      FB_ROOT_TAG % content
    end
    def fb_login_button_tag(caption = nil)
      content = if caption
        link_to_function(caption, 'facebook_login()')
      else
        '<fb:login-button></fb:login-button>'
      end

      fb_root_tag % content
    end
    def fb_simple_login_button_tag(on_success = 'window.location.reload()')
      permissions = %w[ read_stream publish_stream offline_access ]

      FB_SIMPLE_LOGIN_BUTTON_TAG % [
        facebook_credentials[:api_key], on_success, permissions.join(','),
        fb_root_tag()
      ]
    end

    def fb_login(caption = nil, *permissions)
      fb_graph_include + fb_init +
      fb_login_script(*permissions) +
      fb_login_button_tag caption
    end
    def fb_simple_login(*args)
      fb_graph_include +
      fb_simple_login_button_tag(*args)
    end

  end
end
