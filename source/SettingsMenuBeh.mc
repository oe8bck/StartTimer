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
using Toybox.Application as App;

class SettingsMenuBehDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {

    	var ret=0;
    	var app=App.getApp();
    	//Sys.println("onMenuItem "+item);
        if ( item == :menu_starttime )
        {
			//Sys.println("Set Counter Start");
		    Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"Number Picker"}),
                               :pattern=>[new MyNumberFactory()],
                               :defaults=>[app.counter_start%60]}),
                new MyPickerDelegate(),
                Ui.SLIDE_UP );
            //Sys.println(counter_start);
        }
		else if ( item == :menu_starttime )
        {
        	//Sys.println("MENU_START_STOP");
	        app.startbeh=MENU_START_STOP;
        }
        else if ( item == :menu_beep )
        {
        	//Sys.println("Beep");
			var confirm = new Ui.Confirmation();
			confirm.initialize("Silent Mode?");
			Ui.pushView( confirm ,new ConfirmationDelegateSilentMode(),Ui.SLIDE_UP);
        }
        else if ( item == :menu_vib )
        {
        	//Sys.println("Vibrate");
			var confirm = new Ui.Confirmation();
			confirm.initialize("Use Vibration?");
			Ui.pushView( confirm ,new ConfirmationDelegateVibration(),Ui.SLIDE_UP);
        }
    }
}

class ConfirmationDelegateSilentMode extends Ui.ConfirmationDelegate
{
	function onResponse(response)
	{
		var app=App.getApp();
		if (response==CONFIRM_YES)
		{ app.silent_mode=true; }
		else
		{ app.silent_mode=false; }
		app.setProperty(SILENT_MODE, app.silent_mode);
        Sys.println("silent_mode: "+app.silent_mode);
	}
}

class ConfirmationDelegateVibration extends Ui.ConfirmationDelegate
{
	function onResponse(response)
	{
		var app=App.getApp();
		if (response==CONFIRM_YES)
		{ app.vibration=true; }
		else
		{ app.vibration=false; }
		app.setProperty(VIBRATION, app.vibration);
        Sys.println("vibration: "+app.vibration);
	}
}
