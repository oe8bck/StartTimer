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
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention; 
using Toybox.Position as Position;  // permission required

var counter;
var counter_start=240;

class MyWatchView extends Ui.View {

var timer=null;
var time;
var png_sync,png_down,png_back;
var speed_kts=0.0;
var posnInfo=null;

    //! Constructor
    function initialize() {
        png_sync = Ui.loadResource(Rez.Drawables.id_sync);
        png_down = Ui.loadResource(Rez.Drawables.id_down);
        png_back = Ui.loadResource(Rez.Drawables.id_back);
        
    	counter=counter_start;
    	if (timer==null){
	    	timer=new Timer.Timer();
	    	timer.start( method(:timerCallback), 1000, true );
		}
		
    }
    
	function onPosition( info ) {
	    //Sys.println( "Position " + info.position.toGeoString( Position.GEO_DM ) );
	    speed_kts=info.speed * 1.943844;
	    posnInfo=info;
	}

	function timerCallback() {
		counter-=1;
		if (counter<0)
		{
			counter=counter_start-1;
		}
		requestUpdate();
	}

    function onLayout(dc) {
    }

    function onHide() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        timer.stop();
    }

    function onShow() {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! Update the view
    function onUpdate(dc) {
    	var deg_stop=89;
    	var min=0;
    	var sec=0;
    	var centerX;
    	var centerY;
    	var text;
    	
    	min=counter/60;
    	sec=counter%60;
    	
    	if (sec==0 || (min==0 && (sec==30||sec==10||sec==5))){
    		Attention.playTone( Attention.TONE_CANARY    );
    	}
    	
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.clear();
        if (counter<15){
        	deg_stop=90-6*counter;
        } else {
        	deg_stop=360-6*(counter-15);
        }
    	//Sys.println(deg_stop);
    	
    	centerX=dc.getWidth()/2;
    	centerY=dc.getHeight()/2;
    	if (dc has :drawArc) {
        	dc.drawArc(centerX,centerY,81,1,90,deg_stop);
        	dc.drawArc(centerX,centerY,82,1,90,deg_stop);
        }
        
        // Countdown
        if (sec<10) {
        	text=min+":0"+sec; }
        else {
        	text=min+":"+sec; }
        text=min+":"+sec.format("%02d");
        dc.drawText(centerX,centerY-2,Graphics.FONT_NUMBER_THAI_HOT,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);

		// speed / heading
		if (posnInfo!=null) {
			var heading = posnInfo.heading*90/Math.PI;
			text=speed_kts.format("%3.1f")+" kn/"+heading.format("%03d");
			dc.drawText(centerX,centerY-51,Graphics.FONT_NUMBER_MILD,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
		}
        var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
		text=info.hour.format("%2d")+":"+info.min.format("%02d")+":"+info.sec.format("%02d");
		dc.drawText(centerX,centerY+56,Graphics.FONT_NUMBER_MILD,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
		
		// info next to buttons
		dc.drawBitmap(dc.getWidth()-40, 40, png_sync);
		dc.drawBitmap(dc.getWidth()-40, dc.getHeight()-85, png_back);
		dc.drawBitmap(-5, dc.getHeight()-90, png_down);
		
		// copyright
        dc.drawText(centerX,dc.getHeight()-27,Graphics.FONT_TINY,"(c) oe8bck",Graphics.TEXT_JUSTIFY_CENTER);
        
	}
}

class InputDelegate extends Ui.BehaviorDelegate
{

	var sec,min;

	function onNextPage() {
		//Sys.println("Back");
		min=counter/60;
		counter=min*60;
		requestUpdate();
	}
	
	function onSelect() {
		//Sys.println("started "+started);
		sec=counter%60;
		min=counter/60;
		if (sec<30) {
			counter=min*60; 
		}
		else {
			counter=(min+1)*60; 
		}
		requestUpdate();
	}

    function onMenu() {
		Sys.println("Menu");
        Ui.pushView( new Rez.Menus.Settings(), new MyMenuDelegate(), Ui.SLIDE_UP );
    }

}

class MyMenuDelegate extends Ui.MenuInputDelegate {
    function onMenuItem(item) {
    	Sys.println(item);
        if ( item == :menu_starttime )
        {
			//Sys.println("Settings");
			var np = new Ui.NumberPicker( Ui.NUMBER_PICKER_TIME_MIN_SEC  , counter_start*60 );
            Ui.pushView( np, new NPDf(), Ui.SLIDE_IMMEDIATE );
			
        }
        else if ( item == :menu_about )
        {
			//Sys.println("About");
			var confirm = new Ui.Confirmation();
			confirm.initialize("(c) OE8BCK");
			Ui.pushView( confirm ,new Ui.ConfirmationDelegate(),Ui.SLIDE_UP);
        }
    }
}

class NPDf extends Ui.NumberPickerDelegate {
    function onNumberPicked(value) {
    	//Sys.println("Start"+value.value());
        counter_start = value.value();
    }
}

