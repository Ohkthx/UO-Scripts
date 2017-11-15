// // // // // // // // // // // //
// Created by: Schism (d0x1p2)   //
// Date created: 08MAR2017       //
// Version: 1.2                  //
// // // // // // // // // // // // // // // //
// Features:                                 //
//  + Auto-movement to nearest cotton.       //
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
// // // // // // // // // // // // // // // //
// Begin our fresh start in case list updates.
@removelist 'cotton_types'
@removelist 'ranges'
@unsetalias 'cotton'
//
// Our list of types of cotton.
if not @listexists 'cotton_types'
  @createlist 'cotton_types'
  pushlist 'cotton_types' 0xc51
  pushlist 'cotton_types' 0xc52
  pushlist 'cotton_types' 0xc53
  pushlist 'cotton_types' 0xc54
endif
//
// Ranges to search for.
if not @listexists 'ranges'
  @createlist 'ranges'
  pushlist 'ranges' 1
  pushlist 'ranges' 2
  pushlist 'ranges' 4
  pushlist 'ranges' 8
  pushlist 'ranges' 16
endif
// // // // // // // // // // //
// ##  Main (Core) Loop  ##   //
// // // // // // // // // // //
while not dead 'self'
  // check the closest to furthest.
  for 0 in 'ranges'
    // Iterate our cotton types.
    for 0 in 'cotton_types'
      if @findtype cotton_types[] 'any' 'ground' 0 ranges[]
        @setalias 'cotton' 'found'
        while @findobject 'cotton' 'ground'
          // Move to our cotton and pick it.
          while not @inrange 'cotton' 1
            if @x 'cotton' > x 'self' and @y 'cotton' > y 'self'
              run 'Southeast'
            elseif @x 'cotton' < x 'self' and @y 'cotton' > y 'self'
              run 'Southwest'
            elseif @x 'cotton' > x 'self' and @y 'cotton' < y 'self'
              run 'Northeast'
            elseif @x 'cotton' < x 'self' and @y 'cotton' < y 'self'
              run 'Northwest'
            elseif @x 'cotton' > x 'self' and @y 'cotton' == y 'self'
              run 'East'
            elseif @x 'cotton' < x 'self' and @y 'cotton' == y 'self'
              run 'West'
            elseif @x 'cotton' == x 'self' and @y 'cotton' > y 'self'
              run 'South'
            elseif @x 'cotton' == x 'self' and @y 'cotton' < y 'self'
              run 'North'
            endif
            pause 110
          endwhile
          pause 100
          useobject! 'cotton'
          @unsetalias 'cotton'
        endwhile
      endif
    endfor
  endfor
endwhile
