include <chassis.scad>
include <caster.scad>

module CheckLayout_3d() {
    axle_height = 0.16 + 0.47;

	color([1,0,0]) translate([0,0,0.25]) linear_extrude(height=thickness) BottomPlate_2d();

	color([0,1,0]) translate([0,thickness,0]) rotate([90,0,0]) linear_extrude(height=thickness) FrontPlate_2d(true);

	color([0,0,1]) translate([width-thickness,0,0]) rotate([90,0,90]) linear_extrude(height=thickness) LeftPlate_2d();

	color([1,1,0]) translate([width,length-thickness,0]) rotate([90,0,180]) linear_extrude(height=thickness) BackPlate_2d();

	color([1,0,1]) translate([0,0,0]) rotate([90,0,90]) linear_extrude(height=thickness) RightPlate_2d();

	color([0,1,1]) translate([0,0,height-thickness]) linear_extrude(height=thickness) TopPlate_2d();

	color([1,1,1]) {
			translate([thickness+0.8,length*wheel_location,axle_height+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness*wheel_stack,center=true) Wheel_2d();

			translate([width-thickness-0.8,length*wheel_location,axle_height+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness*wheel_stack,center=true) Wheel_2d();
	}

    translate([width/2,length-1,0.25]) rotate([0,180,90]) scale(1/25.4) BallCaster_3d(true);
}

CheckLayout_3d();
