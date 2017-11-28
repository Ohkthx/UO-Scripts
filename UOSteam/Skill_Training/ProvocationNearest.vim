// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 28NOV2017       //
// Version: 1.0                 //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + Attempts to provocate the nearest two  //
//   enemies.                                //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
// // // // // // // // // // // // // // // //
// Get our fresh start by clearing our aliases and lists.
@clearjournal
@removelist 'instrumentlist'
@removelist 'range'
@removelist 'enemies'
@unsetalias 'toProvoOne'
@unsetalias 'toProvoTwo'
// // // // // //
// ## LISTS ## //
// // // // // //
// Creates an instrument pushlist if it does not exist.
if not listexists 'instrumentlist'
  @createlist 'instrumentlist'
  @pushlist 'instrumentlist' 0xeb1 // Standing Harp
  @pushlist 'instrumentlist' 0xeb2 // Lap Harp
  @pushlist 'instrumentlist' 0xeb3 // Lute
  @pushlist 'instrumentlist' 0xe9c // Drum
  @pushlist 'instrumentlist' 0xe9d // Tambourine
  @pushlist 'instrumentlist' 0xe9e // Tambourine with red tassle
endif
// Our ranges to check in order.
if not @listexists 'range'
  @createlist 'range'
  @pushlist 'range' 0
  @pushlist 'range' 1
  @pushlist 'range' 2
  @pushlist 'range' 3
  @pushlist 'range' 4
  @pushlist 'range' 5
  @pushlist 'range' 6
  @pushlist 'range' 8
  @pushlist 'range' 10
endif
// Enemy list
if not @listexists 'enemies'
  @createlist 'enemies'
endif
// // // // // // // //
// ##  END LISTS ##  //
// // // // // // // //
// Select an instrument automatically to use.
if not @findobject 'instrument' 'any' 'backpack'
  for 0 to 'instrumentlist'
    // Found a type? Use it as ours.
    if @findtype instrumentlist[]
      @setalias 'instrument' 'found'
      useobject! 'instrument'
      break
    endif
  endfor
  // Iterated our list of types, if it wasn't found- stop.
  if not @findobject 'instrument' 'any' 'backpack'
    headmsg "Couldn't find instrument" 33
    stop
  endif
endif
// Find our targets :D
for 15
  @getenemy 'criminal' 'enemy' 'gray' 'murderer'
  // Add to our list of enemies.
  if @inrange 'enemy' 10
    if not @inlist 'enemies' 'enemy'
      @pushlist 'enemies' 'enemy'
    endif
  endif
endfor
// Verify we have more than 2 enemies in our list.
if list 'enemies' == 0
  headmsg "[Missing: 2 Enemies]" 33
  stop
elseif list 'enemies' == 1
  headmsg "[Missing: 1 Enemy]" 33
  stop
endif
// Check their ranges.
for 0 in 'range'
  for 0 in 'enemies'
    if @inrange enemies[] range[]
      // If 'toProvoOne' isn't set- set it.
      if not @findobject 'toProvoOne'
        @setalias 'toProvoOne' enemies[]
        headmsg "[ Target Set: 1 ]" 69 'toProvoOne'
        // Remove it from our list of enemies.
        @poplist 'enemies' enemies[]
        // If 'toProvoTwo' isn't set- set it.
      elseif not @findobject 'toProvoTwo'
        @setalias 'toProvoTwo' enemies[]
        headmsg "[ Target Set: 2 ]" 69 'toProvoTwo'
        // Remove it from out list of enemies and break the loop.
        @poplist 'enemies' enemies[]
        break
      else
        break
      endif
    endif
  endfor
  // If 'toProvoOne' and 'toProvoTwo' are set, break the final loop.
  if @findobject 'toProvoTwo'
    break
  endif
endfor
// // // // // // // // // // //
// # Start the Provocation #  //
// // // // // // // // // // //
useskill 'Provocation'
waitfortarget 1000
target! 'toProvoOne'
pause 250
if @injournal "cannot be seen"
  headmsg "[ Target 1: Unseen ]" 33 'toProvoOne'
elseif @injournal "you must wait"
  headmsg "[ Skill Timed Out ]" 33
  stop
else
  waitfortarget 750
  target! 'toProvoTwo'
  pause 250
  if @injournal "cannot be seen"
    headmsg "[ Target 2: Unseen ]" 33 'toProvoTwo'
  endif
endif
if @injournal "cannot be seen"
  for 3
    headmsg "[ Bad Target ]" 33
  endfor
elseif @injournal "too far away"
  headmsg "[ They're too far Apart ]" 33
elseif @injournal "play poorly"
  headmsg "[ Played Poorly ]" 33
elseif @injournal "play poorly"
  headmsg "[ Played Poorly ]" 33
elseif @injournal "fails to incite"
  headmsg "[ Failed to Incite ]" 33
elseif @injournal "succeeds"
  headmsg "[ Fight Started ]" 69
endif
