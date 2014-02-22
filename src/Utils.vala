/**
 * Summary: Generic utilities providing mostly static methods to facilitate
 * use. 
 *
 * Copyright (c) 2013-2014 Nikos Vasilakis. All rights reserved.
 *
 * Use of this source code is governed by a GPL v3 license that can be
 * found in LICENSE file or at http://nikos.vasilak.is/LICENSE
 */
namespace Enote {

  public class Utils {
    //application constants
    public const string INIT_TEXT = "Breakfast at Milliway's at 7am";
    public const string TOOLTIP_TEXT = "Add Task";
    public const string ICON = "enote";
    public const string DATA_SUFFIX = "/.enote/n.db";
    //boot params
    public static bool DEBUG = false;
    public static Facade view;

    // Preferences parameters with default values
    public static SavedState saved_state;
    public static Preferences preferences;
    // 3 next could be a non-exclusive radio selection a la bootstrap
    public static bool add_ntf_early_5_mins  = true;
    public static bool add_ntf_early_15_mins = false;
    public static bool add_ntf_early_1_hour  = false;
    public static int days_to_rm_checked_recs = 7;

    public static const OptionEntry[] args = {
      { "debug",'d', 0, OptionArg.NONE, out Utils.DEBUG,
        "Enable debug logging", null },
      { null } //list terminator
    };

    // Check if a file exists
    public static  bool file_exists(string fpath) {
      var f = File.new_for_path(fpath);
      var e = f.query_exists();
      debug("exists? " + e.to_string());
      return e;
    }

    // Check if all characters in a string array are digits
    // This is only used with arrays of length two for time
    // calculations
    public static  bool are_digits(string digits) {
      foreach (char c in digits.to_utf8()) {
        if (!c.isdigit())
          return false;
      }
      return true;
    }

    // Check if suffix it is
    public static int has_suffix(string hay, string needle) {
      if (hay.has_suffix(needle)) {
        var t = hay.replace(needle,"").strip();
        if (are_digits(t))
          return int.parse(t);
      }
      return 0;
    }

    // the integer analogue of OR-ing boolean values
    // if there is any value > 0, it returns the first
    // otherwise it returns 0.
    public static int or_int (int nu, ...) {
      int res = 0;
      var varargs = va_list();
      for (int i=0; i<nu; i++) {
        int v = varargs.arg();
        if (v>0) {
          res += v;
          break;
        }
      }
      return res;
    }

    /*
    public static void parse_settings (Settings sts) {
      // TODO optimize
      var op1 = (Environment.get_home_dir()+ DATADIR_SUFFIX);
      var op2 =(sts.get_string("db-dir") + DATADIR_SUFFIX);
      db = (sts.get_string("db-dir") == "")? op1 : op2;
      debug("db file:" + Utils.db);
      intrusive = sts.get_boolean("intrusive-notifications");
      ask_delete = sts.get_boolean("ask-delete");
      show_inverse = sts.get_boolean("show-inverse");
      play_sound = sts.get_boolean("play-sound");
    }
    */

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
  public enum DB {
    CREATE,
      LOAD,
      SAVE,
      INSERT,
      QUERY,
      UPDATE,
      DELETE
  }

  public enum Facade {
    WELCOME,
      MAIN
  }

  public enum Clock{
    PM,
      AM,
      NONE
  }

  /**
   * Sort of functional wrapper for Datetime, used mostly for
   * the parser (can result in "None").
   * Might be able to leverage exceptions?
   **/
  public class Epoch {
    bool valid;
    DateTime date_time;


    // Creates current epoch
    public Epoch() {
      date_time = new DateTime.now_local();
      valid = true;
    }

    public Epoch.invalid() {
      valid = false;
    }

    // next valid time,
    // current implementation makes simple assumptions
    public Epoch.next(int h, int m, Clock c) {
      valid = true;
      var now = new DateTime.now_local();
      h = (c == Clock.PM && h !=12)? (h+12) : h;
      // Now time should be between 0/24
      if (is_valid_time (h, m)) {
        date_time = new DateTime.local(now.get_year(),
            now.get_month(),
            now.get_day_of_month(),
            h,
            m,
            0);
      } else {
        valid = false;
      }
    }

    public Epoch.add_minutes (int m) {
      valid = true;
      date_time = new DateTime.now_local().add_minutes(m);
    }

    public Epoch.add_hours (int h) {
      valid = true;
      date_time = new DateTime.now_local().add_hours(h);
    }

    public Epoch.add_days (int d) {
      valid = true;
      date_time = new DateTime.now_local().add_days(d);
    }

    private bool is_valid_time(int h, int m) {
      return ((h >= 0 && h < 24) && (m >= 0 && m < 60));
    }

    public bool is_valid() {
      return valid;
    }

    public DateTime get_date() {
      return date_time;
    }
  }
}
