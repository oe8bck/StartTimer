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

class InputDelegate extends Ui.BehaviorDelegate
{

	var sec,min;

	function onNextPage() {
		//Sys.println("Back");
		var app=App.getApp();
		min=app.counter/60;
		//counter=min*60;
		app.counter_start=min*60+(Sys.getTimer()-app.timer_start)/1000;
		requestUpdate();
	}

	function onSelect() {
		//Sys.println("started "+started);
		var app=App.getApp();
		sec=app.counter%60;
		min=app.counter/60;
		if (sec<30) {
			//counter=min*60;
			app.counter_start=min*60+(Sys.getTimer()-app.timer_start)/1000;
		}
		else {
			//counter=(min+1)*60;
			app.counter_start=(min+1)*60+(Sys.getTimer()-app.timer_start)/1000;
		}
		requestUpdate();
	}

    function onMenu() {
		//Sys.println("Menu");
        Ui.pushView( new Rez.Menus.Main_Menu(), new MyMenuDelegate(), Ui.SLIDE_UP );
    }

    function onBack() {
	   var app=App.getApp();
 	   Ui.popView(Ui.SLIDE_IMMEDIATE);
       //Sys.println("Stop Recording");
	   if ( app.matchView != null ){
		 app.matchView.stopRecording();
	   }
       return true;
    }

}


