namespace Note {
    public class Task {
        public string what {get; set; default = Utils.INIT_TEXT;}
        public DateTime when  {get; set;}
//            public get {return when;}
//            public set {when = value; time_is_valid = true;}

        public string more  {get; set;}
//        bool time_is_valid {get; set;}

        public Task(string title){
            this.what = title;
//            time_is_valid = false;
        }

        // Need to check if >=0
        public int in_seconds() {
            var now = new DateTime.now_local ();
            int difference =  (int) (this.when.difference(now)/1000000);
            debug(difference.to_string());
            //Need to check if below zero -- then passed, cross out
            debug("Times: [now %s], [target %s], [dif: %s secs] ",
                  now.to_string(),
                  this.when.to_string(),
                  difference.to_string());
            return difference;
        }
    }
}
