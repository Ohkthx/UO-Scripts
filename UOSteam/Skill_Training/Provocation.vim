// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 17NOV2017       //
// Version: 1.1                  //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  Prompts to select a target then begins   //
//   to provocate that target onto yourself. //
// // // // // // // // // // // // // // // //
// Features:                                 //
//  + Auto instrument detection              //
//  + Snapshots on death                     //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
//  v1.1                                     //
//   + Added snapshotting death and breaking //
//    the infinite loop.                     //
//                                           //
// Updated versions posted at:               //
//   https://github.com/d0x1p2/UO-Scripts    //
// // // // // // // // // // // // // // // //
// Selects our target and verifies it exists.
if not @findobject 'toDiscord'
  headmsg "Select who to discord." 33
  promptalias 'toDiscord'
  if not @findobject 'toDiscord'
    headmsg "[Bad Target]"
    stop
  endif
endif
//Creates an instrument pushlist if it does not exist.
if not listexists 'instrumentlist'
  @createlist 'instrumentlist'
  @pushlist 'instrumentlist' 0xeb1 // Standing Harp
  @pushlist 'instrumentlist' 0xeb2 // Lap Harp
  @pushlist 'instrumentlist' 0xeb3 // Lute
  @pushlist 'instrumentlist' 0xe9c // Drum
  @pushlist 'instrumentlist' 0xe9d // Tambourine
  @pushlist 'instrumentlist' 0xe9e // Tambourine with red tassle
endif
@clearjournal
// // // // // // // // // // //
// ###  MAIN (CORE) LOOP ###  //
// // // // // // // // // // //
while not dead
  //Select an instrument automatically to use.
  if not @findobject 'instrument' 'any' 'backpack'
    for 0 to 'instrumentlist'
      if @findtype instrumentlist[]
        @setalias 'instrument' 'found'
        useobject 'instrument'
        break
      endif
    endfor
  endif
  // Keep running until instrument is destroyed.
  while @findobject 'instrument'
    // Check if target or self is dead.
    if not @findobject 'toDiscord'
      headmsg "[Bad Target]" 33
      stop
    elseif dead
      snapshot 100
      headmsg "[..:: You Died ::..]"
      stop
    endif
    // Use the skill and process the result.
    useskill 'Provocation'
    waitfortarget 1500
    target! 'toDiscord'
    waitfortarget 1500
    target! 'self'
    pause 1000
    if not @injournal "succeeds"
      pause 4250
    else
      @clearjournal
      pause 9250
    endif
  endwhile
endwhile
