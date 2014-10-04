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
translate([top_corner_separation,-top_corner_separation,0]) ToCut();
