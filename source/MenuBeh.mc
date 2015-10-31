//!
//!    This file is part of StartTimer.
//!
//!    Copyright 2015 Christof Bodner OE8BCK
//!
//!    StartTimer is free software: you can redistribute it and/or modify
//!    it under the terms of the GNU General Public License as published by
//!    the Free Software Foundation, either version 3 of the License, or
//!    (at your option) any later version.
//!
//!    StartTimer is distributed in the hope that it will be useful,
//!    but WITHOUT ANY WARRANTY; without even the implied warranty of
//!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//!    GNU General Public License for more details.
//!
//!    You should have received a copy of the GNU General Public License
//!    along with StartTimer.  If not, see <http://www.gnu.org/licenses/>.

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
