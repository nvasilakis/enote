namespace Enote{
  public class Window : Gtk.Window {
    Gtk.Box container;
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
      container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      toolbar = new Gtk.Toolbar();
      var img = new Gtk.Image.from_icon_name ("mail-message-new",
          Gtk.IconSize.SMALL_TOOLBAR);
      var btn_create = new Gtk.ToolButton (img, "Create");
      btn_create.clicked.connect (create_new_task_window);
      toolbar.insert (btn_create,0);
      var btn_gear = am;
      btn_gear.set_expand(true);

      btn_gear.set_halign(Gtk.Align.END);
      var separator = new Gtk.SeparatorToolItem ();
      toolbar.add (separator);
      toolbar.add(btn_gear);
      toolbar.get_style_context ().add_class ("primary-toolbar");
      container.pack_start(toolbar, false, false);
      add(container);
    }

    public void create_new_task_window() {
		lw = new NewTaskView(null,this);
      lw.show_all();
    }

    public void swap_to_welcome() {
      Utils.view = Facade.WELCOME;
      Enote.Welcome welcome = new Enote.Welcome(this);
      clear_container();
      container.pack_start(welcome);
      welcome.show_all();
    }

    public void swap_to_main(){
      view = new Enote.MainView (this);
      tlist = new TaskList (this);
//      Utils.RunTests(this);
      if (Utils.view == Facade.WELCOME)
          Utils.view = Facade.MAIN;
      else {
          var persistence = new Persistence(Utils.db);
          view.attach_all(persistence.load_db());
      }
      clear_container();
      container.pack_end(view);
      view.quick.grab_focus();
      view.show_all();
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
