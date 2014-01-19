namespace Enote {
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
        private Array<Ticket> notifications;

        public Task(string title){
            this.title = title;
            this.notifications = new Array<Ticket>();
            this.percent = 0;
        }

        public Task.with_date(string title, DateTime date) {
            // TODO: Can I replace this with
            // <store ref> = new Task(title)?
            this.title = title;
            this.notifications = new Array<Ticket>();
            this.percent = 0;
            add_date(date);
        }

/////////////////// Quick Task Parser /////////////////////////////////
// TODO: Add noon/midnight keywords

        /**
         * Create task from quick entry text
         * At this point we don't support task details.
         * We support the following combinators:
         **/
        /**
         * <time>:
         * meet at 5
         * meet at 17
         * meet at 5:00
         * meet at 5pm
         * meet at 5:00pm
         * meet at 17:00
         * meet at 17:00 am
         *
         * @param dt string after the at
         * @return the DateTime or new local(0,0,0,0,0,0) if error
         **/
        private Epoch at_time(string date) {
            string dt = date.strip();
            int sz = dt.char_count();
            Clock c = Clock.NONE;
            if (sz == 1 || sz == 2) { // at 5 / at 17
                if (Utils.are_digits(dt))
                    return new Epoch.next(int.parse(dt), 0, Clock.NONE);
                else
                    return new Epoch.invalid();
            } else if (sz > 2 && sz < 9) { // rest
                if (dt.has_suffix("pm"))
                    c = Clock.PM;
                else if (dt.has_suffix("am"))
                    c = Clock.AM;

                dt = dt.replace("pm","").replace("am","").strip();
                if (dt.contains(":")) { // 5:00 / 5:00 (pm) / 17:00
                    string[]  d =  dt.split(":");
                    debug("====>" + dt);
//                    THREE at 11:50pm
                    if ((d.length < 3) && (Utils.are_digits(d[0]))
                                       && (Utils.are_digits(d[1])))  {
                        return new Epoch.next(int.parse(d[0]),
                                              int.parse(d[1]) ,c);
                    }
                } else { // 5pm
                    if (Utils.are_digits(dt)) {
                        return new Epoch.next(int.parse(dt), 0, c);
                    }
                }
            }
            return new Epoch.invalid();
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
        private Epoch is_offset(string date) {
            string dt = date.strip();
            if (Utils.are_digits(dt)) { // in 5, 50, 500
                return new Epoch.add_minutes(int.parse(dt));
            } else {
                int v;
                if ((v = Utils.or_int(6, Utils.has_suffix(dt, "minutes"),
                                      Utils.has_suffix(dt, "mins"),
                                      Utils.has_suffix(dt, "m"),
                                      Utils.has_suffix(dt, "min"),
                                      Utils.has_suffix(dt, "'"))) > 0) {
                    return new Epoch.add_minutes(v);
                } else if ((v = Utils.or_int(3, Utils.has_suffix(dt, "hours"),
                                             Utils.has_suffix(dt, "hr"),
                                             Utils.has_suffix(dt, "h"))) > 0) {
                    return new Epoch.add_hours(v);
                } else if ((v = Utils.or_int(2, Utils.has_suffix(dt, "days"),
                                             Utils.has_suffix(dt, "d"))) > 0) {
                    return new Epoch.add_days(v);
                }
            }
            return new Epoch.invalid();
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
//        private string is_place(string s) {
//            return "";
//        }

        /**
         * Note: It will always create a new task even if not parsed correctly.
         * The reason for this is we can't have a critical error; worst-case
         * scenario, if it can't be parsed,  we put everything on the title.
         **/
        public Task.from_parser(string blurb) {
            var low_blurb = blurb.down();
            int at_pos = low_blurb.last_index_of(" at ");
            int in_pos = low_blurb.last_index_of(" in ");
            debug("at_pos: "+at_pos.to_string()+"\tin_pos:"+in_pos.to_string());
            if (at_pos == in_pos)
                this.title = blurb;
            else if (at_pos > in_pos) {
                this.notifications = new Array<Ticket>();
                this.percent = 0;
                Epoch  dt = at_time(low_blurb.substring(at_pos+4));
                if (dt.is_valid()) {
                    this.title = blurb.substring(0,at_pos);
                    debug(blurb + " | " + dt.get_date().to_string());
                    add_date(dt.get_date());
                } else {
                    this.title = blurb;
                }
            } else if (at_pos < in_pos) {
                this.notifications = new Array<Ticket>();
                this.percent = 0;
                Epoch dt = is_offset(low_blurb.substring(in_pos+4));
                if (dt.is_valid()) {
                    this.title = blurb.substring(0,in_pos);
                    debug(blurb + " | " + dt.get_date().to_string());
                    add_date(dt.get_date());
                } else {
                    this.title = blurb;
                }
            }
        }

        private void add_date(DateTime date) {
            // User does not have a specific due date
			debug("add date" + date.to_string());
			if (date.get_year() > 1970) {
				int size = (int) notifications.length;
				debug("ticket list has size %d", size );
				if (size > 0) {
					debug("Nullifying ticket at %d", (size -1));
					notifications.index(size-1).invalidate();
				}
//				_date = date; // this is needed before
				Ticket ticket = new Ticket();
				notifications.append_val(ticket);
				Timeout.add((this.in_seconds (date) * 1000) , () => {
						/* Need to pass also a ticket structure, in case the
						notification needs to be voided before it fires up, i.e.
						there is an update. With these indirection tickets, I
						preserve the ability to revocate, if needed. */
						return notify_aux(ticket);
					});
			}
			_date = date;
        }

        private bool notify_aux(Ticket ticket) {
            if (!ticket.is_valid())
                return false; // signify non-repetitive event
            debug("attempting notification");
            if (!Notify.init("Enote"))
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
        private int in_seconds(DateTime date) {
            var now = new DateTime.now_local ();
            int difference =  (int) (date.difference(now)/1000000);
            debug("difference: " + difference.to_string());
            //Need to check if below zero -- then passed, cross out
            debug("Times: [now %s], [target %s], [dif: %s secs] ",
                  now.to_string(),
                  date.to_string(),
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
			var s = "";
			if (_date.get_year() > 1970) {
				s = ("<span color='#999aaa' strikethrough='" +
					 (done? "true" : "false") + "'> due ");
				s += (not_same_day()? ("on " + _date.format("%B %e, %Y")) :
					("at " + _date.format("%H:%M")));
				s += " </span>";
			}
			return s;
        }

	private bool not_same_day() {
		return (_date.get_day_of_year() !=
				new DateTime.now_local().get_day_of_year());
	}

        public string format_notes() {
            if (more == null)
                return "";
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
