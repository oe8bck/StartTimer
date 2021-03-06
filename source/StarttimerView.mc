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
using Toybox.Application as App;
using Toybox.ActivityRecording as Record;

class StarttimerView extends Ui.View {

var timer=null;
var time;
var png_sync,png_down,png_back;
var speed_kts=0.0;
var posnInfo=null;

var signalVibrate = [ new Attention.VibeProfile(50, 500) ];
var countdownVibrate = [ new Attention.VibeProfile(50, 300) ];
var startVibrate = [ new Attention.VibeProfile(50, 1000) ];

    //! Constructor
    function initialize() {
        png_sync = Ui.loadResource(Rez.Drawables.id_sync);
        png_down = Ui.loadResource(Rez.Drawables.id_down);
        png_back = Ui.loadResource(Rez.Drawables.id_back);

        //Sys.println(getCounterStart());

        App.getApp().setTimerCallback(self.method(:timerCallback));
    	counter=counter_start;
    	timer_start=Sys.getTimer();
        //Sys.println("counter:"+counter+", timer_start:"+timer_start);
    }

	function onPosition( info ) {
	    //Sys.println( "Position " + info.position.toGeoString( Position.GEO_DM ) );
	    speed_kts=info.speed * 1.943844;
	    posnInfo=info;
	}

    function timerCallback() {
        //counter -= 1;
		if (counter_start!=null && timer_start!=null)
		{
	        counter=counter_start-(Sys.getTimer()-timer_start)/1000;
        } else {
        	counter=0;
        }
		//Sys.println("Timer: "+Sys.getTimer()+" ,counter: "+counter);
        //Sys.println("startbeh: "+startbeh);
        if (counter < 0 && runmode==MODE_COUNTDOWN)
        {
			Sys.println("restartTimer");
            if (startbeh==MENU_START_RESTART){
            	app.initializeTimer();
            }
            else if (startbeh==MENU_START_STOP){
            	runmode=MODE_STOP;
            	Ui.popView(Ui.SLIDE_IMMEDIATE);
            }
            else if (startbeh==MENU_START_RACE){
				runmode=MODE_RACE;
				//timer_start=Sys.getTimer();
            }
        	//Sys.println("counter:"+counter+", timer_start:"+timer_start);
        }

        Ui.requestUpdate();
    }

    function onLayout(dc) {
    }

    function onHide() {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        App.getApp().pauseTimer();
        // clean-up
		timer=null;
		time=0;
    }

    function onShow() {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        App.getApp().resumeTimer();
    }

	function playAttention(tone,vibe)
	{
		if (silent_mode==false)
			{ Attention.playTone( tone ); }
		if (vibration==true)
			{ Attention.vibrate(vibe); }
	}

	function min(a,b) {
		if (a<b) { return a; }
		else { return b; }
	}

    //! Update the view
    function onUpdate(dc) {
    	var deg_stop=89;
    	var min=0;
    	var sec=0;
    	var centerX;
    	var centerY;
    	var heading=0;
    	var text;

		if (counter!=null)
		{
	    	min=counter/60;
    		sec=counter%60;
    	} else {
    		min=59;
    		sec=59;
    	}
		if (runmode==MODE_RACE){
			min=-min;
			sec=-sec;
		}

		// Ring & Vibrate
		if (runmode==MODE_COUNTDOWN){
	    	if (sec==0 && counter!=counter_start){ // don't do it when countdown starts
	    		if (min==0){ //start
	    			playAttention(Attention.TONE_INTERVAL_ALERT,countdownVibrate);
	    		} else { // full minute
	    			playAttention(Attention.TONE_ALERT_LO,startVibrate);
	    		}
	    	} else if (min==0){
	    		if (sec==30||sec==20||sec==10){
	    			playAttention(Attention.TONE_ALERT_HI,signalVibrate);
	    		}
	    		else if (sec==5){
	    			playAttention(Attention.TONE_ALERT_HI,signalVibrate);
	    		}
	    	}
		}

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
    	dc.clear();
    	centerX=dc.getWidth()/2;
    	centerY=dc.getHeight()/2;

		if (posnInfo!=null) {
			heading = posnInfo.heading*90/Math.PI;
		}

		// draw arc or speed
		if (runmode==MODE_COUNTDOWN){
	        if (counter==null){
	        	deg_stop=0;
	        } else {
		        if (counter!=null && counter<15){
		        	deg_stop=90-6*counter;
		        } else {
		        	deg_stop=360-6*(counter-15);
		        }
		    	//Sys.println(deg_stop);
			}
	    	if (dc has :drawArc) {
	        	dc.drawArc(centerX,centerY,81,1,90,deg_stop);
	        	dc.drawArc(centerX,centerY,82,1,90,deg_stop);
	        }

		// countdown
        text=min+":"+sec.format("%02d");
        dc.drawText(centerX,centerY-2,Graphics.FONT_NUMBER_THAI_HOT,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);

		// speed / heading
		if (posnInfo!=null) {
			if (heading<0.0){
				heading+=360.0;
			}
			text=speed_kts.format("%3.1f")+" kn/"+heading.format("%03d");
			dc.drawText(centerX,centerY-51,Graphics.FONT_NUMBER_MILD,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
		}
		} else { // race mode
			//dc.drawText(centerX-51,centerY,Graphics.FONT_NUMBER_MILD,speed_kts.format("%3.1f"),Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
			//dc.drawRoundedRectangle(centerX-70, centerY-30, 10, 60,3);
        	//var pct=min(1,speed_kts/max_speed);
	        //if (pct<0.25){
	        //	deg_stop=90*(1-4.0*pct);
	        //} else {
	        //	deg_stop=360-270*(pct-0.25);
	        //}
			//Sys.println(deg_stop);
	    	//if (dc has :drawArc) {
	        //	dc.drawArc(centerX,centerY,81,1,deg_stop,90);
	        //	dc.drawArc(centerX,centerY,82,1,deg_stop,90);
	        //}
			// speed
	        text=speed_kts.format("%3.2f");
	        dc.drawText(centerX,centerY-2,Graphics.FONT_NUMBER_THAI_HOT,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
	        dc.drawText(centerX+74,centerY+20,Graphics.FONT_NUMBER_MILD,"kn",Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
			// heading and tack hints
			if (posnInfo!=null) {
				var tack_left=heading-tackAngle;
				if (tack_left<0.0){
					tack_left+=360.0;
				}
				var tack_right=heading+tackAngle;
				if (tack_right<0.0){
					tack_right+=360.0;
				}
				text=tack_left.format("%03d")+" / "+heading.format("%03d")+" / "+tack_right.format("%03d");
				dc.drawText(centerX,centerY-51,Graphics.FONT_NUMBER_MILD,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);
			}
			// speed symbol
			var height=min(80,speed_kts/max_speed*80);
			dc.drawRoundedRectangle(centerX-74, centerY+40-height, 10, height,3);
		}

		// time
        var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
		text=info.hour.format("%2d")+":"+info.min.format("%02d")+":"+info.sec.format("%02d");
		dc.drawText(centerX,centerY+56,Graphics.FONT_NUMBER_MILD,text,Graphics.TEXT_JUSTIFY_CENTER+Graphics.TEXT_JUSTIFY_VCENTER);

		// info next to buttons
		dc.drawBitmap(dc.getWidth()-40, 40, png_sync);
		dc.drawBitmap(dc.getWidth()-40, dc.getHeight()-85, png_back);
		dc.drawBitmap(-5, dc.getHeight()-90, png_down);

		// copyright
        dc.drawText(centerX,dc.getHeight()-27,Graphics.FONT_TINY,"(c) oe8bck",Graphics.TEXT_JUSTIFY_CENTER);

		// recording icon
		if( session != null && session.isRecording() && sec%2) {
	        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_WHITE);
			dc.fillCircle(centerX+58,centerY-48,5);
		}
	}

	function isRecording() {
		var ret;
		if ( session == null ) {
			ret=false;
		} else {
			ret=session.isRecording();
		}
		return ret;
	}

    function startRecording() {
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

    function stopRecording() {
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

}

