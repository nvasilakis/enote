namespace Note{

    public class LeftPane : Gtk.Grid {
        Note.Window window;
        Gtk.Entry entry;
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
            entry.placeholder_text = "Quick Note..";
            entry.max_length = 50;
            entry.hexpand = true;
            entry.valign = Gtk.Align.END;
            entry.secondary_icon_name  = "list-add-symbolic";

            expand = true;
            attach (scrolled_window, 0, 1, 1, 1);
            attach (entry, 0, 2, 1, 1);
        }
    }
}