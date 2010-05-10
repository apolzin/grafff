module Grafff
  module Helper
    def render_login_button
      html_js = <<-EOT
<script src="http://connect.facebook.net/en_US/all.js"></script>
<script>
  $(document).ready(function() {
    FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
    FB.Event.subscribe('auth.login', function(response) {
      %s
    }%s);
  });
</script>
<div id="fb-root"></div>
<fb:login-button></fb:login-button>
EOT
      call_back_reload = "window.location.reload();"
      additional_permissions = ",{perms:'read_stream,publish_stream,offline_access'}"
      html_js % [facebook_credentials[:api_key], call_back_reload, additional_permissions]
    end
    def render_login_button_extended(permissions=[])
      html_js = <<-EOT
<script src="http://connect.facebook.net/en_US/all.js"></script>
<script>
  function facebook_login()
  {
    FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
    FB.login(function(response) {
      if (response.session) {
        if (response.perms) {
            window.location.reload();
        } else {
            window.location.reload();
        }
      }
    }, {perms:'%s'});
  }
</script>
<div id="fb-root"><a href="javascript:facebook_login();">log into facebook</a></div>
  EOT
      html_js % [facebook_credentials[:api_key], permissions.join(",")]
    end
    def write_fb_init
      html_js = <<-EOT
<script type="text/javascript">
      FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
</script>
EOT
      html_js % [facebook_credentials[:api_key]]
    end
    def render_login_js(permissions=[])
       html_js = <<-EOT
<script src="http://connect.facebook.net/en_US/all.js"></script>
<script>
  function facebook_login()
  {
    FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
    FB.login(function(response) {
      if (response.session) {
        if (response.perms) {
            window.location.reload();
        } else {
            window.location.reload();
        }
      }
    }, {perms:'%s'});
  }
</script>
  EOT
      html_js % [facebook_credentials[:api_key], permissions.join(",")]
    end
    def render_permission_js(permission)
      html_js = <<-EOT
<script src="http://connect.facebook.net/en_US/all.js"></script>
<script>
  function facebook_permission_%s()
  {
    FB.init({appId: '%s', status: true, cookie: true, xfbml: true});
    FB.login(function(response) {
      if (response.session) {
        if (response.perms) {
            window.location.reload();
        } else {
            window.location.reload();
        }
      }
    }, {perms:'%s'});
  }
</script>
  EOT
      html_js % [permission, facebook_credentials[:api_key], permission]
    end
  end
end
