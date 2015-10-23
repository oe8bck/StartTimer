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
using Toybox.System as Sys;

// configurations to be stored
enum 
{
    COUNTER_START_KEY,
    STARTBEH
}

enum 
{
	MENU_START_RACE,
    MENU_START_RESTART,
    MENU_START_STOP
}

// Globals
var counter;
var counter_start;
var startbeh;

class MyApp extends App.AppBase { 

	var matchView=null;
	var inputDelegate=null;
	
    hidden var timer;
    hidden var timer_callback;

    function initialize() {
        counter_start = getProperty(COUNTER_START_KEY);
        //Sys.println("counter_start:"+counter_start);
        if (counter_start == null)
        {
            counter_start = 240;
        }
        //Sys.println("counter_start:"+counter_start);
        startbeh=getProperty(STARTBEH);
        if (startbeh == null)
        {
            startbeh = MENU_START_RESTART;
        }
    }

    // onStart() is called on application start up
    function onStart() {
        timer_callback = null;
        resumeTimer();
    }

    // onStop() is called when your application is exiting
    function onStop() {
        Sys.println("counter_start:"+counter_start);
        //App.saveProperties();
		if ( matchView != null ){
        	matchView.stopRecording();
        }
        pauseTimer();
        timer_callback = null;
    }

    // Return the initial view of your application here
    function getInitialView() {
    	matchView = new MyWatchView();
    	inputDelegate = new InputDelegate();
        return [ matchView , inputDelegate];
    }

    function pauseTimer() {
        if (timer != null) {
            timer.stop();
            timer = null;
        }
    }

    function resumeTimer() {
        if (timer == null) {
            timer = new Timer.Timer();
            timer.start(self.method(:onTimer), 1000, true);
        }
    }

    function onTimer() {
        if (timer_callback != null) {
            timer_callback.invoke();
        }
    }

    function setTimerCallback(callback) {
        timer_callback = callback;
    }
}
