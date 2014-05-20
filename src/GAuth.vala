using Gtk;
using WebKit;

namespace Enote{
  public class GAuth {

    string access_token;
    string refresh_token;
    int64  expires_in;
    int64  issued;

    public bool hasValidAccessToken() {
      var now = new DateTime.now_local().to_unix();
      var hasValid = access_token != null && now < (issued + expires_in);
      return hasValid;
    }

    void read() {
      access_token = Utils.gtasks.access_token;
      refresh_token = Utils.gtasks.refresh_token;
      expires_in = Utils.gtasks.expires_in;
      issued = Utils.gtasks.issued;
    }

    void write() {
      Utils.gtasks.access_token = access_token;
      Utils.gtasks.refresh_token = refresh_token;
      Utils.gtasks.expires_in = (int) expires_in;
      Utils.gtasks.issued = (int) issued;
    }

    void doFullAuth() {
      var window = new Granite.Widgets.LightWindow ("Sing in!");
      window.resizable = false;
      window.set_keep_above (true);
      window.set_default_size(400,500);
      window.set_size_request (100,200);
      window.set_position(Gtk.WindowPosition.CENTER);
      window.destroy.connect(Gtk.main_quit);

      var webView = new WebView();

      window.add(webView);

      var uri = "https://accounts.google.com/o/oauth2/auth?";
      uri += "response_type=code&";
      uri += "client_id=237167695494.apps.googleusercontent.com&";
      uri += "redirect_uri=urn:ietf:wg:oauth:2.0:oob&";
      uri += "scope=https://www.googleapis.com/auth/tasks";

      webView.load_finished.connect( (webView, load_event) => {
        var title = webView.get_title();
        if (title != null) {
          var split = title.split("=");
          if (split.length == 2 && split[0] == "Success code") {
            var code = split[1];
            window.destroy();
            requestToken(code);
          }
        }
      });

      //webView.show();
      window.show_all();

      webView.load_uri(uri);

      Gtk.main();
    }

    /**
     * Get valid Google API authentication
     * Tries the following:
     * 1. Check if already got valid auth, if so do nothing
     * 2. Read from GConf, repeat step 1.
     * 3. Refresh auth using refresh token if exist
     * 4. Do full authentication (will prompt for login and access grant)
     **/
    public void authenticate() {
      message("Attempting authentication using Google OAuth2");

      if (!hasValidAccessToken()) {
        read();
        if (!hasValidAccessToken()) {
          if (refresh_token != null) {
            refreshToken();
          } else {
            doFullAuth();
          }
        }
      }

    }

    Json.Object request(string params) {
      var session = new Soup.SessionSync();
      var message = new Soup.Message("POST", "https://accounts.google.com/o/oauth2/token");
      message.set_request("application/x-www-form-urlencoded", Soup.MemoryUse.COPY, params.data);
      session.send_message(message);
      var data = (string) message.response_body.flatten().data;
      var parser = new Json.Parser();
      try {
        parser.load_from_data (data, -1);
      } catch (Error e) {
        critical(e.message);
      }
      var object = parser.get_root().get_object();
      return object;
    }

    void requestToken(string code) {
      debug("Attempting to get new access token from authorization code");

      var params = @"code=$(code)&";
      params += "client_id=237167695494.apps.googleusercontent.com&";
      params += "client_secret=kfqqhqU4RiWQ5nolCOlMbH3O&";
      params += "redirect_uri=urn:ietf:wg:oauth:2.0:oob&";
      params += "grant_type=authorization_code";

      var object = request(params);

      access_token = object.get_string_member("access_token");
      expires_in = object.get_int_member("expires_in"); 
      refresh_token = object.get_string_member("refresh_token");
      issued = new DateTime.now_local().to_unix();
      write();

    }

    void refreshToken() {
      debug("Attempting to use refresh token to get new access token");

      var params = "client_id=237167695494.apps.googleusercontent.com&";
      params += "client_secret=kfqqhqU4RiWQ5nolCOlMbH3O&";
      params += @"refresh_token=$(refresh_token)&";
      params += "grant_type=refresh_token";

      var object = request(params);

      access_token = object.get_string_member("access_token");
      expires_in = object.get_int_member("expires_in");
      issued = new DateTime.now_local().to_unix();
      write();
    }
  }
}
