using Gtk;

namespace Enote{
  public class Application : Granite.Application  {

    construct {
      program_name        = "Enoté";
      build_version       = "0.1";
      build_release_name  = "Aether";
      exec_name           = "enote";
      app_years           = "2013 - 2014";
      app_icon            = Utils.ICON;
      app_launcher        = "enote.desktop";
      application_id      = "org.elementary.enote";
      main_url            = "https://www.github.com/nvasilakis/enote";
      bug_url             = "https://github.com/nvasilakis/enote/issues";
      help_url            = "https://github.com/nvasilakis/enote/wiki";
      translate_url       = "https://transifex.com/p/enote";

      about_authors       = {"Nikos Vasilakis <nikos@vasilak.is>"};
      about_license_type  = License.LGPL_3_0;
    }

    public void build_and_run (string[] args) {
      // Grab command line arguments
      try {
        OptionContext context = new OptionContext ("enote");
        context.add_main_entries (Utils.args, "enote");
        context.set_help_enabled (true);
        context.parse(ref args);
      } catch (OptionError e) {
        stdout.printf ("error: %s\n", e.message);
        stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
      }

      Granite.Services.Logger.DisplayLevel =
        (Utils.DEBUG ?
         Granite.Services.LogLevel.DEBUG :
         Granite.Services.LogLevel.WARN);


      Window layout = new Window(this);
      layout.add_menu(create_appmenu(new Gtk.Menu()));
      //            layout.swap_to_welcome();
      layout.swap_to_main();
      layout.show_all();
    }


    public static int main(string [] args) {
      Gtk.init(ref args);
      new Application().build_and_run(args);
      Gtk.main();
      return 0;
    }
  }
}
