namespace Note {

    public class View : Gtk.TreeView {
        Note.Window window;
        Gtk.ListStore list_store;

        private enum Col { // Column Types
            TOGGLE,
            TEXT,
            ICON,
            N_COLUMNS
        }

        public View(Note.Window window) {
            list_store = new Gtk.ListStore (Col.N_COLUMNS, typeof (bool), typeof (string), typeof (string));
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
                    Gtk.TreePath tree_path = new Gtk.TreePath.from_string (path);
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
            text.editable = true;
            column = new Gtk.TreeViewColumn ();
            column.pack_start (text, true);
            column.add_attribute (text, "text", Col.TEXT);
            append_column (column);

    

            insert ("one two three four");
            for (int i=1; i<11; i++)
                insert ("item ".concat(i.to_string()));
            insert ("We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! We are the People that rule the World! ");

/*
  Gtk.TreeIter iter;
  list_store.append (out iter);
  list_store.set (iter, Col.TOGGLE, true, Col.TEXT, "item 1");
  list_store.append (out iter);
  list_store.set (iter, Col.TOGGLE, false, Col.TEXT, "item 2");

  toggle.xpad = 6;
  insert_column_with_attributes (-1, "Toggle", toggle, "active", 1);
  //append_column (column);

  // setup the TEXT column
  text.ypad = 6;                              // set vertical padding between rows
  text.editable = true;

  insert_column_with_attributes (-1, "Task", text, "text", 2, "strikethrough", 3);
  //column.expand = true;                       // the text column should fill the whole width of the column
  //append_column (column);

  // setup the DRAGHANDLE column
  handle.xpad = 6;
  insert_column_with_attributes (-1, "Drag", text, "text", 4);
  //append_column (column);

  insert("one");
  //insert("two");
  //insert("three");

//    cell = new Gtk.CellRendererText ();
//    insert_column_with_attributes (-1, "State", cell, "text", 0);
//    insert_column_with_attributes (-1, "Cities", cell, "text", 1);
//    list_store.append (out iter);
//    list_store.set (iter, 0, "Vienna", 1, 1);
//    list_store.append (out iter);
//    list_store.set (iter, 0, "Burgenland", 1, 13);
*/
        }

        public void insert(string ttask) {
            if (ttask == "") return;
            string task = normalize(ttask);
            Gtk.TreeIter iter;
            list_store.append (out iter);
            list_store.set (iter, Col.TEXT, task, Col.TOGGLE, false, Col.ICON, "view-list-symbolic");
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