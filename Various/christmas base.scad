wood_thickness = 3.5;
star_side_top = 28;
star_side_height = sqrt(42.2*42.2-100);
base_height_from_star_tip = 20;
stem_lenght = 100;
stem_diameter = 2*wood_thickness;
hole_diameter = 2;
hole_height = 12;

module FullStarSide() {
	linear_extrude(height=wood_thickness, center=true, convexity=10, twist=0)
	polygon(points=[[0,0],[star_side_top/2,star_side_height],[-star_side_top/2,star_side_height]], paths=[[0,1,2]]);
}

module StarSide() {
	difference() {
		FullStarSide();
		translate([0,8.25,0]) scale([1,1,1.5]) FullStarSide();
	}
}
translate([0, 0, base_height_from_star_tip]) rotate([270, 0, 0]) color("green") union() {
	difference() {
		union() {
			scale([1,1,2]) translate([0,-8.25,0]) FullStarSide();
			translate([0, 3, 0]) rotate([90,0,0]) cylinder(h=stem_lenght, r=stem_diameter/2, $fn=100);
		}
		FullStarSide();
		translate([-star_side_top/2-1,base_height_from_star_tip,-wood_thickness/2-100]) cube([star_side_top+2,star_side_height+2,wood_thickness+200]);
		translate([0,hole_height,0]) cylinder(h=100, r=hole_diameter/2, center=true, $fn=100);
	}
}
*color("BurlyWood") StarSide();
*color("red") translate([0,hole_height,0]) cylinder(h=100, r=hole_diameter/2, center=true, $fn=100);

