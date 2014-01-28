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
