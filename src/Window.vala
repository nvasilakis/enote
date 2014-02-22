namespace Enote{
  public class Window : Gtk.Window {
    Gtk.Box container;
    Gtk.Toolbar toolbar;
    public Enote.MainView view {get; set;}
    public Enote.TaskList tlist {get; set;}
    Granite.Widgets.LightWindow lw;
    // Menu items 
    private Gtk.Menu settings_menu;
    private Gtk.MenuItem sync_item;
    private Gtk.MenuItem import_item;
    private Gtk.CheckMenuItem help_item;
    private Gtk.ImageMenuItem preferences_item;
    private Granite.Application application;


    public Window(Granite.Application application) {
      this.application = application;
      title = "Enoté";
      set_default_size(400,500);
      window_position = Gtk.WindowPosition.CENTER;
      destroy.connect(Gtk.main_quit);
      icon_name = Utils.ICON;
    }

    public void add_menu(){
      // First, create settings
      settings_menu = new Gtk.Menu ();
      sync_item = new Gtk.MenuItem.with_label ("Sync Now");
      sync_item.activate.connect(on_sync);
      import_item = new Gtk.MenuItem.with_label ("Export…");
      import_item.activate.connect(on_import);
      help_item = new Gtk.CheckMenuItem.with_label ("Help");
      help_item.activate.connect(on_help);
      preferences_item = new Gtk.ImageMenuItem.from_stock (Gtk.Stock.PREFERENCES, null);
      preferences_item.set_label ("Preferences");
      preferences_item.activate.connect(on_preferences);

      settings_menu.append (sync_item);
      settings_menu.append (import_item);
      settings_menu.append (new Gtk.SeparatorMenuItem ()); 
      settings_menu.append (help_item);
      settings_menu.append (preferences_item);

      container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      toolbar = new Gtk.Toolbar();
      var img = new Gtk.Image.from_icon_name ("mail-message-new",
                                              Gtk.IconSize.SMALL_TOOLBAR);
      var btn_create = new Gtk.ToolButton (img, "Create");
      btn_create.clicked.connect (create_new_task_window);
      toolbar.insert (btn_create,0);
      // Attach menu gear
      var btn_gear = this.application.create_appmenu(settings_menu);
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
		lw = new NewTaskView(null,this,null);
      lw.show_all();
    }

    public void swap_to_welcome() {
      Utils.view = Facade.MAIN;
      Enote.Welcome welcome = new Enote.Welcome(this);
      debug("Should be showing welcome..");
      clear_container();
      container.pack_start(welcome);
      welcome.show_all();
    }

    public void swap_to_main(){
      view = new Enote.MainView (this);
      tlist = new TaskList (this); // TODO: Needed?
//      Utils.RunTests(this);
      if (Utils.view == Facade.WELCOME)
          Utils.view = Facade.MAIN;
      else {
          var persistence = new Persistence(Utils.db);
          var tasks = persistence.load_db();
          debug("tasks length: " + tasks.length.to_string());
          if (tasks.length < 1) {
            swap_to_welcome();
          } else {
            view.attach_all(tasks);
            clear_container();
            container.pack_end(view);
            view.quick.grab_focus();
            view.show_all();
          }
      }
    }

    public void clear_container(){
      foreach(var child in container.get_children()){
        if (child == toolbar)
          continue;
        container.remove(child);
      }
    }

    private void on_sync() {
      debug("sync");
    }

    private void on_import() {
      debug("import");
    }

    private void on_help() {
      debug("help");
    }

    private void on_preferences() {
      debug("preferences");
      PreferencesWindow preferences = new PreferencesWindow(this);
      preferences.show_all();
      preferences.run();
      preferences.hide();
    }
  }
}
