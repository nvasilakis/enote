/**
 * Summary: Popup window when creating a New Task.
 *
 * Copyright (c) 2013-2014 Nikos Vasilakis. All rights reserved.
 *
 * Use of this source code is governed by a GPL v3 license that can be
 * found in LICENSE file or at http://nikos.vasilak.is/LICENSE.
 */
using Granite.Widgets;

namespace Enote{
  public class NewTaskView : LightWindow {
    Gtk.Grid grid;
    HintedEntry what;
    DatePicker when_date;
    TimePicker when_time;
    Gtk.TextView notes;

    public NewTaskView(Task? t, Enote.Window window, RecordView? rview) {
      base("New Task");
      title = (t == null ? "Add a task!" : "Edit task");
      resizable = false;
      set_keep_above (true);
      window_position = Gtk.WindowPosition.CENTER;
      int x; int y;
      window.get_position(out x, out y);
      move(x, (y+100));
      set_default_size(400,500);
      set_size_request (100,200);

      grid =  new Gtk.Grid ();
      grid.margin_left = 12;
      grid.margin_right = 12;
      grid.margin_top = 12;
      grid.margin_bottom = 12;
      grid.set_row_spacing (6);
      grid.set_column_spacing (12);

      Gtk.Grid subgrid = new Gtk.Grid ();
      //            subgrid.set_sensitive (can_edit);
      subgrid.margin_left = 0;
      subgrid.margin_right = 0;
      subgrid.margin_top = 0;
      subgrid.margin_bottom = 0;
      subgrid.set_row_spacing (4);
      subgrid.set_column_spacing (8);

      var what_label = make_label ("What:");
      what = new Granite.Widgets.HintedEntry (Utils.INIT_TEXT);
      if (t != null)
        (what as Gtk.Entry).set_text(t.title);

      var when_label = make_label ("When:");
      when_date = make_date_picker ();
      when_time = make_time_picker ();
      if (t !=null) { // actually test date
        if (t.date == new DateTime.from_unix_local(0))
          when_date.set_text("");
        else
          when_date.date = t.date;
        when_time.time = t.date;
      } else {
        when_date.set_text("");
      }

      var note_label = make_label ("Notes:");
      notes = new Gtk.TextView ();
      notes.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
      if (t != null)
        notes.buffer.text = t.more;

      var scrolled = new Gtk.ScrolledWindow (null, null);
      scrolled.add (notes);
      scrolled.height_request = 100;
      scrolled.set_vexpand(true);
      scrolled.set_hexpand(true);

      subgrid.attach (what_label, 0, 0, 2, 1);
      subgrid.attach (what, 0, 1, 2, 1);
      subgrid.attach (when_label, 0, 2, 2, 1);
      subgrid.attach (when_date, 0, 3, 1, 1);
      subgrid.attach (when_time, 1, 3, 1, 1);
      subgrid.attach (note_label, 0, 4, 2, 1);
      subgrid.attach (scrolled, 0, 5, 2, 1);

      var buttonbox = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
      buttonbox.set_layout (Gtk.ButtonBoxStyle.END);

      var cancel_button = new Gtk.Button.with_label ("Cancel");
      cancel_button.set_tooltip_text ("Return to the list of tasks");
      cancel_button.clicked.connect (() => {this.destroy();});

      var create_button = new Gtk.Button.with_label (
          t == null? "Add" : "Save");
      create_button.sensitive = (what.text != "");
      var tooltip = (t==null)? "Add this task to the list":"Update task";
      create_button.set_tooltip_text (tooltip);
      what.changed.connect(() => {
          create_button.sensitive = (what.text != "");
          });
      create_button.clicked.connect(() => {
          new_task(window, t, rview);
          });

      buttonbox.pack_end (cancel_button);
      buttonbox.pack_end (create_button);
      create_button.margin_right = 5;
      grid.attach (subgrid, 0, 0, 1, 1);
      grid.attach (buttonbox, 0, 1, 1, 1);
      add (grid);
    }

    Gtk.Label make_label (string text) {
      var label = new Gtk.Label ("<span weight='bold'>"+text+"</span>");
      label.use_markup = true;
      label.set_alignment (0.0f, 0.5f);
      return label;
    }

    DatePicker make_date_picker () {
      var date_picker = new DatePicker.with_format ("%B %e, %Y");
      date_picker.width_request = 200;
      return date_picker;
    }

    TimePicker make_time_picker () {
      var time_picker = new TimePicker.with_format ("%l:%M %p");
      time_picker.width_request = 120;
      return time_picker;
    }

    /**
     * @param window The window to draw upon, needed to attach task
     * @param tid The task id in case of update, -1 if it's new
     **/
    private void new_task(Enote.Window window, Task? t, RecordView? rview) {
      bool update = (t != null);
      t = (update? t : new Task(""));
      t.title = (what as Gtk.Entry).get_text();
      if (when_date.get_text() != "") {
        debug("user picked date");
        t.date = new DateTime.local(when_date.date.get_year(),
            when_date.date.get_month(),
            when_date.date.get_day_of_month(),
            when_time.time.get_hour(),
            when_time.time.get_minute(),
            when_time.time.get_second());
      } else {
        debug("user did not pick date");
        t.date = new DateTime.from_unix_local (0);
      }
      t.more = notes.buffer.text;
      var persistence = new Persistence(Utils.db);
      if (Utils.view == Facade.WELCOME) {
        persistence.create_db();
        debug("database created");
        window.swap_to_main();
      }
      if (!update) { // new
        window.view.attach_one(t);
        persistence.insert(t);
      } else {
        persistence.update(t);
        if (rview == null)
          warning("rview==null && task!=null - what update is that?");
        // TODO: Do not reload everything!
        window.swap_to_main();
      }
      this.destroy();
    }
  }

  public class ErrorDialog : Gtk.MessageDialog {
    public ErrorDialog (string title, string message) {
      /*			var msg = new Gtk.MessageDialog (null, Gtk.DialogFlags.MODAL,
              Gtk.MessageType.Error,
              Gtk.ButtonsType.OK,
              message);
              msg.response.connect ((response_id) => { msg.destroy(); });
              msg.show();
       */
    }
  }
}
