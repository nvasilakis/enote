using Gtk;

namespace Note{
    public class Window : Gtk.Window {
        Box container;
        Gtk.Toolbar toolbar;
        Widget current;

        public Window(Granite.Application application) {
            title = "Note";
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
            container = new Box(Gtk.Orientation.VERTICAL, 0);
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
            container.pack_start(toolbar, false, false);
            add(container);
        }

        public void swap_to_welcome() {
            Note.Welcome welcome = new Note.Welcome(this);
            clear_container();
            container.pack_start(welcome);
            welcome.show_all();
        }

        public void swap_to_main(){
            Note.View view = new Note.View(this);
            clear_container();
//            this.add(view);
            container.pack_end(view);
            view.show_all();
        }

        public void clear_container(){
            foreach(var child in container.get_children()){
                if (child == toolbar)
                    continue;
                container.remove(child);
            }
        }
    }
}