// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 13NOV2017       //
// Version: 1.8                  //
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
  @pushlist 'Config' 69 // [OK] Color, Default: 69
  @pushlist 'Config' 33 // [ERROR] Color, Default: 33
  @pushlist 'Config' 10 // [INFO] Color, Default: 10
  @pushlist 'Config' 3600000 // Clear tames timer, Default: 3600000 (1 Hour)
  @pushlist 'Config' 3600000 // Untameable timer, Default: 3600000 (1 Hour)
  @pushlist 'Config' 600000 // Blacklist timer, Default: 600000 (10 Mins)
  @pushlist 'Config' 180000 // Tame (Max) timer, Default: 180000 (3 Mins)
  @pushlist 'Config' 60000 // Timeout timer, Default: 60000 (1 Min)
  @pushlist 'Config' 8000 // Distance timer, Default: 8000 (8 Secs)
  @pushlist 'Config' 3500 // Spam timer, Default: 3500 (3.5 Secs)
endif
// ########## EXPLAINATION OF CONFIG ##########
// Config[0]  - What to rename the pet post-tame.
// Config[1]  - Color of messages that indicate GOOD.
// Config[2]  - Color of messages that indicate BAD.
// Config[3]  - Color of messages regarding INFORMATION.
// Config[4]  - Timer for clearing the serials of successful tames.
// Config[5]  - Timer for clearing the serials of untameable creatures.
// Config[6]  - Timer for clearing the serials of unreachable creatures.
// Config[7]  - Timer for the total amount of time allowed for 1 creature.
// Config[8]  - Timer for clearing the serials of tames in progress (by others)
// Config[9]  - Timer for the maximum of time until determined unreachable.
// Config[10] - Timer that limits the amount of messages we display.
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
//    + Tamed creatures.                     //
//    + Blacklisted (unreachable.)           //
//    + Tames-in-Progress.                   //
//  + Spam message filtering.                //
//  + Built-in Force Name change.            //
//  + Prevention against untameable pretames //
//  + Screenshots when being attacked.       //
//  + Screenshots death, keep journal open!  //
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
//  v1.4                                     //
//   + Additional output for clearing lists  //
//  v1.5                                     //
//   + Ignores pre-tames after desired       //
//      amount of time has passed.           //
//   + Prevention on taming tames that are   //
//      in progress.                         //
//   + Tames are being pushed to their own   //
//      list instead of ignorelist.          //
//   + Screenshots the moment being attacked //
//   + Screenshot at time of death.          //
//  v1.6                                     //
//   + Additional checks on if it can be     //
//     renamed.                              //
//  v1.8                                     //
//   + Added better timeoutting on cretures  //
//    that are unreachable.                  //
//   + Added an additional check for tames   //
//    that are currently in progress.        //
//  [Both additions cut down on AFK Checks]  //
//                                           //
// Updated versions posted at:               //
//   https://github.com/d0x1p2/UO-Scripts    //
// // // // // // // // // // // // // // // //
// Our fresh start, removing to be rebuilt.  //
@clearjournal
@clearignorelist
@removelist 'Tames-low'
@removelist 'Tames-med'
@removelist 'Tames-high'
@removelist 'ranges_lt'
@unsetalias 'toTame'
// // // // // // // // // // // //
//   ######  Lists  ######       //
// // // // // // // // // // // //
// 'Tames-low'     - Low end mobs for taming levels below 62.
// 'Tames-md'      - Mid end mobs for taming below 72.
// 'Tames-high'    - High end mobs for taming above 72.
// 'ranges_lt'     - Ranges to search for tames, closest -> furthest.
// 'tames_lt'      - A list populated with successful tames.
// 'blacklist_lt'  - A list populated with unreachable tames.
// 'untameable_lt' - A list populated with pre-tames.
// 'timeout_lt'    - A list populated with tames-in-progress by others.
// 'counter_lt'    - Used for simple arithmetic.
// 'secret_lt'     - Secret settings!
// ## TAME TIERS ##
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
// // // // // // //
// ## RANGES ##   //
// Ranges to check away from self
if not @listexists 'ranges_lt'
  @createlist 'ranges_lt'
  @pushlist 'ranges_lt' 4
  @pushlist 'ranges_lt' 8
  @pushlist 'ranges_lt' 12
  @pushlist 'ranges_lt' 16
endif
// // // // // // // // // // // // // //
// ###  LISTS FOR STORING SERIALS   ## //
// List of successful tames.
if not @listexists 'tames_lt'
  @createlist 'tames_lt'
endif
// Blacklist of inaccessible mobs (stores serials)
if not @listexists 'blacklist_lt'
  @createlist 'blacklist_lt'
endif
// Untameables that cant quite be tamed.
if not @listexists 'untameable_lt'
  @createlist 'untameable_lt'
endif
// Timeouts, currently being tamed creatures.
if not @listexists 'timeout_lt'
  @createlist 'timeout_lt'
endif
// Counters, used for arithmetic and prevent getting stuck.
if not @listexists 'counter_lt'
  @createlist 'counter_lt'
endif
// Secret settings! Comment out with '//' what to disable.
@removelist 'secret_lt'
if not @listexists 'secret_lt'
  @createlist 'secret_lt'
  //@pushlist 'secret_lt' "afk"  // Alerts of an AFK gump, requires 'alert.wav'
  //  -  -  -  -  -  -  -  -  -  //  Can be found at the link in "Changes" at
  //  -  -  -  -  -  -  -  -  -  //  the top, place 'alert.wav' in your
  //  -  -  -  -  -  -  -  -  -  //  Steam/Sounds/ folder for it to work.
endif
// // // // // // // // // //
// ######  Timers  ######  //
// // // // // // // // // //
// 'cleartamed_t' - Counts up to when to clear tamed creature list.
// 'untameable_t' - Counts up to when to clear pre-tamed creature list.
// 'blacklist_t'  - Counts up to when to clear unreachable creature list.
// 'tame_t'       - Tracks total length a tame is occuring.
// 'timeout_t'    - Counts up to when to clear tame-in-progress by others.
// 'distance_t'   - Tracks amount of time spent further than 1 tile away.
// 'spam_t'       - Prevent messages from continously printing.
// Clear tamed timer, timer for ignored objects.
if not @timerexists 'cleartamed_t'
  @createtimer 'cleartamed_t'
endif
// Untameable timer, Ignores a creature that is a pre-tame.
if not @timerexists 'untameable_t'
  @createtimer 'untameable_t'
endif
// Blacklist timer, timer for clearing blacklist.
if not @timerexists 'blacklist_t'
  @createtimer 'blacklist_t'
endif
// Tame timer, amount of time we've been taming.
if not @timerexists 'tame_t'
  @createtimer 'tame_t'
endif
// Tame Timeout timer, amount of time to ignore a tame-in-progress.
if not @timerexists 'timeout_t'
  @createtimer 'timeout_t'
endif
// Distance timer, timer that determines if it is inaccessible.
if not @timerexists 'distance_t'
  @createtimer 'distance_t'
endif
// Spam timer, timer that determines messages timeouts.
if not @timerexists 'spam_t'
  @createtimer 'spam_t'
else
  @settimer 'spam_t' Config[9]
endif
// // // // // // // // // // // // // // // //
// ##  Verify Default for name is Changed ## //
// // // // // // // // // // // // // // // //
if @inlist 'Config' "ChangeMe"
  for 3
    headmsg "[Change Name: Line 17]" Config[3]
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
    if timer 'spam_t' >= Config[9]
      headmsg "[Searching for Tame]" Config[1]
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
        if @inlist 'tames_lt' 'potentialTame'
          @ignoreobject 'potentialTame'
          @unsetalias 'potentialTame'
        elseif @inlist 'blacklist_lt' 'potentialTame'
          @ignoreobject 'potentialTame'
          @unsetalias 'potentialTame'
        elseif @inlist 'untameable_lt' 'potentialTame'
          @ignoreobject 'potentialTame'
          @unsetalias 'potentialTame'
        elseif @inlist 'timeout_lt' 'potentialTame'
          @ignoreobject 'potentialTame'
          @unsetalias 'potentialTame'
        else
          @clearignorelist
          @settimer 'tame_t' 0
          @settimer 'distance_t' 0
          @setalias 'toTame' 'potentialTame'
          @unsetalias 'potentialTame'
          headmsg "[Being Tamed]" Config[1] 'toTame'
          break
        endif
      endif
    endfor
  endif
  // // // // // // // // // // //
  // Begin the taming Process.  //
  // // // // // // // // // // //
  if @findobject 'toTame'
    while not dead 'toTame'
      // Make sure it hasnt been tamed while weve been trying.
      if @property "(tame)" 'toTame'
        headmsg "[Tamed]" Config[1] 'toTame'
        // Attempt a rename.
        pause 250
        for 5
          @rename 'toTame' Config[0]
          if name 'toTame' == Config[0]
            break
          endif
          pause 200
        endfor
        if name 'toTame' == Config[0]
          // Tamed successfully. Release and repeat.
          @clearlist 'counter_lt'
          while not @gumpexists 0x77565776
            waitforcontext 'toTame' 8 1000
            if list 'counter_lt' > 5
              @clearlist 'counter_lt'
              break
            endif
            @pushlist 'counter_lt' 'toTame'
            pause 250
          endwhile
          pause 600
          replygump 0x77565776 2
          @pushlist 'tames_lt' 'toTame'
          headmsg "[Released]" Config[1] 'toTame'
        else
          // Was tamed by someone else. Temporarily timeout it.
          if not @inlist 'timeout_lt' 'toTame'
            @pushlist 'timeout_lt' 'toTame'
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
        // Our target is too far, clearjournal and attempt to retame.
      endif
      if @injournal "too far"
        @clearjournal
        // We failed, clear journal to begin retame.
      elseif @injournal "fail"
        @clearjournal
        // Surface mismatch, unable to see.
      elseif @injournal "cannot be seen"
        @clearjournal
        headmsg "[Bad Pathing]" Config[2] 'toTame'
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
        // Unable to get to it for some odd reason.
      elseif @injournal "a clear path"
        @clearjournal
        headmsg "[Bad Pathing]" Config[2] 'toTame'
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
        // Tame is already occuring, timeout the tame for a few minutes.
      elseif @injournal "already being tamed"
        @clearjournal
        headmsg "[Tame in Progress]" Config[2] 'toTame'
        @pushlist 'timeout_lt' 'toTame'
        @unsetalias 'toTame'
        break
      elseif @injournal "already taming this"
        headmsg "[Tame in Progress]" Config[2] 'toTame'
        @clearjournal
        @pushlist 'timeout_lt' 'toTame'
        @unsetalias 'toTame'
        break
        // Can't tame this... add it to our blacklist.
      elseif @injournal "no chance"
        @clearjournal
        headmsg "[Lack Skill]" Config[2] 'toTame'
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
      elseif @injournal "attacking you"
        // Break off current tame, just in case.
        @clearjournal
        headmsg "[Being Attacked]" Config[2]
        snapshot 100
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
      // // // // // // // // //
      // ### ALERT SYSTEM ### //
      // // // // // // // // //
      if @inlist 'secret_lt' "afk"
        if @gumpexists 0x7c04fbbf
          headmsg "[AFK Check]" Config[2]
          playsound "alert.wav"
          while @gumpexists 0x7c04fbbf
          endwhile
        elseif @gumpexists 0x6ec0aab
          replygump 0x6ec0aab 1
          while @gumpexists 0x6ec0aab
          endwhile
        endif
      endif
      // // // // // // // // // // // // // // //
      // Check if it's taken too long to reach. //
      // // // // // // // // // // // // // // //
      if timer 'distance_t' >= Config[9]
        headmsg "[Unreachable]" Config[2] 'toTame'
        @settimer 'distance_t' 0
        @pushlist 'blacklist_lt' 'toTame'
        @unsetalias 'toTame'
        break
        // Creature hasn't been tamed, Most likely a pre-tame.
      elseif timer 'tame_t' >= Config[7]
        headmsg "[Pre-Tame detected]" Config[2] 'toTame'
        @settimer 'tame_t' 0
        @pushlist 'untameable_lt' 'toTame'
        @unsetalias 'toTame'
        break
      elseif dead 'self'
        break
      endif
    endwhile
  endif
  // // // // // // // // // // // // // // //
  // Check our timers, reset what we need.  //
  // // // // // // // // // // // // // // //
  // Clear the ignored objects (tamed)
  if timer 'cleartamed_t' >= Config[4]
    headmsg "[Clearing: Tames]" Config[3]
    @clearlist 'tames_lt'
    @settimer 'cleartamed_t' 0
    // Clear the untameable creatures (pre-tames)
  elseif timer 'untameable_t' >= Config[5]
    if list 'untameable_lt' > 0
      headmsg "[Clearing: Untameables]" Config[3]
      @clearlist 'untameable_lt'
    endif
    @settimer 'untameable_t' 0
    // Clear the blacklisted creatures.
  elseif timer 'blacklist_t' >= Config[6]
    if list 'blacklist_lt' > 0
      headmsg "[Clearing: Blacklist]" Config[3]
      @clearlist 'blacklist_lt'
    endif
    @settimer 'blacklist_t' 0
    // Clear tame in progresses
  elseif timer 'timeout_t' >= Config[8]
    if list 'timeout_lt' > 0
      headmsg "[Clearing: Timeouts]" Config[3]
      @clearlist 'timeout_lt'
    endif
    @settimer 'timeout_t' 0
  endif
endwhile
// Got here due to our death, screenshot and notify user.
snapshot 1000
while dead
  headmsg "[..:: You Died ::..]" Config[2]
  pause 2500
  headmsg "[Screenshot taken]" Config[2]
  pause 2500
endwhile
