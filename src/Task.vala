namespace Note {
	/*
      That's a revocation ticket, that helps avoid the following case:
      if we need to amend the notification DateTime, the programe will
      add a new Timeout.add(lambda-to-libnotify()) callback, for which
      GLib provides no way of revoking (there is no Timeout.remove(...)
      method. In a way, this only  provides an indirection that will have
      to be valid (hence, a ticket) that will be checked in time.
	*/
	public class Ticket {
        bool validity;
		public Ticket() {
			validity = true;
		}
		// TODO: There must be a more succinct way to do it
		public bool is_valid() {
			return validity;
		}
		public void invalidate() {
			validity = false;
		}
	}

    public class Task {
        public bool repeating;
        public bool important;
        public bool done;

        public string title {get; set; default = Utils.INIT_TEXT;}
        private DateTime _date;
		public DateTime date {
			get {return _date;}
			set {add_date(value);}
		}
        public string more {get; set;}
        public int percent {get; set;}
		private Gee.ArrayList<Ticket> notifications;

        public Task(string title){
            this.title = title;
			this.notifications = new Gee.ArrayList<Ticket>();
            this.percent = 0;
        }

		public Task.with_date(string title, DateTime date) {
			// TODO: Can I replace this with
			// <store ref> = new Task(title)?
			this.title = title;
			this.notifications = new Gee.ArrayList<Ticket>();
            this.percent = 0;
			add_date(date);
		}

        /**
         * Create task from quick entry text
         * At this point we don't support task details. 
         * We support the following combinators:
         **/
        /**
         * <time>:
         * meet at 5pm
         * meet at 5
         * meet at 5:00
         * meet at 5:00pm
         * meet at 17:00
         **/
        private DateTime is_time(string dt) {
            // Not implemented yet
            return new DateTime.local(0,0,0,0,0,0);
        }
        /**
         * <offset from <now>>:
         * meet in 5 minutes
         * meet in 5 mins
         * meet in 5'
         * meet in 5 hours 15 minutes
         * meet in 5 hours, 5'
         * meet in 2 days.
         **/
        private DateTime is_offset(string dt) {
            // Not implemented yet
            return new DateTime.local(0,0,0,0,0,0);
        }

        /**
         * <place>:
         * meet at the cinema at <time>
         * meet at <time> at the cinema
         * meet in Levine Hall at <time>
         * meet at <time> in Levinee Hall
         * meet at the cinema in 5 mins
         * meet in 5 mins at the cinema
         * meet in Levine Hall in 5 mins
         * meet in 5mins  in Levinee Hall
         **/
        private string is_place(string s) {
            return "";
        }

        /**
         * Note: It will always create a new task even if not parsed correctly.
         * The reason for this is we can't have a critical error; worst-case
         * scenario, if it can't be parsed,  we put everything on the title.
         **/
		public Task.from_parser(string blurb) {
/*
            var low_blurb = blurb.down();
            int at_pos = low_blurb.last_index_of(" at ");
            int in_pos = low_blurb.last_index_of(" in ");
            if (at_pos == in_pos)
                this.title = blurb;
            else if (at_pos > in_pos) {
                DateTime dt = parse_at(low_blurb.substring(at_pos+4));
                this.title = blurb.substring(0,at_pos);
                this.notifications = new Gee.ArrayList<Ticket>();
                this.percent = 0;
                if (dt != null)
                    add_date(dt);
            } else {
                if (at_pos > 0) { // pizza
                }
			this.title = title;
			this.notifications = new Gee.ArrayList<Ticket>();
            this.percent = 0;
			add_date(date);
*/
// For now, worst case, push everything into title:
            title = blurb;
		}

		private void add_date(DateTime date) {
			int size = notifications.size;
			debug("ticket list has size %d", size );
			if (size > 0) {
				debug("Nullifying ticket at %d", (size -1));
				notifications[size-1].invalidate();
			}
			_date = date;
			Ticket ticket = new Ticket();
			notifications.add(ticket);
			notify(ticket);
		}

		/* Need to pass also a ticket structure, in case the
		   notification needs to be voided before it fires up, i.e.
		   if there is an update. With these indirection tickets, I
		   preserve the ability to revocate, if needed. */
		public void notify(Ticket ticket){
            Timeout.add((this.in_seconds () * 1000) , () => {
                    return notify_aux(ticket);
                });
		}

        private bool notify_aux(Ticket ticket) {
			if (!ticket.is_valid())
				return false; // signify non-repetitive event
            debug("attempting notification");
            if (!Notify.init("Note"))
                critical("Failed to initialize libnotify.");
            Notify.Notification notification;
            notification = new Notify.Notification(
                "Reminder!",
                this.title,
                Utils.ICON);
            try {
                notification.show ();
            } catch (GLib.Error error) {
                warning ("Failed to show notification: %s", error.message);
            }
            return false;  // signify non-repetitive event
        }


        // Need to check if >=0
        private int in_seconds() {
            var now = new DateTime.now_local ();
            int difference =  (int) (this.date.difference(now)/1000000);
            debug(difference.to_string());
            //Need to check if below zero -- then passed, cross out
            debug("Times: [now %s], [target %s], [dif: %s secs] ",
                  now.to_string(),
                  this.date.to_string(),
                  difference.to_string());
            return difference;
        }

        /**
         * Note: clr REQUIRES #
         * i.e., it is #999 not 999!
         * TODO: Add checking
         **/
        public string format_title(string clr) {
            var s = status();
            var t = title.char_count()>25? (title.substring(0,25)+"..") : title;
            return ("<span underline='none' font_weight='bold' color='" + clr +
                    "' size='large' strikethrough='" +(done? "true" : "false")+
                    "'>" + t + "</span> <span font_weight=" +
                    "'light'>(" + s.to_string() +"%)</span>");
        }

        public string format_date() {
            return ("<span color='#999aaa' strikethrough='" + 
                    (done? "true" : "false") + "'> due on 04/14/2014 </span>");
        }

        public string format_notes() {
            var t = more.char_count()>500? (more.substring(0,500)+".."):more;
            return ("<span strikethrough='" + (done? "true" : "false") + "'>" +
                    t.replace("\n *","\n •").replace("\n*","\n •") + "</span>");
            //TODO: Return a maximum string size + flatten "\n"
        }

        /**
         * Calculates completion percentage based on the number of
         * stars at the start of a line ending with some flavor of
         * "Done". For instance, the following task is 66% complete:
         *
         * 'Hold Office Hours:\n'
         * '* Reserve room. done'
         * '* notify course mailing list -- DONE'
         * '* Prepare slides'
         *
         * (Not implemented --  need to strikethrough individual lines)
         **/
        private int status(){
            if (done)
                return 100;
            else
                return 0; // Not implemented yet!
        }

        /**
         * It imposes sort of a partial order, since it will only show the
         * most important icon of these:
         * repeating > important > done > default
         **/
        public string get_icon () {
            if (repeating)
                return "emblem-synchronizing-symbolic";
            if (important)
                return "emblem-important-symbolic";
            if (done)
                return "emblem-default-symbolic";
            return "emblem-documents-symbolic";
        }
    }
}
