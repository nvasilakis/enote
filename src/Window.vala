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
    private Gtk.CheckMenuItem quit_item;
    private Gtk.ImageMenuItem preferences_item;
    private Granite.Application app;
    // Coordinates
    private int opening_x;
    private int opening_y;
    private int window_width;
    private int window_height;

    public Window(Granite.Application application) {
      this.app = application;
      this.delete_event.connect (on_delete);
      title = "Enoté";
      set_default_size(400,500);
      restore_window();
      destroy.connect(on_close);
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
      settings_menu.append (preferences_item);
      settings_menu.append (new Gtk.SeparatorMenuItem ()); 
      settings_menu.append (help_item);

      container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
      toolbar = new Gtk.Toolbar();
      var img = new Gtk.Image.from_icon_name ("mail-message-new",
                                              Gtk.IconSize.SMALL_TOOLBAR);
      var btn_create = new Gtk.ToolButton (img, "Create");
      btn_create.clicked.connect (create_new_task_window);
      toolbar.insert (btn_create,0);
      // Attach menu gear
      var btn_gear = this.app.create_appmenu(settings_menu);
      quit_item = new Gtk.CheckMenuItem.with_label ("Quit");
      settings_menu.append (new Gtk.SeparatorMenuItem ()); 
      settings_menu.append (quit_item);
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
          var persistence = new Persistence(Utils.preferences.db_dir);
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

    public void clear_container (){
      foreach(var child in container.get_children()){
        if (child == toolbar)
          continue;
        container.remove(child);
      }
    }

    private void on_sync () {
      debug("sync");
    }

    private void on_import () {
      debug("import");
    }

    private void on_help () {
      debug("help");
    }

    private void on_preferences () {
      debug("preferences");
      PreferencesWindow preferences = new PreferencesWindow(this);
      preferences.show_all();
      preferences.run();
      preferences.hide();
    }

    private void on_close () {
    }

    private bool on_delete () {
      debug("Saving Window");
      save_window ();
      if (!Utils.preferences.hide_on_close)
        Gtk.main_quit();
      else 
        base.hide_on_delete ();
      return true;
    }

    public void save_window () {
      this.get_position (out opening_x, out opening_y);
      this.get_size (out window_width, out window_height);
      debug(opening_x.to_string());
      debug(opening_y.to_string());
      debug(window_width.to_string());
      debug(window_height.to_string());
      Utils.saved_state.opening_x = this.opening_x;
      Utils.saved_state.opening_y = this.opening_y;
      Utils.saved_state.window_width = this.window_width;
      Utils.saved_state.window_height = this.window_height;
    }

    private void restore_window () {
      this.opening_x = Utils.saved_state.opening_x;
      this.opening_y = Utils.saved_state.opening_y;
      this.window_width = Utils.saved_state.window_width;
      this.window_height = Utils.saved_state.window_height;
      if (this.opening_x > 0 && this.opening_y > 0 && this.window_width > 0 && this.window_height > 0) {
        this.move (this.opening_x, this.opening_y);
        this.set_default_size (this.window_width, this.window_height);
      } else {
        window_position = Gtk.WindowPosition.CENTER;
      }
    }

  }
}
