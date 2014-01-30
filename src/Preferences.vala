namespace Enote{
  public class Preferences : Gtk.Dialog {

    public const int MIN_WIDTH = 210;
    public const int MIN_HEIGHT = 150;
    public Gtk.FileChooserButton db_dir;
    public Gtk.Box pox;

    public Preferences (Enote.Window window) {
      set_size_request (MIN_WIDTH, MIN_HEIGHT);

      // Window properties
      title = "Preferences";
      resizable = false;
      window_position = Gtk.WindowPosition.CENTER;
      type_hint = Gdk.WindowTypeHint.DIALOG;
      transient_for = window;

      add_button (Gtk.Stock.CLOSE, Gtk.ResponseType.ACCEPT);

      // Add general section
      db_dir = new Gtk.FileChooserButton (
          "Choose where to store database file..",
          Gtk.FileChooserAction.SELECT_FOLDER);
      db_dir.hexpand = true;
      db_dir.set_current_folder ("~/");
      pox =  get_content_area () as Gtk.Box;

      var label = new Gtk.Label ("Database Location");
      pox.pack_start(label, false, false);

      var spacer = new Gtk.Label ("");
      spacer.set_hexpand (true);

      pox.pack_start (db_dir, false, false);

      label = new Gtk.Label ("Task Management");
      pox.pack_start (label, false, false);

      var swii = new Gtk.Switch ();
      var hor1  = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
      hor1.pack_start(new Gtk.Label ("Organize"),false, false);
      hor1.pack_start(swii, false, false);
      pox.pack_start(hor1, false, false);
    }
  }
}
