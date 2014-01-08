using Gtk;

namespace Note{
    public class Application : Granite.Application  {

        construct {
            program_name        = "Note";
            exec_name           = "Note";
            app_years           = "2013";
            app_icon            = "application-default-icon";
            app_launcher        = "note.desktop";
            application_id      = "org.elementary.note";
            main_url            = "https://www.github.com/nvasilakis/note";
            bug_url             = "https://github.com/nvasilakis/note/issues";
            help_url            = "https://github.com/nvasilakis/note/wiki";
            translate_url       = "https://transifex.com/p/note";

            about_authors       = {"Nikos Vasilakis <nikos@vasilak.is>"};
            about_license_type  = License.LGPL_3_0;
        }

        public void build_and_run (string[] args) {
			// Grab command line arguments
			try {
				OptionContext context = new OptionContext ("Note");
				context.add_main_entries (Utils.args, "note");
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
			Granite.Services.Logger.notification("activated");

            Timeout.add(2000, update);

            Window layout = new Window(this);
            layout.add_menu(create_appmenu(new Gtk.Menu()));
            layout.swap_to_welcome();
//            layout.swap_to_main();
            layout.show_all();
        }

        public static bool update() {
            if (!Notify.init("Note"))
                critical("Failed to initialize libnotify.");
            Notify.Notification notification;
            notification = new Notify.Notification(
                "Reminder!",
                "Wake up Mr. Freeman..",
                "text-richtext");
            Granite.Services.Logger.notification("Notify-send");

			debug("debug");
			message("message");
			warning("warning");
//			error("error");
//			critical("critical");
            try {
                notification.show ();
            } catch (GLib.Error error) {
                warning ("Failed to show notification: %s", error.message);
            }
            return false;
        }

        public static int main(string [] args) {
            Gtk.init(ref args);
            new Application().build_and_run(args);
            Gtk.main();
            return 0;
        }
    }
}
