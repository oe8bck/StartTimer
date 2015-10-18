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

class MyApp extends App.AppBase {

    // onStart() is called on application start up
    function onStart() {
    }

    // onStop() is called when your application is exiting
    function onStop() {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new MyWatchView() , new InputDelegate()];
    }

}