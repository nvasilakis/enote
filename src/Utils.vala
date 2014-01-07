namespace Note {
	// should this be a static class?
	public class Utils {

		public static bool DEBUG = false;
//        public static bool START_HIDDEN = false;

		public static const OptionEntry[] args = {
            { "debug",'d', 0, OptionArg.NONE, out Utils.DEBUG,
			  "Enable debug logging", null },
            { null } //list terminator
        };
	}
}