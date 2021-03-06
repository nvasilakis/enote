/**
 * Summary: Startup screen when database is not there.
 *
 * Copyright (c) 2013-2014 Nikos Vasilakis. All rights reserved.
 *
 * Use of this source code is governed by a GPL v3 license that can be
 * found in LICENSE file or at http://nikos.vasilak.is/LICENSE
 */
namespace Enote{
  public class Welcome : Granite.Widgets.Welcome {
    Enote.Window window;

    public Welcome(Enote.Window window) {
      base("Nothing Yet","Take a note or set-up a reminder!");
      this.window = window;
      append ("mail-message-new","Create","Set up a task.");
      append ("folder-remote","Import",
          "Import tasks from another machine.");
      //            clear_mainbox(); // Will be done outside
      activated.connect((index) => {
        switch (index) {
          case 0:
            window.create_new_task_window();
            break;
          case 1:
            GAuth ga = new GAuth();
            ga.authenticate();

/*
            var txt = "<span weight='bold'>Sorry!</span>\n\n";
            txt += "This feature hasn't been implemented yet!";
            var msg = new Gtk.MessageDialog.with_markup (null,
              Gtk.DialogFlags.MODAL,
              Gtk.MessageType.ERROR,
              Gtk.ButtonsType.OK,
              txt);
            msg.response.connect ((response_id) => { msg.destroy(); });
            msg.show();
*/
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
