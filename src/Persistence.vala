namespace Enote {
    public class Persistence {
        SQLHeavy.Database hdb;

        // TODO: Use SQLite Transactions
        // TODO change this void down here to grab errors
        public Persistence(string db) {
            try {
                hdb = new SQLHeavy.Database (db); //with default RWC
            } catch (SQLHeavy.Error e) {
                warning ("Could not connect to db, %s", e.message);
            }
        }

        public void create_db() {
            try {
                hdb.execute ("CREATE TABLE task (title TEXT,"
                             + " repeating INTEGER,"
                             + " important INTEGER,"
                             + " done INTEGER,"
                             + " date INTEGER,"
                             + " more TEXT);");
//                             + " id INTEGER PRIMARY KEY AUTOINCREMENT);");
            } catch (SQLHeavy.Error e) {
                warning ("Could not create db, %s", e.message);
            }
        }

        public Array<Task> load_db() {
            Array<Task> at = new Array<Task>();
            try {
                SQLHeavy.QueryResult qr;
                SQLHeavy.Query q = hdb.prepare ("SELECT * FROM task");
                for (qr = q.execute (); !qr.finished; qr.next ()) {
                    Task t = new Task(qr.fetch_string(0));
                    t.repeating = (qr.fetch_int(1) != 0);
                    t.important = (qr.fetch_int(2) != 0);
                    t.done = (qr.fetch_int(3) != 0); //SQLite: 0 == false
                    t.date = new DateTime.from_unix_local (qr.fetch_int(4));
                    t.more = qr.fetch_string(5);
                    at.append_val(t);
                }
            } catch (SQLHeavy.Error e) {
                warning ("Could not load db, %s", e.message);
            }
            return at;
        }

        public void save_db(Array<Task> at) {
            debug ("save db: Not Implemented");
        }

        public void insert(Task t) {
            var s = ("INSERT INTO 'task' " +
                     "(title, repeating, important, done, date, more) VALUES " +
                     "(:title, :repeating, :important, :done, :date, :more);");
            try {
                var q = new SQLHeavy.Query (hdb, s);
                q.set_string (":title", t.title);
                q.set_int (":repeating", (t.repeating?1:0));
                q.set_int (":important", (t.important?1:0));
                q.set_int (":done", (t.done?1:0));
                q.set_int (":date", (int) t.date.to_unix());
                q.set_string (":more", t.more);
                q.execute();
                debug("Inserted id: " + hdb.last_insert_id.to_string());
            } catch (SQLHeavy.Error e) {
                warning ("Could not create db, %s", e.message);
            }
        }

        public void update (Task t) {
            debug("update: Not Implemented");
        }
    }
}