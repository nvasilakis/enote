namespace Enote {
  public class PreferencesWindow : Gtk.Dialog {

    public const int MIN_WIDTH = 420;
    public const int MIN_HEIGHT = 300;

    private Gee.Map<int, unowned NoteBookPage> sections = new Gee.HashMap<int, unowned NoteBookPage> ();
    private Granite.Widgets.StaticNotebook main_static_notebook;
    public Gtk.FileChooserButton directory_chooser;
    private Gtk.Switch organize_folders_switch;
    private Gtk.Switch write_file_metadata_switch;
    private Gtk.Switch copy_imported_music_switch;
    private Gtk.Switch hide_on_close_switch;
    public NoteBookPage general;
    public NoteBookPage sync;
    private Gtk.Switch show_notifications_switch;

    public PreferencesWindow (Gtk.Window window) {
      build_ui(window);

      // Add general section
      directory_chooser = new Gtk.FileChooserButton ("Directory to Store Tasks…", Gtk.FileChooserAction.SELECT_FOLDER);
      directory_chooser.hexpand = true;

      directory_chooser.set_current_folder ("~/Documents/");
      //library_filechooser.file_set.connect (() => {
      //  lw.setMusicFolder(library_filechooser.get_current_folder ());
      //});

      //directory_chooser.set_local_only (true);
      //var general_section = new GeneralPage (directory_chooser);

      general = new NoteBookPage ("General");

      int row = 0;

      var label = new Gtk.Label ("Task Folder Location");
      general.add_section (label, ref row);

      var spacer = new Gtk.Label ("");
      spacer.set_hexpand (true);

      general.add_full_option (directory_chooser, ref row);

      label = new Gtk.Label ("Notes:");
      general.add_section (label, ref row);

      organize_folders_switch = new Gtk.Switch ();
      //main_settings.schema.bind("update-folder-hierarchy", organize_folders_switch, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Ask for confirmation before deleting: "), organize_folders_switch, ref row);

      //write_file_metadata_switch = new Gtk.Switch ();
      //main_settings.schema.bind("write-metadata-to-file", write_file_metadata_switch, "active", SettingsBindFlags.DEFAULT);
      //general.add_option (new Gtk.Label ("Inverse task order:"), write_file_metadata_switch, ref row);

      copy_imported_music_switch = new Gtk.Switch ();
      //main_settings.schema.bind("copy-imported-music", copy_imported_music_switch, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Show notifications 5' earlier:"), copy_imported_music_switch, ref row);

      label = new Gtk.Label ("Desktop Integration:");
      general.add_section (label, ref row);

      show_notifications_switch = new Gtk.Switch ();
      //main_settings.schema.bind("show-notifications", show_notifications_switch, "active", SettingsBindFlags.DEFAULT);
      general.add_option (new Gtk.Label ("Show intrusive notifications:"), show_notifications_switch, ref row);

      hide_on_close_switch = new Gtk.Switch ();
      //main_settings.schema.bind("close-while-playing", hide_on_close_switch, "active", SettingsBindFlags.INVERT_BOOLEAN);
      general.add_option (new Gtk.Label ("Play sounds on notification"), hide_on_close_switch, ref row);


      sync = new NoteBookPage ("Synchronization");

      label = new Gtk.Label ("Google Tasks Account:");
      sync.add_section (label, ref row);

      organize_folders_switch = new Gtk.Switch ();
      //main_settings.schema.bind("update-folder-hierarchy", organize_folders_switch, "active", SettingsBindFlags.DEFAULT);
      sync.add_option (new Gtk.Label ("Synchronize with google tasks"), organize_folders_switch, ref row);

      //write_file_metadata_switch = new Gtk.Switch ();
      ////main_settings.schema.bind("write-metadata-to-file", write_file_metadata_switch, "active", SettingsBindFlags.DEFAULT);
      //sync.add_option (new Gtk.Label ("Write metadata to file:"), write_file_metadata_switch, ref row);

      //copy_imported_music_switch = new Gtk.Switch ();
      ////main_settings.schema.bind("copy-imported-music", copy_imported_music_switch, "active", SettingsBindFlags.DEFAULT);
      //sync.add_option (new Gtk.Label ("Copy imported files to Library:"), copy_imported_music_switch, ref row);

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
