////////////////////////////
// based on example published in
// https://forums.garmin.com/showthread.php?328801-Generic-Picker-PickerDelegate-difficulties
////////////////////////////

using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.ActivityRecording as Record;

var session = null;

class MyMenuDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
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
        else if ( item == :menu_about )
        {
			//Sys.println("About");
			var confirm = new Ui.Confirmation();
			confirm.initialize("(c) OE8BCK");
			Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP);
			confirm=null;
        }
        else if ( item == :menu_startrec )
        {
        	//Sys.println("Start Recording");
	        if( Toybox has :ActivityRecording ) {
	            if( ( session == null ) || ( session.isRecording() == false ) ) {
	                session = Record.createSession({:name=>"Sailing", :sport=>Record.SPORT_GENERIC });
	                session.start();
	                Sys.println("start recording");
	                Ui.requestUpdate();
	            }
	            else if( ( session != null ) && session.isRecording() ) {
	                session.stop();
	                session.save();
	                session = null;
	                Ui.requestUpdate();
	            }
	        }
        }
        else if ( item == :menu_stoprec )
        {
        	//Sys.println("Stop Recording");
	        if( Toybox has :ActivityRecording ) {
	            if( session != null && session.isRecording() ) {
	                Sys.println("stop recording");
	                session.stop();
					var confirm = new Ui.Confirmation();
					confirm.initialize("Save Recording?");
					if (Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP)){
		                Sys.println("recording saved");
		                session.save();
					}
					else {
		                Sys.println("recording NOT saved");
					}					
					confirm=null;
	                session = null;
	                Ui.requestUpdate();
	            }
	        }
	    }
        else if ( item == :menu_startbeh )
        {
        	//Sys.println("Stop App");
            Ui.pushView( new Rez.Menus.Mode_after_start(), new MyMenuBehDelegate(), Ui.SLIDE_UP );
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
