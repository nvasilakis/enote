using Granite.Widgets;

namespace Notes {
  public class Notes:Granite.Application{
    construct {
      application_id      = "org.pantheon.notes";
      program_name        = "Notes";
      exec_name           = "notes";
      app_years           = "2013";
      build_version       = "0.1"; // automate this
      app_icon            = "application-default-icon";
      main_url            = "http://github.com/nvasilakis/notes";
      bug_url             = main_url.concat("/issues");
      help_url            = main_url.concat("/wiki");
      translate_url       = "http://www.transifex.com/projects/p/notes/";
      about_authors       = {"Nikos Vasilakis <nikos@vasilak.is>"};
      about_artists       = {"Harvey Cabaguio"};
      about_documenters   = {"Nikos Vasilakis <nikos@vasilak.is>, Valadoc"};
      about_comments      = "Take Notes and Setup Reminders!";
      about_translators   = null;
      about_license_type  = Gtk.License.GPL_2_0;
    }

    public override void activate() {
      var window = new Gtk.Window ();
      window.title = "Notes";
      window.set_default_size(400, 500);
      window.window_position = Gtk.WindowPosition.CENTER;
      try {
/* TODO: Add a proper icon
       window.icon = new Gdk.Pixbuf.from_file ("my-app.png"); */
//      window.icon = Gtk.IconTheme.get_default ().load_icon_for_scale ("mail-message-new", 128, 128, 0);
        window.icon_name = "text-richtext";
//      window.icon = Gtk.IconTheme.get_default ().load_icon ("mail-message-new", 128, 0);
      } catch (Error e) {
        stderr.printf("Could not find proper icon");
      }
      window.destroy.connect(Gtk.main_quit);

      var welcome = new Welcome("Nothing Yet", 
                  "Take a note or set-up a reminder.");
      welcome.append ("mail-message-new",
              "Create", 
              "Set up a task.");
      welcome.append ("folder-remote", 
              "Import", 
              "Import tasks from another machine.");


      var mainbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      var toolbar = new Gtk.Toolbar();


      Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow (null, null);
//    box.pack_start (scrolled, true, true, 0);
      var scr = new Gtk.TextView();
      Gtk.TextView view = new Gtk.TextView ();
      view.set_wrap_mode (Gtk.WrapMode.WORD);
      view.buffer.text = "Lorem Ipsum";
      scrolled.add (view);
      mainbox.pack_end (scrolled, true, true, 0);

      toolbar.get_style_context ().add_class ("primary-toolbar"); // or titlebar

      Gtk.Image img = new Gtk.Image.from_icon_name ("mail-message-new", Gtk.IconSize.SMALL_TOOLBAR);
      Gtk.ToolButton button1 = new Gtk.ToolButton (img, null);
      button1.clicked.connect (() => {
        mainbox.remove(welcome);
        mainbox.pack_end (scrolled, true, true, 0);
//      mainbox.add(scr);
          stdout.printf ("Button 1\n");
        });
      toolbar.insert (button1,0);



      img = new Gtk.Image.from_icon_name ("window-close", Gtk.IconSize.SMALL_TOOLBAR);
      Gtk.ToolButton button2 = new Gtk.ToolButton (img, null);
      button2.set_sensitive (false);
      button2.clicked.connect (() => {
          stdout.printf ("Button 2\n");
        });
      toolbar.insert (button2,1);

      var gearmenu = this.create_appmenu (new Gtk.Menu());
      gearmenu.set_expand(true);
      gearmenu.set_halign(Gtk.Align.END);
      Gtk.SeparatorToolItem separator = new Gtk.SeparatorToolItem ();
      toolbar.add (separator);
      toolbar.add(gearmenu);
      mainbox.pack_start(toolbar, false, false);
      mainbox.pack_start(welcome);
      window.add(mainbox);
      window.show_all();
    }
                
    public static int main(string[] args) {
     new Notes().run(args);
     Gtk.main();
     return 0;
   }
  }
}
