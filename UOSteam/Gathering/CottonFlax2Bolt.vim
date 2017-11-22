// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 21NOV2017       //
// Version: 1.0                  //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + Converts Flax and Cotton to Bolts,     //
//    however, whatever the last thread is   //
//    used to complete the bolt, the bolt    //
//    be of that type.                       //
// // // // // // // // // // // // // // // //
// Clear and fresh start
@removelist 'spin_types'
//
// Get our Spinning Wheel (or near by.)
if not @findobject 'SpinningWheel'
  if @findtype 0x1015 'any' 'ground' 0 3
    @setalias 'SpinningWheel' 'found'
    headmsg "[SpinningWheel: Here]" 33 'SpinningWheel'
  else
    promptalias 'SpinningWheel'
  endif
  if not @findobject 'SpinningWheel'
    headmsg "No Spinning wheel." 33
    stop
  endif
endif
//
// Get our Loom (or near by.)
if not @findobject 'Loom'
  if @findtype 0x1062 'any' 'ground' 0 3
    @setalias 'Loom' 'found'
    headmsg "[Loom: Here]" 33 'loom'
  else
    promptalias 'Loom'
  endif
  if not @findobject 'Loom'
    headmsg "No Looms." 33
    stop
  endif
endif
//
// Construct our list of things to spin into threads.
if not @listexists 'spin_types'
  @createlist 'spin_types'
  @pushlist 'spin_types' 0xdf9  // Cotton
  @pushlist 'spin_types' 0x1a9c // Flax
  @pushlist 'spin_types' 0x1a9d // Flax
endif
// // // // // // // //
// ##  Main Loop  ## //
// // // // // // // //
// Process each type of spinnables and turn them to thread.
headmsg "[ Starting ]" 33
for 0 in 'spin_types'
  while @findtype spin_types[] 'any' 'backpack'
    useobject! 'found'
    waitfortarget 600
    target! 'Spinningwheel'
    pause 100
    // If we have more than 55 threads, convert to bolts
    if counttype 0xfa0 'any' 'backpack' >= 55
      while @findtype 0xfa0 'any' 'backpack'
        useobject! 'found'
        waitfortarget 600
        target! 'Loom'
        pause 100
      endwhile
    endif
  endwhile
endfor
//
// Process any left over thread into bolts.
while @findtype 0xfa0 'any' 'backpack'
  useobject! 'found'
  waitfortarget 600
  target! 'Loom'
  pause 100
endwhile
//
// Cleanup and announce the finish.
headmsg "[ Complete ]" 33
@unsetalias 'found'
