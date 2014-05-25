InchesToMm = 25.4;

// Square steel tubes

// 1" in side, 0.065" in thickness, max length = 8 feet
SquareSteelTube1_MaxLegth = 96 * InchesToMm;
SquareSteelTube1_Width = InchesToMm;
SquareSteelTube1_Thickness = 0.065 * InchesToMm;
module SquareSteelTube1(length) {
  if (length < 0 || length > SquareSteelTube1_MaxLegth) {
    echo ("ERROR: Cannot have a 1 in square stell tube of length ", length);
  } else {
    _SquareSteelTube(SquareSteelTube1_Width,
                     SquareSteelTube1_Thickness,
                     length);
  }
}

// 3/4" in side, 0.065" in thickness, max length = 8 feet
SquareSteelTube3_4_MaxLegth = 96 * InchesToMm;
SquareSteelTube3_4_Width = 0.75 * InchesToMm;
SquareSteelTube3_4_Thickness = 0.065 * InchesToMm;
module SquareSteelTube3_4(length) {
  if (length < 0 || length > SquareSteelTube3_4_MaxLegth) {
    echo ("ERROR: Cannot have a 3/4 in square stell tube of length ", length);
  } else {
    _SquareSteelTube(SquareSteelTube3_4_Width,
                     SquareSteelTube3_4_Thickness,
                     length);
  }
}

// 1/2" in side, 0.065" in thickness, max length = 6 feet
SquareSteelTube1_2_MaxLegth = 96 * InchesToMm;
SquareSteelTube1_2_Width = 0.5 * InchesToMm;
SquareSteelTube1_2_Thickness = 0.065 * InchesToMm;
module SquareSteelTube1_2(length) {
  if (length < 0 || length > SquareSteelTube1_2_MaxLegth) {
    echo ("ERROR: Cannot have a 1/2 in square stell tube of length ", length);
  } else {
    _SquareSteelTube(SquareSteelTube1_2_Width,
                     SquareSteelTube1_2_Thickness,
                     length);
  }
}


module _SquareSteelTube(width, thickness, length) {
  difference() {
    cube([width, width, length]);
    translate([thickness, thickness, -1]) {
      cube([width - 2 * thickness, width - 2 * thickness, length + 2]);
    }
  }
}

