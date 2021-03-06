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

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

var session = null;

class MyMenuDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
        if ( item == :menu_about )
        {
			//Sys.println("About");
			var confirm = new Ui.Confirmation();
			confirm.initialize("(c) OE8BCK");
			Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP);
			confirm=null;
        }
        else if ( item == :menu_togglerec )
        {
        	//Sys.println("Start Recording");
			if ( timerView != null ){
				if (timerView.isRecording()==false){
		        	timerView.startRecording();
	        	} else {
		        	timerView.stopRecording();
				}
		    }
        }
        else if ( item == :menu_settings )
        {
        	//Sys.println("Stop App");
            Ui.pushView( new Rez.Menus.Settings_Menu(), new SettingsMenuBehDelegate(), Ui.SLIDE_UP );
        }
    }
}

class MyNumberFactory extends Ui.PickerFactory{
  function getDrawable(item, isSelected){
      return new Ui.Text({:text=>item.toString(),
                          :color=>Gfx.COLOR_WHITE,
                          :font=>Gfx.FONT_NUMBER_THAI_HOT,
                          :justification=>Gfx.TEXT_JUSTIFY_LEFT});
  }
  function getSize(){ return 30;  }
  function getValue(item){ return item;}
}

class MyPickerDelegate extends Ui.PickerDelegate{
  function onAccept( values ){
    for(var i = 0; i< values.size(); i++){
     //Sys.println(values[i]*60);
     counter_start=values[i]*60;
     App.getApp().setProperty(COUNTER_START_KEY, counter_start);
   }
   Ui.popView(Ui.SLIDE_DOWN);
   return true;
  }
  function onCancel( ){
  	return true;
  }
}
