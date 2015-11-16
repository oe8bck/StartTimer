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

class InputDelegate extends Ui.BehaviorDelegate
{

	var sec,min;

	function onNextPage() {
		//Sys.println("Back");
		min=counter/60;
		//counter=min*60;
		counter_start=min*60+(Sys.getTimer()-timer_start)/1000;
		requestUpdate();
	}

	function onSelect() {
		//Sys.println("started "+started);
		sec=counter%60;
		min=counter/60;
		if (sec<30) {
			//counter=min*60;
			counter_start=min*60+(Sys.getTimer()-timer_start)/1000;
		}
		else {
			//counter=(min+1)*60;
			counter_start=(min+1)*60+(Sys.getTimer()-timer_start)/1000;
		}
		requestUpdate();
	}

    function onMenu() {
		//Sys.println("Menu");
		var menu=new Rez.Menus.Main_Menu();
		if (timerView.isRecording()==true) {
			menu.setTitle("Tracking");
		} else {
			menu.setTitle("NOT Tracking");
		}
        Ui.pushView( menu, new MyMenuDelegate(), Ui.SLIDE_UP );
    }

    function onBack() {
 	   Ui.popView(Ui.SLIDE_IMMEDIATE);
       //Sys.println("Stop Recording");
	   if ( timerView != null ){
		 timerView.stopRecording();
	   }
       return true;
    }

}


