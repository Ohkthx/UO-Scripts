// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 27JUL2016       //
// Version: 1.0                  //
// // // // // // // // // // // // // // // // // // //
// About:                                             // 
//  Designed to train discordance on your mount.      //
//  Be sure to check the "Notes" portion to work      //
//  correctly.                                        //
// // // // // // // // // // // // // // // // // // //
// Notes:                                    //
//   + Requires Journal Scanning.            //
//   + Be sure to assign 'mount' in:         //
//    'general' -> 'combat' -> 'dismount'    //
// // // // // // // // // // // // // // // //
// Changes:                //
//  v1.0 - Initial release //
// // // // // // // // // //
// Preps the journal.
@clearjournal
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
//
// Select an instrument automatically to use.
for 0 to 'instrumentlist'
  while @findtype instrumentlist[]
    @setalias 'instrument' 'found'
    useobject 'instrument'
    while @findobject 'instrument' 'any' 'backpack'
      // Dismounts self if mounted.
      if mounted 'self'
        togglemounted
      endif
      // Uses Discordance and targets assigned 'mount'.
      useskill 'Discordance'
      autotargetobject 'mount'
      pause 600
      if @injournal 'jarring music' 'system'
        @clearjournal
        while not mounted 'self'
          togglemounted
          pause 600
        endwhile
        pause 16500
      elseif @injournal 'already in discord' 'system'
        @clearjournal
        while not mounted 'self'
          togglemounted
          pause 600
        endwhile
        pause 16500
      else
        pause 3600
      endif
    endwhile
  endwhile
endfor