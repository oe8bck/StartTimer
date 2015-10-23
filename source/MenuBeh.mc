using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class MyMenuBehDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
		if ( item == :menu_start_stop )
        {
        	//Sys.println("MENU_START_STOP");
	        startbeh=MENU_START_STOP;
        }
        else if ( item == :menu_start_race )
        {
        	//Sys.println("MENU_START_RACE");
	        startbeh=MENU_START_RACE;
        }
        else if ( item == :menu_start_restart )
        {
        	//Sys.println("MENU_START_RESTART");
	        startbeh=MENU_START_RESTART;
        }
    }
}
