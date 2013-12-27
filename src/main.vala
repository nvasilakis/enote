using Gtk;

namespace Notes{
    public class Application : Granite.Application  {
        construct {
            program_name        = "Notes";
            exec_name           = "Notes";
            app_years           = "2013";
            app_icon            = "application-default-icon";
            app_launcher        = "notes.desktop";
            application_id      = "org.elementary.notes";
            main_url            = "https://www.github.com/nvasilakis/note";
            bug_url             = "https://github.com/nvasilakis/note/issues";
            help_url            = "https://github.com/nvasilakis/note/wiki";
            translate_url       = "https://transifex.com/p/note";

            about_authors       = {"Nikos Vasilakis <nikos@vasilak.is>"};
            about_license_type  = License.LGPL_3_0;
        }

        public void build_and_run () {
            Window layout = new Window(this);
            layout.add_menu(create_appmenu(new Gtk.Menu()));
            layout.swap_to_welcome();
            layout.show_all();
        }

        public override void activate () {
            stdout.printf ("activated\n");
        }

        public static int main(string [] args) {
            Gtk.init(ref args);
            new Application().build_and_run();
            Gtk.main();
            return 0;
        }
    }
}
