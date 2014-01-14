using Gtk;

namespace Enote{
  public class Window : Gtk.Window {
    Box container;
    Gtk.Toolbar toolbar;
    public Enote.MainView view {get; set;}
    public Enote.TaskList tlist {get; set;}
    Granite.Widgets.LightWindow lw;

    public Window(Granite.Application application) {
      title = "Enoté";
      set_default_size(400,500);
      window_position = Gtk.WindowPosition.CENTER;
      destroy.connect(Gtk.main_quit);
      icon_name = Utils.ICON;
    }

    public void add_menu(Granite.Widgets.AppMenu am){
      // build header
      container = new Box(Gtk.Orientation.VERTICAL, 0);
      toolbar = new Toolbar();
      var img = new Image.from_icon_name ("mail-message-new",
          IconSize.SMALL_TOOLBAR);
      var btn_create = new ToolButton (img, "Create");
      btn_create.clicked.connect (create_new_task_window);
      toolbar.insert (btn_create,0);
      var btn_gear = am;
      btn_gear.set_expand(true);

      btn_gear.set_halign(Align.END);
      var separator = new SeparatorToolItem ();
      toolbar.add (separator);
      toolbar.add(btn_gear);
      toolbar.get_style_context ().add_class ("primary-toolbar");
      container.pack_start(toolbar, false, false);
      add(container);
    }

    public void create_new_task_window() {
      lw = new NewTask(null);
      lw.show_all();
    }

    public void swap_to_welcome() {
      Enote.Welcome welcome = new Enote.Welcome(this);
      clear_container();
      container.pack_start(welcome);
      welcome.show_all();
    }

    public void swap_to_main(){
      view = new Enote.MainView (this);
      tlist = new TaskList (this);
      Utils.RunTests(this);
      clear_container();
      container.pack_end(view);
      view.quick.grab_focus();
      view.show_all();
      /*
         if (is_empty) {
         create_new_task_window();
         this.is_empty = false;
         }
       */
    }

    public void clear_container(){
      foreach(var child in container.get_children()){
        if (child == toolbar)
          continue;
        container.remove(child);
      }
    }
  }
}
