namespace Note{
    // TODO: make use of ListBox -- added in GTK+ 3.10
    // http://valadoc.org/#!api=gtk+-3.0/Gtk.ListBox
    public class TaskListView : Gtk.ScrolledWindow {
        Note.Window window;
        GLib.List<RecordView> records;
        Gtk.Box grid;
        Gtk.Viewport viewport;

        public TaskListView(Note.Window window) {
            this.window = window;
            expand = true;
            set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
            records = new GLib.List<RecordView>();
            // The Grid:)
            grid = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            viewport = new Gtk.Viewport (null, null);
            this.add (viewport);
            viewport.add(grid);
            window.add(this);
        }

        public void append(Task task) {
            RecordView record = new RecordView(window, task);
            records.append(record);
            var sep = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            grid.pack_start(sep);
            grid.pack_start(record);
//            show_all();
            record.show_everything();
        }
    }

    public class MainView : Gtk.Grid {
        Note.Window window;
        // Quick-add entry
        public Gtk.Entry quick;
        public Note.TaskListView tlview {get; private set;}
        Gtk.ScrolledWindow scrolled_window;

        public MainView (Note.Window window) {
            this.window = window;
            tlview = new TaskListView(window);
            expand = true;
            row_homogeneous = false;
            attach(tlview, 0, 1, 1, 1);
            attach_quick();
        }

        private void attach_quick(){
            quick = new Gtk.Entry();
//            quick.name = "Entry";
            quick.placeholder_text = Utils.INIT_TEXT;
//            quick.max_length = 20;
//            quick.max_width = 50;
            quick.hexpand = true;
            quick.valign = Gtk.Align.END;
//            quick.halign = Gtk.Align.END;
            quick.secondary_icon_name  = "list-add-symbolic";
            quick.secondary_icon_tooltip_text = Utils.TOOLTIP_TEXT;
            quick.activate.connect(() => {insert(quick.text);});
            quick.icon_press.connect(() => {insert(quick.text);});
//            expand = true;
            attach (quick, 0, 2, 1, 1);
        }

        public void insert(string text) {
            window.tlist.add(new Task.from_parser(text));
            quick.text = "";
        }
    }
}