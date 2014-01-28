/**
 * Summary: Custom list for the in-memory tasks
 *
 * Eventually will be able to order and pick based on attributes,
 * without hitting the database.
 *
 * Copyright (c) 2013-2014 Nikos Vasilakis. All rights reserved.
 *
 * Use of this source code is governed by a GPL v3 license that can be
 * found in LICENSE file or at http://nikos.vasilak.is/LICENSE
 */
namespace Enote {

  /**
   * Basic TaskList backend prividing
   * add/remove functionality, load from file, synchronizing
   **/
  public class TaskList {
    Enote.Window window;
    TaskListView tlview;
    public static GLib.List<Task> tlist;

    public TaskList(Enote.Window window) {
      tlist = new GLib.List<Task>();
      this.window = window;
      this.tlview = window.view.tlview;
    }

    public TaskList.from_file() {
      tlist = new GLib.List<Task>();
    }

    public void add(Task t){
      tlist.append(t);
      tlview.append(t);
    }
  }
}
