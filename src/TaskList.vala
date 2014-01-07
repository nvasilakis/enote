namespace Note {

    public class TaskList : Gtk.TreeView {
        Note.Window window;
        Gtk.ListStore list_store;

        private enum Col { // Column Types
            TOGGLE,
            TEXT,
            ICON,
            N_COLUMNS
        }

        public TaskList(Note.Window window) {
            list_store = new Gtk.ListStore (Col.N_COLUMNS,
                                            typeof (bool),
                                            typeof (string),
                                            typeof (string));
            this.window = window;

            name  = "NoteList";
            headers_visible = false;
            enable_search = false;
            hexpand = true;
            valign = Gtk.Align.START;
            reorderable = true;
            model = list_store;

            Gtk.TreeViewColumn column;

            Gtk.CellRendererPixbuf pixbuf = new Gtk.CellRendererPixbuf ();
            pixbuf.ypad = 1;
            pixbuf.xpad = 1;
            column = new Gtk.TreeViewColumn ();
            column.pack_start (pixbuf, true);
            column.add_attribute(pixbuf, "icon_name", Col.ICON);
            append_column (column);

            Gtk.CellRendererToggle toggle = new Gtk.CellRendererToggle ();
            toggle.ypad = 1;
            toggle.xpad = 1;
            toggle.toggled.connect ((toggle, path) => {
                    Gtk.TreePath tree_path =
                        new Gtk.TreePath.from_string (path);
                    Gtk.TreeIter iter;
                    list_store.get_iter (out iter, tree_path);
                    list_store.set (iter, Col.TOGGLE, !toggle.active);
                });
            
            column = new Gtk.TreeViewColumn ();
            column.pack_start (toggle, false);
            column.add_attribute (toggle, "active", Col.TOGGLE);
            append_column (column);

            Gtk.CellRendererText text = new Gtk.CellRendererText ();
            text.ypad = 1;
            text.xpad = 1;
            text.editable = false;
            column = new Gtk.TreeViewColumn ();
            column.pack_start (text, true);
            column.add_attribute (text, "text", Col.TEXT);
            append_column (column);
            columns_autosize ();
//            stdout.printf(get_activate_on_single_click().to_string());
            stdout.printf("\n");
//            enable_grid_lines = true;
//            set_activate_on_single_click(true);
//            this.activate_on_single_click = true;
// requires Gtk > 3.8

            row_activated.connect (update_main);
        }

        public void update_main(Gtk.TreePath path, Gtk.TreeViewColumn column) {
            Gtk.TreeIter iter;
            bool tmp = list_store.get_iter (out iter, path);
            assert (tmp == true);
//                    stdout.printf(iter.get_type().name());
//                    stdout.printf(path.get_type().name());
//                    stdout.printf());

            GLib.Value cell;
            list_store.get_value (iter, Col.TEXT, out cell);
            string text = (string) cell;
            stdout.printf(text.concat("\n"));
            this.window.view.update_main(text);
            this.window.view.show_all();
        }

        public void insert(string ttask) {
            if (ttask == "") return;
            string task = normalize(ttask);
            Gtk.TreeIter iter;
            list_store.append (out iter);
            list_store.set (iter,
                            Col.TEXT,
                            task,
                            Col.TOGGLE,
                            false,
                            Col.ICON,
                            "view-list-symbolic");
        }

// Returns only the needed length based on column width
// TODO: Need to compute unicode length correctly!
        public string normalize(string task) {
            if (task.length >= 22)
                return task.substring(0,20).concat("..");
            else
                return task;
        }
    }
}