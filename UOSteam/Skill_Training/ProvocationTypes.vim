// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 28NOV2017       //
// Version: 1.0                 //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + Attempts to provocate two enemies      //
//   on their type.                          //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
// // // // // // // // // // // // // // // //
@clearignorelist
@removelist 'instrumentlist'
@removelist 'targetTypes'
@removelist 'toProvo'
@unsetalias 'targetMob'
// // // // // //
// ## LISTS ## //
// // // // // //
// Our types to look for.
if not @listexists 'targetTypes'
  @createlist 'targetTypes'
  @pushlist 'targetTypes' 0x4e // Ancient Lich
  @pushlist 'targetTypes' 0x3b // Dragon
  @pushlist 'targetTypes' 0x3d // Drake
endif
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
// This list will be auto-populated.
if not @listexists 'toProvo'
  @createlist 'toProvo'
endif
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
// Look for our mobs based on types.
while list 'toProvo' < 2
  for 0 in 'targetTypes'
    if @findtype targetTypes[] 'any' 'ground'
      @setalias 'targetMob' 'found'
      // Add it to our list if it doesnt exist already.
      if not @inlist 'toProvo'
        headmsg "[ Found: Target ]" 33 'targetMob'
        @pushlist 'toProvo' 'targetMob'
        @ignoreobject 'targetMob'
        break
      endif
    endif
  endfor
endwhile
// Provocate the two targets.
useskill 'Provocation'
for 0 in 'toProvo'
  waitfortarget 1000
  target! toProvo[]
endfor