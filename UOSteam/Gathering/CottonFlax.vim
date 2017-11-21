// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 08MAR2017       //
// Version: 1.3                  //
// // // // // // // // // // // // // // // //
// Features:                                 //
//  + Auto-movement to nearest cotton\flax   //
// // // // // // // // // // // // // // // //
// Notes:                                    //
//  + None.                                  //
// // // // // // // // // // // // // // // //
// Changes:                                  //
//  v1.0                                     //
//   + Initial release.                      //
//  v1.1                                     //
//   + Added a range check to get nearest.   //
//  v1.2                                     //
//   + Modified removing serial.             //
//  v1.3                                     //
//   + Small restructuringm using ranges     //
//    properly.                              //
//   + Now collecting flax.                  //
// // // // // // // // // // // // // // // //
// Create our fresh start. 
@removelist 'pick_types'
@removelist 'range'
@unsetalias 'toPick'
//
// List of types of Cotton and Flax to look for.
if not @listexists 'pick_types'
  @createlist 'pick_types'
  @pushlist 'pick_types' 0xc51  // Cotton
  @pushlist 'pick_types' 0xc52  // Cotton
  @pushlist 'pick_types' 0xc53  // Cotton
  @pushlist 'pick_types' 0xc54  // Cotton
  @pushlist 'pick_types' 0x1a99 // Flax
  @pushlist 'pick_types' 0x1a9a // Flax
  @pushlist 'pick_types' 0x1a9b // Flax
endif
//
// Our ranges we will search in.
if not @listexists 'range'
  @createlist 'range'
  pushlist 'range' 1
  pushlist 'range' 2
  pushlist 'range' 4
  pushlist 'range' 8
  pushlist 'range' 16
endif
//
// // // // // // // // 
// ##  Main Loop  ## //
// // // // // // // //
while not dead 'self'
  if not @findobject 'toPick'
    for 0 in 'range'
      for 0 in 'pick_types'
        // Find the closest cotton or flax.
        if @findtype pick_types[] 'any' 'ground' 0 range[]
          @setalias 'toPick' 'found'
          headmsg "[Picking]" 33 'toPick'
          break
        endif
      endfor
      if @findalias 'toPick'
        break
      endif
    endfor
  endif
  // If we have something to pick... move to it.
  if @findobject 'toPick'
    @clearjournal
    while not @inrange 'toPick' 1
      if @x 'toPick' > x 'self' and @y 'toPick' > y 'self'
        run 'Southeast'
      elseif @x 'toPick' < x 'self' and @y 'toPick' > y 'self'
        run 'Southwest'
      elseif @x 'toPick' > x 'self' and @y 'toPick' < y 'self'
        run 'Northeast'
      elseif @x 'toPick' < x 'self' and @y 'toPick' < y 'self'
        run 'Northwest'
      elseif @x 'toPick' > x 'self' and @y 'toPick' == y 'self'
        run 'East'
      elseif @x 'toPick' < x 'self' and @y 'toPick' == y 'self'
        run 'West'
      elseif @x 'toPick' == x 'self' and @y 'toPick' > y 'self'
        run 'South'
      elseif @x 'toPick' == x 'self' and @y 'toPick' < y 'self'
        run 'North'
      endif
      pause 120
    endwhile
    pause 100
    useobject! 'toPick'
    pause 150
    // Uh oh! Doesn't want to be picked- keep trying.
    if @injournal "seems defiant"
      @clearjournal
      while @findobject 'toPick' 'any' 'ground'
        useobject! 'topick'
        pause 600
      endwhile
    endif
    // Unset the alias and look for the next.
    @unsetalias 'toPick'
    pause 100
  endif
endwhile

