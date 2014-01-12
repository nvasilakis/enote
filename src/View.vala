namespace Note{
    public class LeftPane : Gtk.Grid {
        Note.Window window;

        public Gtk.Entry entry;
        Note.TaskList tlist;
        Gtk.ScrolledWindow scrolled_window;

        public LeftPane (Note.Window window) {
            this.window = window;
            tlist = new TaskList(window);
            populate ();
            attach(tlist, 0, 1, 1, 1);
        }

        // TODO: A sophisticated populate function that serves 
        // -- Demo purposes
        // -- Debugging purposes
        private void populate(){
            for (int i=0; i <10; i++) {
                //TODO fix create ticket/notify with date setter!
                Task t = new Task.with_date("Breakfast",
                      new DateTime.now_local().add_seconds(1+(10*i)));
                t.more = "We are the people that rule the world";
//                t.date = new  DateTime.now_local().add_seconds(1);
                t.title = "Meeting changed time";
                tlist.append(t);
            }
        }
/*
            scrolled_window = new Gtk.ScrolledWindow (null, null);

            scrolled_window.expand = true;
            scrolled_window.set_policy (Gtk.PolicyType.NEVER,
                                        Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add (tlist);

            entry = new Gtk.Entry();
            entry.name = "Entry";
            entry.placeholder_text = Utils.INIT_TEXT;
//            entry.max_length = 20;
//            entry.max_width = 50
            entry.hexpand = false;
            entry.valign = Gtk.Align.END;
            entry.secondary_icon_name  = "list-add-symbolic";
            entry.secondary_icon_tooltip_text = Utils.TOOLTIP_TEXT;

            entry.activate.connect(() => {this.insert(entry.text);});
            entry.icon_press.connect(() => {this.insert(entry.text);});

            expand = false;
            attach (scrolled_window, 0, 1, 1, 1);
            attach (entry, 0, 2, 1, 1);
*/
        public void insert(string text) {
            tlist.append(new Task(text));
            entry.text = "";
        }
    }

    public class MainView : Gtk.Box {
        Note.LeftPane lpane;

        public MainView (Note.Window window) {
            orientation = Gtk.Orientation.HORIZONTAL;
            lpane = new LeftPane(window);
            add(lpane);
        }
    }
}