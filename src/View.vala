namespace Note{

    public class LeftPane : Gtk.Grid {
        public const string INIT_TEXT = "Dinner at Pacho's at 7pm";
        public const string TOOLTIP_TEXT = "Add Task";
        Note.Window window;
        public Gtk.Entry entry;
        Note.TaskList tlist;
        Gtk.ScrolledWindow scrolled_window;

        public LeftPane (Note.Window window) {
            this.window = window;
            tlist = new TaskList(window);
            scrolled_window = new Gtk.ScrolledWindow (null, null);

            scrolled_window.expand = true;
            scrolled_window.set_policy (Gtk.PolicyType.NEVER,
                                        Gtk.PolicyType.AUTOMATIC);
            scrolled_window.add (tlist);

            entry = new Gtk.Entry();
            entry.name = "Entry";
            entry.placeholder_text = INIT_TEXT;
//            entry.max_length = 20;
//            entry.max_width = 50
            entry.hexpand = false;
            entry.valign = Gtk.Align.END;
            entry.secondary_icon_name  = "list-add-symbolic";
            entry.secondary_icon_tooltip_text = TOOLTIP_TEXT;

            entry.activate.connect(() => {this.insert(entry.text);});
            entry.icon_press.connect(() => {this.insert(entry.text);});

            expand = false;
            attach (scrolled_window, 0, 1, 1, 1);
            attach (entry, 0, 2, 1, 1);
        }

        public void insert(string text) {
            tlist.insert(text);
            entry.text = "";
        }
    }

    public class MainView : Gtk.Box {
        Note.LeftPane lpane;
        Gtk.ScrolledWindow  rpane;
        Gtk.TextView  view;

        public MainView (Note.Window window) {
            orientation = Gtk.Orientation.HORIZONTAL;
            lpane = new LeftPane(window);


//            rpane = new Gtk.TextView();
            // A ScrolledWindow:
            rpane = new Gtk.ScrolledWindow (null, null);
            // The TextView:
            view = new Gtk.TextView ();
            view.set_wrap_mode (Gtk.WrapMode.WORD);
            view.buffer.text = "Lorem Ipsum";
            rpane.add (view);

/*
            rpane.override_font (Pango.FontDescription.from_string ("12"));
            rpane.editable = true;
//            rpane.wrap_mode = Gtk.WrapMode.WORD_CHAR;
            rpane.valign = Gtk.Align.START;

            rpane.vexpand = false;
            rpane.hexpand = false;
            rpane.buffer.text = "one two three four";
*/

            add(lpane);
            pack_start (rpane, true, true, 0);
            lpane.entry.grab_focus();
        }

        public void update_main(string text) {
            view.buffer.text = text;
        }
    }
}