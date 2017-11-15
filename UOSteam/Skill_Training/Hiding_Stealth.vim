// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 04JUL2017       //
// Version: 1.0                  //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + Place character inside a moongate      //
//   prior to starting the script.           //
//  + Modify line 29 for max Stealth desired //
// // // // // // // // // // // // // // // //
// Features:                                 //
//  + Trains Hiding and Steath.              //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
// // // // // // // // // // // // // // // //
// ## Main (Core) Loop ##  //
// // // // // // // // // //
while not dead 'self'
  // Train hiding until minimum is reached for stealth.
  if skill 'Hiding' < 80
    while skill 'Hiding' < 80
      useskill 'Hiding'
      pause 10500
    endwhile
  endif
  // Begin training stealth until we reach desired amount.
  if skill 'Stealth' < 100
    if @findtype 0xf6c 'any' 'ground'
      @setalias 'gate' 'found'
      // Use the moongate to travel for auto-hiding.
      if usetype 0xf6c 'any' 'ground'
        waitforgump 'gate' 1000
        replygump 'gate'  1 7
        pause 10000
        useskill 'Stealth'
        pause 600
      endif
    endif
    if @findtype 0xf6c 'any' 'ground'
      @setalias 'gate' 'found'
      // Use the moongate to travel for auto-hiding.
      if usetype 0xf6c 'any' 'ground'
        waitforgump 'gate' 1000
        replygump 'gate' 1 6
        pause 10000
        useskill 'Stealth'
        pause 600
      endif
    endif
  else
    // Lock our stealth, finish training our hiding to GM.
    setskill 'Stealth' 'locked'
    while skill 'Hiding' < 100
      useskill 'Hiding'
      pause 10500
    endwhile
    setskill 'Hiding' 'locked'
    stop
  endif
endwhile
