/**
 * Summary: Enote entry point class. 
 *
 * It creates the application records, initializes logger, integrates
 * GSettings and creates the main window.
 *
 * Copyright (c) 2013-2014 Nikos Vasilakis. All rights reserved.
 *
 * Use of this source code is governed by a GPL v3 license that can be
 * found in LICENSE file or at http://nikos.vasilak.is/LICENSE.
 */
namespace Enote{

  public class Application : Granite.Application  {
    private Window main_window;

    construct {
      // Allows override cmd-line args method

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

      about_authors       = {"Enoté Developers <nikos@vasilak.is>"};
      about_license_type  = Gtk.License.LGPL_3_0;
    }

    public override void activate () {
      warning(get_windows().length().to_string());
      if (get_windows () == null) 
        warning ("NULL");
      else
        warning ("not null");

        try {
             this.register ();
             if (this.get_is_remote()) {
                warning("Is remote");
                main_window.show_all();
                 //this.activate ();
             } else {
                warning("Is not remote");

                warning(Utils.DEBUG.to_string());
                // Setup logging
                Granite.Services.Logger.DisplayLevel =
                  (Utils.DEBUG ?
                   Granite.Services.LogLevel.DEBUG :
                   Granite.Services.LogLevel.WARN);

                // Setup GSettings
                Utils.saved_state = new SavedState();
                Utils.preferences = new Preferences();
                // Create window
                Window main_window = new Window(this);
                main_window.add_menu();
                debug((Utils.preferences.db_dir.to_string()));
                if (Utils.file_exists(Utils.preferences.db_dir)) { // proceed with data
                  Utils.view = Facade.MAIN;
                  main_window.swap_to_main();
                } else { // welcome screen
                  debug("db does not exist");
                  Utils.view = Facade.WELCOME;
                  main_window.swap_to_welcome();
                }

            }
         }
         catch (GLib.Error error) {
             GLib.error ("Failed to activate running instance");
         }
    }

    public static int main(string [] args) {
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
      Gtk.init(ref args);
      Application enote  = new Application();
      enote.run(args);
      Gtk.main();
      return 0;
    }
  }
}
