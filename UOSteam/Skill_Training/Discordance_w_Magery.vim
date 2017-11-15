// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 16AUG2016       //
// Version: 1.0                  //
// // // // // // // // // // // // // // // // // // //
// About:                                             // 
//  Designed to train discordance on a specified      //
//  creature and use your magery skill to break Line  //
//  of Sight.                                         //
// // // // // // // // // // // // // // // // // // //
// Notes:                        //
//  Requires Journal Scanning.   //
// // // // // // // // // // // //
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
// Find/Select our target.
if not @findobject 'todiscord'
  headmsg "Select object to discord"
  promptalias 'todiscord'
  if not @findobject 'todiscord'
    headmsg "[Bad Target]" 33
    stop
  endif
endif
//
// Scan our instruments and find one to use.
for 0 to 'instrumentlist'
  while @findtype instrumentlist[]
    @setalias 'instrument' 'found'
    useobject! 'instrument'
    while @findobject 'instrument' 'any' 'backpack'
      // Uses Discordance and targets assigned to 'todiscord'.
      useskill 'Discordance'
      autotargetobject 'todiscord'
      pause 1000
      if @injournal 'jarring music' 'system'
        @clearjournal
        while not hidden 'self'
          cast "Invisibility"
          waitfortarget 5000
          target! 'self'
          pause 2000
        endwhile
        pause  16500
      elseif @injournal 'already in discord' 'system'
        @clearjournal
        while not hidden 'self'
          cast "Invisibility"
          waitfortarget 5000
          target! 'self'
          pause 2000
        endwhile
        pause  16500
      endif
    endwhile
  endwhile
endfor