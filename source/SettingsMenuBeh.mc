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

class SettingsMenuBehDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {

    	var ret=0;
    	//Sys.println("onMenuItem "+item);
        if ( item == :menu_starttime )
        {
			//Sys.println("Set Counter Start");
		    Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"Number Picker"}),
                               :pattern=>[new MyNumberFactory()],
                               :defaults=>[counter_start%60]}),
                new MyPickerDelegate(),
                Ui.SLIDE_UP );
            //Sys.println(counter_start);
        }
		else if ( item == :menu_starttime )
        {
        	//Sys.println("MENU_START_STOP");
	        startbeh=MENU_START_STOP;
        }
        else if ( item == :menu_beep )
        {
        	//Sys.println("Beep");
			var confirm = new Ui.Confirmation();
			confirm.initialize("Silent Mode?");
			ret=Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP);
			if (ret==CONFIRM_YES)
			{ silent_mode=true; }
			else
			{ silent_mode=false; }
        }
        else if ( item == :menu_vib )
        {
        	//Sys.println("Vibrate");
			var confirm = new Ui.Confirmation();
			confirm.initialize("Use Vibration?");
			ret=Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP);
			if (ret==CONFIRM_YES)
			{ vibration=true; }
			else
			{ vibration=false; }
        }
    }
}
