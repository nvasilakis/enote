using Granite.Widgets;

namespace Notes {
  public class Notes:Granite.Application{
    construct {
      application_id      = "org.pantheon.notes";
      program_name        = "Notes";
      exec_name           = "notes";
      app_years           = "2013";
      build_version       = "0.1"; // automate this
      app_icon            = "notes";
      main_url            = "http://github.com/nvasilakis/notes";
	  bug_url             = main_url.concat("/issues");
	  help_url            = main_url.concat("/wiki");
	  translate_url       = "http://www.transifex.com/projects/p/notes/";
	  about_authors       = {"Nikos Vasilakis <nikos@vasilak.is>"};
      about_documenters = {"Valadoc"};
      about_comments = "Take Notes and Setup Reminders!";
      about_translators = null;
      about_license_type = Gtk.License.GPL_2_0;
    }

    public override void activate() {
      var window = new Gtk.Window ();
      window.title = "Notes";
      window.set_default_size(400, 500);
	  window.window_position = Gtk.WindowPosition.CENTER;
      window.destroy.connect(Gtk.main_quit);

      var welcome = new Welcome("Nothing Yet", 
								"Take a note or set-up a reminder.");
	  welcome.append ("document-new", 
					  "Create", 
					  "Set up a task");
	  welcome.append ("document-open", 
					  "Import", 
					  "Import tasks from another machine.");


      var mainbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
	  var barbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
      var toolbar = new Gtk.Toolbar();
//	  barbox.get_style_context ().add_class ("primary-toolbar"); //titlebar
	  toolbar.get_style_context ().add_class ("primary-toolbar"); //titlebar

	  Gtk.Image img = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.SMALL_TOOLBAR);
	  Gtk.ToolButton button1 = new Gtk.ToolButton (img, null);
	  button1.clicked.connect (() => {
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
//	  barbox.pack_start(toolbar, true, true);
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
