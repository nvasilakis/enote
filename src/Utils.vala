namespace Note {

	public class Utils {
		public const string INIT_TEXT = "Breakfast at Milliway's at 7am";
        public const string TOOLTIP_TEXT = "Add Task";
		public static bool DEBUG = false;

		public static const OptionEntry[] args = {
            { "debug",'d', 0, OptionArg.NONE, out Utils.DEBUG,
			  "Enable debug logging", null },
            { null } //list terminator
        };
	}
}