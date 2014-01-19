namespace Enote{
    // TODO: make use of ListBox -- added in GTK+ 3.10
    // http://valadoc.org/#!api=gtk+-3.0/Gtk.ListBox
    public class TaskListView : Gtk.ScrolledWindow {
        Enote.Window window;
        GLib.List<RecordView> records;
        Gtk.Box grid;
        Gtk.Viewport viewport;

        public TaskListView(Enote.Window window) {
            this.window = window;
            expand = true;
            set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
            records = new GLib.List<RecordView>();
            // The Grid:)
            grid = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            grid.set_valign(Gtk.Align.START);
            grid.set_vexpand(false);
            viewport = new Gtk.Viewport (null, null);
            this.add (viewport);
            viewport.add(grid);
//            window.add(this);
        }

        public void append(Task task) {
            RecordView record = new RecordView(window, task);
            record.set_vexpand(false);
//            record.set_preferred_height(1,1);
//            records.append(record);
            var sep = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            sep.set_vexpand(false);
            grid.pack_end(sep, false, false, 0);
            grid.pack_end(record, false, false, 0);
            record.show_everything();
        }
    }

    public class MainView : Gtk.Grid {
        Enote.Window window;
        // Quick-add entry
        public Gtk.Entry quick;
        public Enote.TaskListView tlview {get; private set;}

        public MainView (Enote.Window window) {
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

        public void attach_one (Task t) {
            this.tlview.append(t);
        }

        public void attach_all (Array<Task> at) {
          for (int i=0; i<at.length; i++)
              attach_one(at.index(i));
        }

        public void insert(string text) {
            Task t = new Task.from_parser(text);
            window.tlist.add(t);
            Persistence persistence = new Persistence(Utils.db);
            persistence.insert(t);
            quick.text = "";
        }
    }
}