// Branch values
branch_initial_width = 30;
branch_length = 170;
branch_width = 100;

// Hook values
hook_depth = 18;
branch_hook_stem_width = 10;
support_hook_stem_width = 4;
error_margin = 0.5;

// Support pillar values
support_pillar_width = 19;

// Constants
branch_thickness = 25.4/4;

// Computed values
a = branch_length;
b = branch_width;
c = branch_initial_width;
external_radius = (a*a+b*b)/(2*b);
internal_radius = (a*a+(b-c)*(b-c))/(2*(b-c));

module BranchHook() {
  translate([0,
             -(branch_initial_width-support_hook_stem_width-error_margin),
             -branch_thickness/2]){
    cube([hook_depth/2-error_margin,
          branch_initial_width-support_hook_stem_width-error_margin,
          branch_thickness]);
  }
  translate([hook_depth/2-error_margin,
             -branch_hook_stem_width,
             -branch_thickness/2]) {
    cube([hook_depth/2+error_margin,
          branch_hook_stem_width,
          branch_thickness]);
  }
}

*BranchHook();

module Branch() {
  translate([hook_depth,0,0]) {
    difference() {
      translate([0,-external_radius,0]) {
        cylinder(r=external_radius, h=branch_thickness, $fn=1000, center=true);
      }
      translate([-external_radius-1,-2*external_radius-1,-branch_thickness]) {
        cube([external_radius+1,2*external_radius+2,2*branch_thickness]);
      }
      translate([0,-branch_initial_width-internal_radius,0]) {
        cylinder(r=internal_radius, h=2*branch_thickness, $fn=1000, center=true);
      }
    }
  }
  BranchHook();
}

*Branch();

module TranslatedBranch() {
  rotate([90,0,0]) {
    translate([branch_thickness/2+support_pillar_width-hook_depth+error_margin,
               0,
               0]) {
      Branch();
    }
  }
}

*TranslatedBranch();

module CenterSupportHook() {
  translate([support_pillar_width+(branch_thickness-hook_depth)/2+error_margin,
             -branch_thickness/2,
             -branch_initial_width]) {
    cube([hook_depth/2-error_margin,
          branch_thickness,
          branch_initial_width-branch_hook_stem_width-error_margin]);
  }
  translate([branch_thickness/2,
             -branch_thickness/2,
             -branch_initial_width]) {
    cube([support_pillar_width-hook_depth/2+error_margin,
          branch_thickness,
          support_hook_stem_width]);
  }
}

*CenterSupportHook();

module CenterSupportPillar() {
  translate([branch_thickness/2,branch_thickness/2,-branch_initial_width]) {
    linear_extrude(height=branch_initial_width) {
      polygon([[0,0],[0,support_pillar_width],[support_pillar_width,0]],
              convexity = N);
    }
  }
}

*CenterSupportPillar();

module CenterSupportPillarAndHook() {
  CenterSupportPillar();
  CenterSupportHook();
}

*CenterSupportPillarAndHook();

module CenterSupport() {
  for (i=[0:3]) {
    rotate([0,0,90*i]) CenterSupportPillarAndHook();
  }
}

*CenterSupport();

module Mobile() {
  for (i=[0:3]) {
    rotate([0,0,90*i]) TranslatedBranch();
  }
  CenterSupport();
}

*Mobile();



// Sheet placement values
number_of_branches = 4;
number_of_hooks = 0;
sheet_width = 210;
sheet_height = 220;
piece_extra_thickness = 1;
branch_separation = 4;
hook_separation = 3;
top_corner_separation = 10;
branch_to_hook_separation = 5;

module ToCut() {
  for(i=[0:piece_extra_thickness]) {
    translate([0,0,i]) {
      if (number_of_branches > 0) {
        for (j=[0:number_of_branches-1]) {
          translate([0,-(branch_initial_width+branch_separation)*j,0]) Branch();
        }
      }
      translate([0,
                 -number_of_branches*(branch_initial_width+branch_separation) - branch_to_hook_separation,
                 0]) {
        if (number_of_hooks > 0) {
          for(j=[0:number_of_hooks-1]) {
            translate([(support_pillar_width+hook_separation)*j,0,0]) {
              rotate([-90,0,0]) {
                translate([0,0,0]) CenterSupportHook();
              }
            }
          }
        }
      }
    }
  }
}

*color("gray") translate([0,-sheet_height,0]) cube([sheet_width,sheet_height,1]);
*translate([top_corner_separation,-top_corner_separation,0]) ToCut();


gear_thickness=25.4*3/4;
gear_tooth_height=gear_thickness/2;
gear_support_thickness=gear_thickness-gear_tooth_height;
gear_tooth_vertical_offset=2;
gear_tooth_thickness=20;
gear_radius=50;
tooths_per_gear=12;
bolt_diameter=10;

// TODO: Give this tooth some room to move.
module GearTooth() {
  translate([0,0,gear_tooth_height/2]) {
    intersection() {
      difference() {
        cylinder(h=gear_tooth_height, r=gear_radius, $fn=100, center=true);
        cylinder(h=gear_tooth_height+1,
                 r=gear_radius-gear_tooth_thickness,
                 $fn=100,
                 center=true);
      }
      linear_extrude(height=gear_tooth_height, center=true) {
        polygon([[0,0],
                 [-gear_radius*tan(90/tooths_per_gear),gear_radius],
                 [gear_radius*tan(90/tooths_per_gear),gear_radius]],
                paths=[[0,1,2]]);
      }
    }
  }
}

*GearTooth();

module GearConnectionPiece() {
  difference() {
    cylinder(h=gear_support_thickness, r=gear_radius, $fn=100);
    translate([0,0,-1]) {
      cylinder(h=gear_support_thickness+2, d=bolt_diameter, $fn=100);
    }
    translate([0,0,gear_support_thickness-gear_tooth_vertical_offset]) {
      cylinder(h=gear_tooth_vertical_offset+1,
               r=gear_radius-gear_tooth_thickness,
               $fn=100);
    }
  }
  translate([0,0,gear_support_thickness]) {
    for(i=[0:tooths_per_gear-1]) {
      rotate(a=[0,0,i*360/tooths_per_gear]) {
        GearTooth();
      }
    }
  }
}

*GearConnectionPiece();

module GearCenterPiece() {
  difference() {
    union() {
      cylinder(h=gear_tooth_vertical_offset,
               r=gear_radius-gear_tooth_thickness,
               $fn=100);
      cylinder(h=gear_tooth_height+gear_tooth_vertical_offset,
               r=gear_radius-gear_tooth_thickness-1,
               $fn=100);
    }
    translate([0,0,-1]) {
      cylinder(h=gear_tooth_height+gear_tooth_vertical_offset+2,
               d=bolt_diameter,
               $fn=100);
    }
  }
}

*GearCenterPiece();

module GearConnection() {
  color("red") translate([0,0,-gear_thickness+gear_tooth_height/2]) {
    GearConnectionPiece();
  }
  translate([0,0,-gear_tooth_height/2-gear_tooth_vertical_offset]) {
    GearCenterPiece();
  }
  color("green") translate([0,0,gear_thickness-gear_tooth_height/2]) {
    rotate([180,0,180/tooths_per_gear]) GearConnectionPiece();
  }
}

GearConnection();
