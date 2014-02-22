namespace Enote {
  public class PreferencesWindow : Gtk.Dialog {

    public const int MIN_WIDTH = 420;
    public const int MIN_HEIGHT = 300;

    private Gee.Map<int, unowned NoteBookPage> sections = new Gee.HashMap<int, unowned NoteBookPage> ();
    private Granite.Widgets.StaticNotebook main_static_notebook;
    public Gtk.FileChooserButton directory_chooser;
    private Gtk.Switch gsync;
    private Gtk.Switch ask_delete;
    private Gtk.Switch early_notifications;
    private Gtk.Switch play_sound;
    private Gtk.Switch intrusive_notifications;
    public NoteBookPage general;
    public NoteBookPage sync;

    public PreferencesWindow (Gtk.Window window) {
      build_ui(window);

      // Add general section
      directory_chooser = new Gtk.FileChooserButton ("Directory to Store Tasks…", Gtk.FileChooserAction.SELECT_FOLDER);
      directory_chooser.hexpand = true;

      directory_chooser.set_current_folder ("~/Documents/");
      directory_chooser.set_local_only (true);
      directory_chooser.selection_changed.connect (() => {
        Utils.preferences.db_dir = directory_chooser.get_current_folder() + Utils.DATA_SUFFIX;
        debug("Setting directory to: " + directory_chooser.get_current_folder() + Utils.DATA_SUFFIX);
      });

      general = new NoteBookPage ("General");

      int row = 0;

      var label = new Gtk.Label ("Task Folder Location");
      general.add_section (label, ref row);

      var spacer = new Gtk.Label ("");
      spacer.set_hexpand (true);

      general.add_full_option (directory_chooser, ref row);

      label = new Gtk.Label ("Notes:");
      general.add_section (label, ref row);

      ask_delete = new Gtk.Switch ();
      Utils.preferences.schema.bind("ask-delete", ask_delete, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Ask for confirmation before deleting: "), ask_delete, ref row);

      //write_file_metadata_switch = new Gtk.Switch ();
      //main_settings.schema.bind("write-metadata-to-file", write_file_metadata_switch, "active", SettingsBindFlags.DEFAULT);
      //general.add_option (new Gtk.Label ("Inverse task order:"), write_file_metadata_switch, ref row);

      early_notifications = new Gtk.Switch ();
      Utils.preferences.schema.bind("early-notifications", early_notifications, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Show notifications 5' earlier:"), early_notifications, ref row);

      label = new Gtk.Label ("Desktop Integration:");
      general.add_section (label, ref row);

      intrusive_notifications = new Gtk.Switch ();
      Utils.preferences.schema.bind("intrusive-notifications", intrusive_notifications, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Show intrusive notifications:"), intrusive_notifications, ref row);

      play_sound = new Gtk.Switch ();
      Utils.preferences.schema.bind("play-sound", play_sound, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Play sounds on notification"), play_sound, ref row);


      sync = new NoteBookPage ("Synchronization");

      label = new Gtk.Label ("Google Tasks Account:");
      sync.add_section (label, ref row);

      gsync = new Gtk.Switch ();
      Utils.preferences.schema.bind("gsync", gsync, "active", SettingsBindFlags.DEFAULT);
      sync.add_option (new Gtk.Label ("Synchronize with google tasks"), gsync, ref row);

      add_page(general);
      add_page (sync);
    }


    public int add_page (NoteBookPage section) {
      return_val_if_fail (section != null, -1);

      // Pack the section
      // TODO: file a bug against granite's static notebook: append_page()
      // should return the index of the new page.
      main_static_notebook.append_page (section, new Gtk.Label (section.name));
      int index = sections.size;
      sections.set (index, section);

      section.show_all ();

      return index;
    }


    public void remove_section (int index) {
      main_static_notebook.remove_page (index);
      sections.unset (index);
    }


    private void build_ui (Gtk.Window parent_window) {
      set_size_request (MIN_WIDTH, MIN_HEIGHT);

      // Window properties
      title = "Preferences";
      resizable = false;
      window_position = Gtk.WindowPosition.CENTER;
      type_hint = Gdk.WindowTypeHint.DIALOG;
      transient_for = parent_window;

      main_static_notebook = new Granite.Widgets.StaticNotebook (false);
      main_static_notebook.hexpand = true;
      main_static_notebook.margin_bottom = 24;

      ((Gtk.Box)get_content_area()).add (main_static_notebook);
      add_button (Gtk.Stock.CLOSE, Gtk.ResponseType.ACCEPT);
    }
  }
}
