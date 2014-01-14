namespace Enote {

  public class Utils {
    //application constants
    public const string INIT_TEXT = "Breakfast at Milliway's at 7am";
    public const string TOOLTIP_TEXT = "Add Task";
    public const string ICON = "text-richtext";

    //boot params
    public static bool DEBUG = false;

    // Preferences parameters with default values
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
    public static int days_to_rm_checked_recs = 7;

    public static const OptionEntry[] args = {
      { "debug",'d', 0, OptionArg.NONE, out Utils.DEBUG,
        "Enable debug logging", null },
      { null } //list terminator
    };

    // A sophisticated populate function that serves
    // -- Demo purposes
    // -- Debugging purposes
    public static void RunTests(Enote.Window window) {

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

      Task t3 = new Task.with_date("It's my day of the week to cook!",
          new DateTime.now_local().add_minutes(23));
      t3.more = "Can pick groceries on the way";
      t3.repeating = true;
      window.view.tlview.append(t3);

      Task t4 = new Task.with_date("Check chapters on Protocol Stack " +
          "from the FreeBSD Book ",
          new DateTime.now_local().add_minutes(1));
      t4.more = ("Chapters 12,13 from 'The Design and Implementation" +
          "of the FreeBSD Operating System' by Marshall Kirk"  +
          "McKusick and George V. Neville-Neil.");
      t4.important = true;
      window.view.tlview.append(t4);

      Task t5 = new Task.with_date("Read protocol papers",
          new DateTime.now_local().add_hours(1));
      t5.more = "FoxNet, rvr, etc.";
      window.view.tlview.append(t5);

      Task t6 = new Task.with_date("Breakfast at Milliway's! ",
          new DateTime.now_local().add_days(-1));
      t6.more = ("Since I already did three impossible things this " +
          "morning, why not round it off with a breakfast at " +
          "the end of the galaxy?");
      t6.done = true;
      window.view.tlview.append(t6);

      Task t7 = new Task.with_date("Build a Enotes/Tasks application in " +
          "Vala (Milestone 0.1)",
          new DateTime.now_local().add_days(-1));
      t7.more = ("TODO:\n * Granite Welcome Screen\n *List of Tasks" +
          "\n * Insert Quick task (+Parsing Engine)\n * Insert"+
          " new task\n * Icons and tooltips \n * i18n " +
          "(transifex?)\n * Analytics\n * Candidate names: " + 
          "Enote, Pistachio, lapp, enoté  ");
      t7.done = true;
      window.view.tlview.append(t7);

      Task t8 = new Task.with_date("Hatch a dragon",
          new DateTime.now_local().add_days(-1));
      t8.more = ("Assortment of urls: * http://vimeo.com/75093196\n " +
          "* http://vimeo.com/62092214\n"+
          "* http://vimeo.com/29017795");
      t8.done = true;
      window.view.tlview.append(t8);
    }
  }
}
