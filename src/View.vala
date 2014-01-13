namespace Note{
    public class LeftPane : Gtk.Grid {
        Note.Window window;
        // Quick-add entry
        public Gtk.Entry quick;
        Note.TaskList tlist;
        Gtk.ScrolledWindow scrolled_window;

        public LeftPane (Note.Window window) {
            this.window = window;
            tlist = new TaskList(window);
            expand = true;
            row_homogeneous = false;
            populate ();
            attach(tlist, 0, 1, 1, 1);
            attach_quick();
        }

        // TODO: A sophisticated populate function that serves 
        // -- Demo purposes
        // -- Debugging purposes
        private void populate(){
                Task t = new Task.with_date("Buy present for Nikki",
                      new DateTime.now_local().add_seconds(10));
                t.more = "Katie had a good idea (bluemercury?) -- Send email";
                t.important = false;
                tlist.append(t);

                t = new Task.with_date("Meeting with Andrew on φ-mail",
                      new DateTime.now_local().add_minutes(1));
                t.more = "Answer I need to have: why φ? Possible answers: ";
                t.more += "To show that this application supports i18n? ";
                t.important = true;
                tlist.append(t);

                t = new Task.with_date("It's my day of the week to cook!",
                      new DateTime.now_local().add_minutes(23));
                t.more = "Can pick groceries on the way";
                t.repeating = true;
                tlist.append(t);


                t = new Task.with_date("Check chapters on Protocol Stack from FreeBSD Book ",
                      new DateTime.now_local().add_minutes(1));
                t.more = "Chapters 12 and 13 from 'The Design and Implementation of the FreeBSD Operating System' by Marshall Kirk McKusick and George V. Neville-Neil.";
                t.important = true;
                tlist.append(t);

                t = new Task.with_date("Read protocol papers",
                      new DateTime.now_local().add_minutes(1));
                t.more = "FoxNet, rvr, etc.";
                tlist.append(t);

                t = new Task.with_date("Have breakfast at Milliway's! ",
                      new DateTime.now_local().add_minutes(1));
                t.more = "Since I already did three impossible things this morning, why not round it off with a breakfast at the end of the galaxy?";
                t.done = true;
                tlist.append(t);

                t = new Task.with_date("Build a Notes/Tasks application in Vala (Milestone 0.1)",
                      new DateTime.now_local().add_minutes(1));
                t.more = "TODO:\n * Granite Welcome Screen\n *List of Tasks\n * Insert Quick task (+Parsing Engine)\n * Insert new task\n * Icons and tooltips \n * i18n (transifex?)\n Analytics ";
                t.done = true;
                tlist.append(t);

                t = new Task.with_date("Hatch a dragon",
                      new DateTime.now_local().add_minutes(1));
                t.more = "Assortment of urls: * http://vimeo.com/75093196\n http://vimeo.com/62092214\nhttp://vimeo.com/29017795";
                t.done = true;
                tlist.append(t);
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

//            quick.activate.connect(() => {this.insert(quick.text);});
//            quick.icon_press.connect(() => {this.insert(quick.text);});
//            expand = true;
            attach (quick, 0, 2, 1, 1);
        }

        public void insert(string text) {
            tlist.append(new Task(text));
            quick.text = "";
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