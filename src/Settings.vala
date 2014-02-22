namespace enote{
  public class SavedState : Granite.Services.Settings {

    public int window_width { get; set; }
    public int window_height { get; set; }
    public int opening_x { get; set; }
    public int opening_y { get; set; }
    public int notification_x { get; set; }
    public int notification_y { get; set; }
    public bool window_state { get; set; }

    public SavedState () {
      base ("org.pantheon.enote.saved-state");
    }
  }

  public class Preferences : Granite.Services.Settings {

    public string db_dir { get; set; }
    public bool ask_delete { get; set; }
    public bool early_notifications { get; set; }
    public bool intrusive_notifications { get; set; }
    public bool play_sound { get; set; }
    public bool show_inverse { get; set; }

    public bool gsync { get; set; }
    public string user_name { get; set; }
    public string session_key { get; set; }

    public Main ()  {
      base ("org.pantheon.enote.settings");
      if (music_folder == "") {
        music_folder = GLib.Environment.get_user_special_dir (GLib.UserDirectory.MUSIC);
      }
    }

  }
}
