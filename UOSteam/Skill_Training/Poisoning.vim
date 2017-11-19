// // // // // // // // // // //
// Created by: Schism         //
// Date created: 16NOV2017    //
// Version: 1.1               //
// // // // // // // // // // // // // // // // //
// Notes:                                       //
//  +  When prompted for kegs, select all you   //
//   that you wish to add. Once you've done     //
//   that- reselect a keg so the script knows   //
//   that you are finished.                     //
//                                              //
//  + Make sure you're only using kegs you have //
//   the skill for. Otherwise it might be       //
//   wasted.                                    //
// // // // // // // // // // // // // // // // //
// Features:                                    //
//  + Dynamic keg adding.                       //
//  + Exhausts kegs, moves to next till none    //
//   remain.                                    //
// // // // // // // // // // // // // // // // //
// Check to see if we have bottles.
if not @findtype 0xf0e 0 'backpack'
  headmsg "[No empty bottles]" 33
  stop
else
  @setalias 'poisonBottle'
endif
//
// Our kegs
@removelist 'kegs'
if not @listexists 'kegs'
  @createlist 'kegs'
endif
// Create our list of keys.
headmsg "Select all poison kegs." 33
while not dead
  promptalias 'poisonKeg'
  if not @findobject 'poisonKeg'
    headmsg "[None Selected]" 33
    stop
  endif
  if graphic 'poisonKeg' != 0x1940
    headmsg "[None keg selected]" 33
  elseif not @inlist 'kegs' 'poisonKeg'
    headmsg "Select another to add." 33
    @pushlist 'kegs' 'poisonKeg'
  else
    headmsg "Duplicate keg recognized. All kegs selected added." 33
    break
  endif
endwhile
// Check to see if we have a weapon.
if not @findobject 'toPoison'
  headmsg "Select a weapon." 33
  promptalias 'toPoison'
  if not @findobject 'toPoison'
    headmsg "[None Selected]" 33
    stop
  endif
endif
// // // /// // // //
// ## MAIN LOOP ## //
// // // /// // // //
while not dead
  for 0 in 'kegs'
    while @findobject kegs[]
      useobject! kegs[]
      // Wait for our bottle to exist in our inventory.
      while not @findtype 0xf0a 'any' 'backpack'
        if @injournal "keg is empty"
          @clearjournal
          headmsg "[Keg is empty]" 33
          break
        endif
      endwhile
      @setalias 'poisonBottle' 'found'
      useskill 'poisoning'
      waitfortarget 2000
      target! 'poisonBottle'
      waitfortarget 2000
      target! 'toPoison'
      pause 6250
    endwhile
  endfor
endwhile
// Clean up
@unsetalias 'found'
@unsetalias 'poisonBottle'
@unsetalias 'poisonKeg'
@unsetalias 'toPoison'