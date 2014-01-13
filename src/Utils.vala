namespace Note {

	public class Utils {
		//application constants
		public const string INIT_TEXT = "Breakfast at Milliway's at 7am";
        public const string TOOLTIP_TEXT = "Add Task";
		public const string ICON = "text-richtext";

		//boot params
		public static bool DEBUG = false;

        // Preferences parameters
        public static bool intrusive_notifications = false;
        public static bool ask_delete_confirmation = false;
        public static string  path_to_store_data = "";
        public static bool show_thread_inverse   = false;
        // 3 next could be a non-exclusive radio selection a la bootstrap
        public static bool add_ntf_early_5_mins  = true;
        public static bool add_ntf_early_15_mins = false;
        public static bool add_ntf_early_1_hour  = false;
        public static bool register_ntf_indication = false;
        public static bool play_sound_on_ntfctn  = false;

		public static const OptionEntry[] args = {
            { "debug",'d', 0, OptionArg.NONE, out Utils.DEBUG,
			  "Enable debug logging", null },
            { null } //list terminator
        };

        // A sophisticated populate function that serves
        // -- Demo purposes
        // -- Debugging purposes
        public static void RunTests(Note.Window window) {

            Task t1 = new Task.with_date("Buy present for Nikki",
                              new DateTime.now_local().add_seconds(10));
            t1.more = "Katie had a good idea (bluemercury?) -- Send email";
            t1.important = false;

            window.view.tlview.append(t1);

            Task t2 = new Task.with_date("Meeting with Andrew on φ-mail",
                                   new DateTime.now_local().add_minutes(1));
            t2.more = "Answer I need to have: why φ? Possible answers: ";
            t2.more += "To show that this application supports i18n? ";
            t2.important = true;
            window.view.tlview.append(t2);
/*
            t = new Task.with_date("It's my day of the week to cook!",
                                   new DateTime.now_local().add_minutes(23));
            t.more = "Can pick groceries on the way";
            t.repeating = true;
            window.view.tlview.append(t);


            t = new Task.with_date("Check chapters on Protocol Stack from" +
                                   "FreeBSD Book ",
                                   new DateTime.now_local().add_minutes(1));
            t.more = ("Chapters 12,13 from 'The Design and Implementation" +
                      "of the FreeBSD Operating System' by Marshall Kirk"  +
                      "McKusick and George V. Neville-Neil.");
            t.important = true;
            window.view.tlview.append(t);

            t = new Task.with_date("Read protocol papers",
                                   new DateTime.now_local().add_hours(1));
            t.more = "FoxNet, rvr, etc.";
            window.view.tlview.append(t);

            t = new Task.with_date("Breakfast at Milliway's! ",
                                   new DateTime.now_local().add_days(-1));
            t.more = ("Since I already did three impossible things this " +
                      "morning, why not round it off with a breakfast at " +
                      "the end of the galaxy?");
            t.done = true;
            window.view.tlview.append(t);

            t = new Task.with_date("Build a Notes/Tasks application in " +
                                   "Vala (Milestone 0.1)",
                                   new DateTime.now_local().add_days(-1));
            t.more = ("TODO:\n * Granite Welcome Screen\n *List of Tasks" +
                      "\n * Insert Quick task (+Parsing Engine)\n * Insert"+
                      " new task\n * Icons and tooltips \n * i18n " +
                      "(transifex?)\n * Analytics\n * Candidate names: " + 
                      "Note, Pistachio ");
            t.done = true;
            window.view.tlview.append(t);

            t = new Task.with_date("Hatch a dragon",
                                   new DateTime.now_local().add_days(-1));
            t.more = ("Assortment of urls: * http://vimeo.com/75093196\n " +
                      "* http://vimeo.com/62092214\n"+
                      "* http://vimeo.com/29017795");
            t.done = true;
            window.view.tlview.append(t);
*/
        }
	}
}