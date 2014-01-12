namespace Note {
/**
 * A RecordView widget for showing one Task/Note to the user
 */
public class RecordView : Gtk.EventBox {
    // keep a handy reference
    private Gtk.Window window;
    private Task task;
    // top-level box
    private Gtk.Box record_box;
    // left and right overlays
    private Gtk.Overlay left; // has priority, mini menu
    private Gtk.Overlay right; // has task, date, notes

    // A. Left side:
    // priority  (TODO: Will have multiple colors and icons
    // - Green, Blue, Violet, Yellow, Red
    // - square, recurring, important, depends, love-icon, done
    private Gtk.Alignment priority_alignment;
    private Gtk.Box priority_box;
    private Gtk.Image priority_icon;
    // Mini-menu on-mouse-over
    private Gtk.Box menu;
    private Gtk.Alignment menu_alignment;
    private Gtk.Button mark_as_done;
    private Gtk.Image done_icon;
    private Gtk.Button mark_as_delete;
    private Gtk.Image delete_icon;

    // B. Right side:
    private Gtk.Box span_box; // main container
    private Gtk.Alignment task_alignment;
    // B1. upper
    private Gtk.Box upper_layer;
    private Gtk.Label title;
    private Gtk.EventBox task_event;
    private Gtk.Label due_date;
    // B2. lower
    private Gtk.Label notes;

    public RecordView (Gtk.Window window, Task task) {
        this.window = window;
        this.task = task;
        // Record
        record_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        add (this.record_box);// false, false, 0);

        left = new Gtk.Overlay();
        record_box.pack_start(left, false, true, 0);

        /* Left Pane -- Priority + mini menu */
        priority_alignment = new Gtk.Alignment (0,0,0,1);
        priority_alignment.top_padding = 12;
        priority_alignment.right_padding = 4;
        priority_alignment.bottom_padding = 0;
        priority_alignment.left_padding = 12;
        //record_box.pack_start (priority_alignment, false, true, 0);
        left.add(priority_alignment);
        // priority box
        priority_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        priority_alignment.add (this.priority_box);
        // priority_icon
        priority_icon = new Gtk.Image ();
        priority_icon.set_from_icon_name 
                ("emblem-synchronizing-symbolic", Gtk.IconSize.MENU);
        priority_icon.set_halign (Gtk.Align.START);
        priority_icon.set_valign (Gtk.Align.START);
        priority_box.pack_start (this.priority_icon, false, false, 0);


        /* Right Pane on Overlay -- Task, Notes and Due Date */
        // Overlay
        right = new Gtk.Overlay ();
        record_box.pack_start (right, true, true, 0);

        // task alignment
        task_alignment = new Gtk.Alignment (0,0,0,0);
        task_alignment.top_padding = 10;
        task_alignment.right_padding = 12;
        task_alignment.bottom_padding = 12;
        task_alignment.left_padding = 4;
        task_alignment.xscale = 0;
        task_alignment.set_valign (Gtk.Align.START);
        right.add (task_alignment);

        //span box
        span_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        task_alignment.add (span_box); 
        // upper layer
        upper_layer = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        span_box.pack_start (upper_layer, false, false, 0);

        // task
        title = new Gtk.Label ("");
        title.set_halign (Gtk.Align.START);
        title.set_valign (Gtk.Align.START);
        title.set_selectable (false);
        title.set_markup (task.format_title("#000"));

        // plug-in task events
        task_event = new Gtk.EventBox ();
        task_event.add (title); //TODO, launch lightbox
        task_event.enter_notify_event.connect ((event) => {
                on_mouse_enter (this, event);
                return false;
            });
        task_event.leave_notify_event.connect ((event) => {
                on_mouse_leave (this, event);
                return false;
            });
        upper_layer.pack_start (this.task_event, true, true, 0);

        // due date -- later on, might be good to make it editable
        due_date = new Gtk.Label ("");
        due_date.set_halign (Gtk.Align.END);
        due_date.set_valign (Gtk.Align.END);
        due_date.set_markup (task.format_date());
        upper_layer.pack_end (due_date, true, true, 0);

        /* lower layer -- notes */
        notes = new Gtk.Label (task.format_notes());
        notes.set_use_markup (true);
        notes.set_selectable (false);
        notes.set_line_wrap (true);
        notes.wrap_mode = Pango.WrapMode.WORD_CHAR;
        notes.set_halign (Gtk.Align.START);
        notes.set_valign (Gtk.Align.START);
        notes.xalign = 0;
        span_box.pack_end (this.notes, true, false, 0); 

        /* Mini-menu */
        menu_alignment = new Gtk.Alignment (0, 0, 0, 1);
        menu_alignment.top_padding = 5;
        menu_alignment.set_halign (Gtk.Align.END);
        menu_alignment.set_valign (Gtk.Align.START);
        left.add_overlay (menu_alignment);
        // Actual menu container
        menu = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        menu.set_halign (Gtk.Align.START);
        menu.set_valign (Gtk.Align.START);
        menu_alignment.add (menu);

        set_events(Gdk.EventMask.BUTTON_RELEASE_MASK);
        set_events(Gdk.EventMask.ENTER_NOTIFY_MASK);
        set_events(Gdk.EventMask.LEAVE_NOTIFY_MASK);

        // mark as done
        mark_as_done = new Gtk.Button ();
        mark_as_done.set_halign (Gtk.Align.START);
        mark_as_done.set_relief (Gtk.ReliefStyle.NONE);
        done_icon = new Gtk.Image.from_icon_name
        ("object-select-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        mark_as_done.child = this.done_icon;
        mark_as_done.set_tooltip_text ("Mark as done");
        menu.pack_start (mark_as_done, false, true, 0);

        // delete task
        mark_as_delete = new Gtk.Button ();
        mark_as_delete.set_halign (Gtk.Align.START);
        mark_as_delete.set_relief (Gtk.ReliefStyle.NONE);
        delete_icon = new Gtk.Image.from_icon_name
        ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        mark_as_delete.child = this.delete_icon;
        mark_as_delete.set_tooltip_text ("Delete");
        menu.pack_end (mark_as_delete, false, true, 0);

        // Connect mouse-over events
        this.leave_notify_event.connect ((event) => {
                Gtk.Allocation allocation;
                this.get_allocation (out allocation);

                if (event.x < 0 || event.x >= allocation.width ||
                    event.y < 0 || event.y >= allocation.height) {
                    this.menu.hide();
                }
                return true;
            });

        this.enter_notify_event.connect ((event) => {
                this.menu.show();
                return true;
            });
    }

    // Show all but mini-menu
    public void show_everything(){
        this.window.add(this);
        this.window.show_all();
        this.menu.hide ();
    }

    /* Change color to blue for Task Title  on-mouse-over
       -- TODO: Make it system-dependent*/
    public virtual void on_mouse_enter (Gtk.Widget widget,
                                        Gdk.EventCrossing event) {
        this.title.set_markup (task.format_title("#0077FF"));
    }

    public virtual void on_mouse_leave (Gtk.Widget widget,
                                        Gdk.EventCrossing event) {
        this.title.set_markup (task.format_title("#000"));
    }
}
}