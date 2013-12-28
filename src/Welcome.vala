using Gtk;

namespace Note{
    public class Welcome : Granite.Widgets.Welcome {
        Note.Window window;

        public Welcome(Note.Window window) {
            base("Nothing Yet","Take a note or set-up a reminder!");
            this.window = window;
            append ("mail-message-new","Create","Set up a task.");
            append ("folder-remote","Import",
                    "Import tasks from another machine.");
//            clear_mainbox(); // Will be done outside
            activated.connect((index) => {
                    switch (index) {
                    case 0:
                    window.set_title("zero");
//                        Window.show_content();
                        break;
                    case 1:
                    window.set_title("one");
                        break;
                    }
                });

/*
            mainbox.pack_start(current);
            mainbox.show_all();
*/
        }
    }
}
