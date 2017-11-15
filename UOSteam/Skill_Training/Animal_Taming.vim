// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 13NOV2017       //
// Version: 1.3                  //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + Change line 17s "ChangeMe" to a new    //
//    new name of your liking. Otherwise     //
//    players using the same script will     //
//    hinder your training if they have not  //
//    modified it themselves.                //
// // // // // // // // // // // // // // // //
//   ##########   CONFIGURATION   ##########
@removelist 'Config'
if not @listexists 'Config'
  @createlist 'Config'
  @pushlist 'Config' "ChangeMe" // Renaming name, CHANGE THIS (no spaces).
  // -------------------------- //  Change from default ("ChangeMe")
  @pushlist 'Config' 3600000 // Clear timer, Default: 3600000 (1 Hour)
  @pushlist 'Config' 600000 // Blacklist timer, Default: 600000 (10 Mins)
  @pushlist 'Config' 8000 // Distance timer, Default: 8000 (8 Secs)
  @pushlist 'Config' 3500 // Spam timer, Default: 3500 (3.5 Secs)
  @pushlist 'Config' 69 // [OK] Color, Default: 69
  @pushlist 'Config' 33 // [ERROR] Color, Default: 33
  @pushlist 'Config' 10 // [INFO] Color, Default: 10
endif
// ##########   END CONFIGURATION   ##########
// // // // // // // // // // // // // // // //
// Features:                                 //
//  + Customize the "Config"!                //
//  + Refreshes on script restart.           //
//  + Auto-Prevents taming tamed creatures.  //
//  + Moves to creatures.                    //
//  + Skips unreachable creatures.           //
//  + Text to notify current action.         //
//  + Prioritizes creatures based on ranges. //
//  + Prioritizes creatures based on level.  //
//  + Automatically clears serials of:       //
//    + Ignored objects (tamed)              //
//    + Blacklisted (unreachable.)           //
//  + Spam message filtering.                //
//  + Built-in Force Name change.            //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
//  v1.1                                     //
//   + Prioritizing based on taming level.   //
//   + Additional 'distance_t' timers added. //
//   + Blacklist clearing changed to 10min.  //
//   + Bad Pathing accounted for now.        //
//  v1.2                                     //
//   + "Changes" updated.                    //
//   + Pause added for releasing.            //
//  v1.3                                     //
//   + Changed "High" tier to >71 taming.    //
//                                           //
// Updated versions posted at:               //
//   https://github.com/d0x1p2/UO-Scripts    //
// // // // // // // // // // // // // // // //
// Our fresh start, removing to be rebuilt.  //
@clearjournal
@removelist 'Tames-low'
@removelist 'Tames-med'
@removelist 'Tames-high'
@removelist 'ranges_lt'
@unsetalias 'toTame'
// // // // // // // // // // // //
//   ######  Lists  ######       //
// // // // // // // // // // // //
// ## TAMES ##
// Low-tier tames, 50 - 62
if not @listexists 'Tames-low'
  @createlist 'Tames-low'
  @pushlist 'Tames-low' 0xe1 // Timber Wolf
  @pushlist 'Tames-low' 0x19 // Gray Wolf
  @pushlist 'Tames-low' 0x1b // Gray Wolf
  @pushlist 'Tames-low' 0xed // Hind
  @pushlist 'Tames-low' 0xdc // Llama
endif
// Mid-tier tames, 62 - 72
if not @listexists 'Tames-med'
  @createlist 'Tames-med'
  @pushlist 'Tames-med' 0xd6 // Panther
  @pushlist 'Tames-med' 0x40 // Snow Leopard
  @pushlist 'Tames-med' 0x41 // Snow Leopard
  @pushlist 'Tames-med' 0xd5 // Polar Bear
endif
// High-tier tames, 72 - 100
if not @listexists 'Tames-high'
  @createlist 'Tames-high'
  @pushlist 'Tames-high' 0x22 // White Wolf
  @pushlist 'Tames-high' 0x25 // White Wolf
  @pushlist 'Tames-high' 0xe8 // Bull
  @pushlist 'Tames-high' 0xe9 // Bull
  @pushlist 'Tames-high' 0xea // Great Heart
  @pushlist 'Tames-high' 0x62 // Hellhound
endif
// ## RANGES ##
// Ranges to check away from self
if not @listexists 'ranges_lt'
  @createlist 'ranges_lt'
  @pushlist 'ranges_lt' 4
  @pushlist 'ranges_lt' 8
  @pushlist 'ranges_lt' 12
  @pushlist 'ranges_lt' 16
endif
// Blacklist of inaccessible mobs (stores serials)
if not @listexists 'blacklist_lt'
  @createlist 'blacklist_lt'
endif
// // // // // //
// ##  Timers  ##
// Clear timer, timer for ignored objects.
if not @timerexists 'clear_t'
  @createtimer 'clear_t'
endif
// Blacklist timer, timer for clearing blacklist.
if not @timerexists 'blacklist_t'
  @createtimer 'blacklist_t'
endif
// Distance timer, timer that determines if it is inaccessible.
if not @timerexists 'distance_t'
  @createtimer 'distance_t'
else
  @settimer 'distance_t' 0
endif
// Spam timer, timer that determines messages timeouts.
if not @timerexists 'spam_t'
  @createtimer 'spam_t'
else
  @settimer 'spam_t' Config[4]
endif
// // // // // // // // // // // // // // // //
// ##  Verify Default for name is Changed ## //
// // // // // // // // // // // // // // // //
if @inlist 'Config' "ChangeMe"
  for 3
    headmsg "[Change Name: Line 17]" Config[6]
  endfor
  stop
endif
//// // // // // // // // // // // ////
//// // // // // // // // // // // ////
////    ###   Main - Core   ###    ////
//// // // // // // // // // // // ////
//// // // // // // // // // // // ////
while not dead
  // // // // // // // // //
  // Get our mob to tame. //
  // // // // // // // // //
  if not @findobject 'toTame'
    if timer 'spam_t' >= Config[4]
      headmsg "[Searching for Tame]" Config[7]
      @settimer 'spam_t' 0
    endif
    // Check based on Range and Skill.
    for 0 in 'ranges_lt'
      if skill 'Animal Taming' > 71
        for 0 in 'Tames-high'
          if @findtype Tames-high[] 'any' 'ground' 1 ranges_lt[]
            @setalias 'potentialTame' 'found'
            break
          endif
        endfor
      endif
      if not @findobject 'potentialTame'
        if skill 'Animal Taming' > 62
          for 0 in 'Tames-med'
            if @findtype Tames-med[] 'any' 'ground' 1 ranges_lt[]
              @setalias 'potentialTame' 'found'
              break
            endif
          endfor
        endif
      endif
      if not @findobject 'potentialTame'
        for 0 in 'Tames-low'
          if @findtype Tames-low[] 'any' 'ground' 1 ranges_lt[]
            @setalias 'potentialTame' 'found'
            break
          endif
        endfor
      endif
      // Validate we have a potential tame.
      if @findobject 'potentialTame'
        @settimer 'distance_t' 0
        if not @inlist 'blacklist_lt' 'potentialTame'
          @setalias 'toTame' 'potentialTame'
          @unsetalias 'potentialTame'
          headmsg "[Being Tamed]" Config[5] 'toTame'
          break
        else
          @unsetalias 'potentialTame'
        endif
      endif
    endfor
  endif
  // // // // // // // // // // //
  // Begin the taming Process.  //
  // // // // // // // // // // //
  if @findobject 'toTame'
    while not dead 'toTame'
      // Make sure it hasn't been tamed while we've been trying.
      if @property "(tame)" 'toTame'
        headmsg "[Tamed]" Config[5] 'toTame'
        // Attempt a rename.
        pause 250
        @rename 'toTame' Config[0]
        pause 750
        if name 'toTame' == Config[0]
          // Tamed successfully. Release and repeat.
          while not @gumpexists 0x77565776
            waitforcontext 'toTame' 8 600
            pause 250
          endwhile
          pause 600
          replygump 0x77565776 2
          @ignoreobject 'toTame'
          headmsg "[Released]" Config[5] 'toTame'
        else
          // Was tamed by someone else. Temporarily blacklist it.
          if not @inlist 'blacklist_lt' 'toTame'
            @pushlist 'blacklist_lt' 'toTame'
          endif
        endif
        @unsetalias 'toTame'
        @clearjournal
        break
      endif
      // // // // // // // // // // // // // // //
      //  Check if we need to reattempt taming  //
      // // // // // // // // // // // // // // //
      if not @injournal "to tame the creature"
        if @inrange 'toTame' 2
          @settimer 'distance_t' 0
          useskill 'Animal Taming'
          waitfortarget 1250
          target! 'toTame'
        endif
      elseif @injournal "too far"
        // Our target is too far, clearjournal and attempt to retame.
        @clearjournal
      elseif @injournal "fail"
        // We failed, clear journal to begin retame.
        @clearjournal
      elseif @injournal "cannot be seen"
        // Surface mismatch, unable to see.
        @clearjournal
      elseif @injournal "a clear path"
        // Unable to get to it for some odd reason.
        headmsg "[Bad Pathing]" Config[6] 'toTame'
        @clearjournal
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
      elseif @injournal "no chance"
        // Can't tame this... add it to our blacklist.
        headmsg "[Lack Skill]" Config[6] 'toTame'
        @clearjournal
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
      endif
      // // // // // // // // //
      //  Move to the target  //
      // // // // // // // // //
      if not @inrange 'toTame' 1
        if @x 'toTame' > x 'self' and @y 'toTame' > y 'self'
          run 'Southeast'
        elseif @x 'toTame' < x 'self' and @y 'toTame' > y 'self'
          run 'Southwest'
        elseif @x 'toTame' > x 'self' and @y 'toTame' < y 'self'
          run 'Northeast'
        elseif @x 'toTame' < x 'self' and @y 'toTame' < y 'self'
          run 'Northwest'
        elseif @x 'toTame' > x 'self' and @y 'toTame' == y 'self'
          run 'East'
        elseif @x 'toTame' < x 'self' and @y 'toTame' == y 'self'
          run 'West'
        elseif @x 'toTame' == x 'self' and @y 'toTame' > y 'self'
          run 'South'
        elseif @x 'toTame' == x 'self' and @y 'toTame' < y 'self'
          run 'North'
        endif
        pause 110
      else
        @settimer 'distance_t' 0
      endif
      // // // // // // // // // // // // // // //
      // Check if it's taken too long to reach. //
      // // // // // // // // // // // // // // //
      if timer 'distance_t' >= Config[3]
        headmsg "[Unreachable]" Config[6] 'toTame'
        @settimer 'distance_t' 0
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
      endif
    endwhile
  endif
  // // // // // // // // // // // // // // //
  // Check our timers, reset what we need.  //
  // // // // // // // // // // // // // // //
  // Clear the ignored objects (tamed)
  if timer 'clear_t' >= Config[1]
    @clearignorelist
    @settimer 'clear_t' 0
    // Clear the blacklisted objects.
  elseif timer 'blacklist_t' >= Config[2]
    @clearlist 'blacklist_lt'
    @settimer 'blacklist_t' 0
  endif
endwhile
