namespace Note {

    // TODO: make use of ListBox -- added in GTK+ 3.10
    // http://valadoc.org/#!api=gtk+-3.0/Gtk.ListBox
    public class TaskList : Gtk.ScrolledWindow {
        Note.Window window;
        GLib.List<RecordView> records;
        Gtk.Box grid;
        Gtk.Viewport viewport;

        public TaskList(Note.Window window) {
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
            show_all();
            record.show_everything();
        }
    }
}