namespace Enote{
  public class SavedState : Granite.Services.Settings {
    // Only saved state
    public int window_width { get; set; }
    public int window_height { get; set; }
    public int opening_x { get; set; }
    public int opening_y { get; set; }
    public int notification_x { get; set; }
    public int notification_y { get; set; }
    public string window_state { get; set; }

    public SavedState () {
      base ("org.pantheon.enote.saved-state");
    }
  }

  public class GTasks : Granite.Services.Settings {
    public string access_token {get; set;}
    public string refresh_token {get; set;}
    public int expires_in {get; set;}
    public int issued {get; set;}

    public GTasks () {
      base ("org.pantheon.enote.gtasks");
    }
  }

  public class Preferences : Granite.Services.Settings {
    // General tab
    public string db_dir { get; set; }
    public bool ask_delete { get; set; }
    public bool early_notifications { get; set; }
    public bool intrusive_notifications { get; set; }
    public bool play_sound { get; set; }
    public bool hide_on_close { get; set; }
    public bool show_inverse { get; set; }
    // Synchronization tab -- Is this obsolete?
    public bool gsync { get; set; }
    public string user_name { get; set; }
    public string session_key { get; set; }

    public Preferences ()  {
      base ("org.pantheon.enote.preferences");
      if (db_dir == "") {
        db_dir = (Environment.get_home_dir()+ Utils.DATA_SUFFIX);
      }
    }

  }
}
