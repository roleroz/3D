include <metals.scad>
include <sorting_box.scad>

// Select the tube sizes that we will use through the design.
//
// Structural tubes are 3/4 in, and railings are 1/2 in.
Support_StructuralBar_Width = SquareSteelTube3_4_Width;
module Support_StructuralBar(length) { SquareSteelTube3_4(length); }
Support_RailBar_Width = SquareSteelTube1_2_Width;
module Support_RailBar(length) { SquareSteelTube1_2(length); }


// Set the parameters of the design
Support_NumberOfSortingBoxesPerColumn = 2;
//Support_NumberOfSortingBoxesPerColumn = 20;
Support_NumberOfSortingBoxColumns = 2;
Support_HorizontalDistanceBetweenRailingsTolerance = 4;
Support_VerticalClearanceFirstBox = 45;
Support_VerticalClearanceOtherBoxes = 60;
Support_RailingDepth = SortingBox_Top_Depth + 10;
Support_StructuralLenghtInShelf = 150;

// Computed variables;
Support_HorizontalDistanceBetweenRailings =
    SortingBox_Base_Width + Support_HorizontalDistanceBetweenRailingsTolerance;
Support_DistanceBetweenStructuralBars =
    Support_HorizontalDistanceBetweenRailings + 2 * Support_RailBar_Width;
Support_InternalHeight =
    Support_NumberOfSortingBoxesPerColumn *
        Support_VerticalClearanceOtherBoxes + 5;
Support_StructuralColumns_Height =
    Support_InternalHeight +
        Support_StructuralBar_Width +
        Support_StructuralLenghtInShelf;
Support_ExternalWidth =
    Support_NumberOfSortingBoxColumns *
        (Support_DistanceBetweenStructuralBars + Support_StructuralBar_Width) +
        Support_StructuralBar_Width;
Support_DepthBetweenStructuralBars =
    Support_RailingDepth - 2 * Support_StructuralBar_Width;


// Do the actual design
module SupportStructure() {
  for (i = [0 : Support_NumberOfSortingBoxColumns]) {
    translate([i * (Support_DistanceBetweenStructuralBars +
                    Support_StructuralBar_Width),
               0,
               0]) {
      for (j = [0 : 1]) {
        translate([0,
                   j * (Support_DepthBetweenStructuralBars +
                        Support_StructuralBar_Width),
                   -Support_StructuralLenghtInShelf]) {
          Support_StructuralBar(Support_StructuralColumns_Height);
        }
      }
      translate([0,
                 Support_StructuralBar_Width,
                 Support_StructuralBar_Width]) {
        rotate([-90, 0, 0]) {
          Support_StructuralBar(Support_DepthBetweenStructuralBars);
        }
        translate([0,
                   0,
                   Support_InternalHeight + Support_StructuralBar_Width]) {
          rotate([-90, 0, 0]) {
            Support_StructuralBar(Support_DepthBetweenStructuralBars);
          }
        }
      }
      if (i < Support_NumberOfSortingBoxColumns) {
        for (j = [0 : 1]) {
          rotate([0, 90, 0]) {
            translate([-Support_StructuralBar_Width,
                       j * (Support_DepthBetweenStructuralBars +
                            Support_StructuralBar_Width),
                       Support_StructuralBar_Width]) {
              Support_StructuralBar(Support_DistanceBetweenStructuralBars);
            }
          }
        }
      }
    }
  }
  translate([0, 0, Support_InternalHeight + 2 * Support_StructuralBar_Width]) {
    for (i = [0 : 1]) {
      translate([0,
                 i * (Support_DepthBetweenStructuralBars +
                      Support_StructuralBar_Width),
                 0]) {
        rotate([0,90, 0]) { 
          Support_StructuralBar(Support_ExternalWidth);
        }
      }
    }
  }
}

module RailingColumn() {
  for (i = [0 : Support_NumberOfSortingBoxesPerColumn - 1]) {
    translate([0,
               0,
               Support_VerticalClearanceFirstBox +
                   i * Support_VerticalClearanceOtherBoxes]) {
      rotate([-90, 0, 0]) {
        Support_RailBar(Support_RailingDepth);
      }
    }
  }
}

module Railings() {
  for (i = [0 : Support_NumberOfSortingBoxColumns - 1]) {
    translate([Support_StructuralBar_Width +
                   i * (Support_DistanceBetweenStructuralBars +
                        Support_StructuralBar_Width),
               0,
               0]) {
      RailingColumn();
      translate([Support_HorizontalDistanceBetweenRailings +
                     Support_RailBar_Width,
                 0,
                 0]) {
        RailingColumn();
      }
    }
  }
}

module BoxColumn() {
  for (i = [0 : Support_NumberOfSortingBoxesPerColumn - 1]) {
    translate([0,
               0,
               Support_VerticalClearanceFirstBox +
                   i * Support_VerticalClearanceOtherBoxes]) {
      SortingBox();
    }
  }
}

module Boxes() {
  for (i = [0 : Support_NumberOfSortingBoxColumns - 1]) {
    translate([Support_StructuralBar_Width +
                   i * (Support_DistanceBetweenStructuralBars +
                        Support_StructuralBar_Width) +
                   Support_RailBar_Width +
                   Support_HorizontalDistanceBetweenRailingsTolerance / 2,
               0,
               0]) {
      BoxColumn();
    }
  }
}

module Support() {
  SupportStructure();
  translate([0, 0, Support_StructuralBar_Width]) {
    Railings();
    % Boxes();
  }
}

Support();

