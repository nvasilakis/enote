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
        public string title {get; set; default = Utils.INIT_TEXT;}
        private DateTime _date;
		public DateTime date {
			get {return _date;}
			set {add_date(value);}
		}
        public string more {get; set;}
		private Gee.ArrayList<Ticket> notifications;

        public Task(string title){
            this.title = title;
			this.notifications = new Gee.ArrayList<Ticket>();
        }

		public Task.with_date(string title, DateTime date) {
			// TODO: Can I replace this with
			// <store ref> = new Task(title)?
			this.title = title;
			this.notifications = new Gee.ArrayList<Ticket>();
			add_date(date);
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
    }
}
