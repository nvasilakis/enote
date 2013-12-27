using Gtk;

namespace Notes{
    public class Window : Gtk.Window {
        Box mainbox;
        Gtk.Toolbar toolbar;
        Widget current;

        public Window(Granite.Application application) {
            title = "Notes";
            set_default_size(400,500);
            window_position = Gtk.WindowPosition.CENTER;
            destroy.connect(Gtk.main_quit);
            try {
                icon_name = "text-richtext";
            } catch (Error e) {
                stderr.printf("Could not find proper icon");
            }
        }

        public void add_menu(Granite.Widgets.AppMenu am){
            // build header
            mainbox = new Box(Gtk.Orientation.VERTICAL, 0);
            toolbar = new Toolbar();
            var img = new Image.from_icon_name ("mail-message-new",
                                                  IconSize.SMALL_TOOLBAR);
            var btn_create = new ToolButton (img, "Create");
            btn_create.clicked.connect (swap_to_main);
            toolbar.insert (btn_create,0);
            var btn_gear = am;
            btn_gear.set_expand(true);

            btn_gear.set_halign(Align.END);
            var separator = new SeparatorToolItem ();
            toolbar.add (separator);
            toolbar.add(btn_gear);
            toolbar.get_style_context ().add_class ("primary-toolbar");
            mainbox.pack_start(toolbar, false, false);
            add(mainbox);
        }

        public void swap_to_welcome() {
            var welcome = new Granite.Widgets.Welcome("Nothing Yet",
                                      "Take a note or set-up a reminder.");
            welcome.append ("mail-message-new",
                            "Create",
                            "Set up a task.");
            welcome.append ("folder-remote",
                            "Import",
                            "Import tasks from another machine.");
            current = welcome;
            clear_mainbox();
            mainbox.pack_start(current);
            mainbox.show_all();
        }

        public void swap_to_main(){
            // The button:
            Gtk.Switch _switch = new Gtk.Switch ();
            _switch.notify["active"].connect (() => {
                    if (_switch.active) {
                        stdout.printf ("The switch is on!\n");
                    } else {
                        swap_to_welcome();
                        stdout.printf ("The switch is off!\n");
                    }
                });

            // Changes the state to on:
            _switch.set_active (true);
            clear_mainbox();
            mainbox.pack_start(_switch);
            mainbox.show_all();
        }

        public void clear_mainbox(){
            foreach(var child in mainbox.get_children()){
                if (child == toolbar)
                    continue;
                mainbox.remove(child);
            }
        }
    }
}