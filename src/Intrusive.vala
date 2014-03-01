namespace Enote {
    public class Intrusive : Granite.Widgets.LightWindow {
        private Gtk.Image img;
        private Gtk.Label view;
        public Gtk.Button ok;
        public Gtk.Button snooze;
        private Gtk.Box container;

        public Intrusive (string message = "") {
            this.set_title("Reminder!");
            this.box.foreach ((w) => {
                this.box.remove (w);
            });
            close_img = new Gdk.Pixbuf(Gdk.Colorspace.RGB, true, 8, 1, 1);
            container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box.add (container);
            set_gravity(Gdk.Gravity.NORTH_EAST);
            move(Gdk.Screen.width()-100,0);

            set_modal (true);
            set_keep_above (true);
            img = new Gtk.Image.from_icon_name ("enote", Gtk.IconSize.DIALOG);

            view = new Gtk.Label ("<b>Reminder!</b>\n " + message);
            view.set_use_markup (true);
            view.set_line_wrap (true);
            Gtk.Box  top = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            Gtk.Box imgbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            imgbox.pack_start (this.img, false, false, 0);
            imgbox.margin_right = 12;
            imgbox.margin_top = 12;
            top.add (imgbox);
            top.add (view);
            top.margin_top = 1;
            top.margin_bottom = 1;
            top.margin_right = 10;
            top.margin_left = 10;

            ok = new Gtk.Button.with_label ("OK");
            ok.set_size_request (100, -1);
            ok.clicked.connect (() => {
                this.destroy ();
            });

            snooze = new Gtk.Button.with_label ("Snooze");
            snooze.set_size_request (100, -1);
            snooze.margin_left = 6;
            snooze.get_style_context().add_class ("suggested-action");

            Gtk.Box bottom = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            bottom.pack_start (new Gtk.Label (""), true, true, 0);
            bottom.pack_start (ok, false, false, 0);
            bottom.pack_start (snooze, false, false, 0);
            bottom.margin = 5;
            container.add (top);
            container.add (bottom);
        }
    }
}
