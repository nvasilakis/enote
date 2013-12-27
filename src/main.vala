using Gtk;

namespace Notes{
    public class Application : Granite.Application  {
        construct {
            application_id      = "org.pantheon.notes";
            program_name        = "Notes";
            exec_name           = "notes";
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
