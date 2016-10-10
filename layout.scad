include <chassis.scad>

module LaserCutterLayoutOne_2d() {
	translate([0.2,0.2]) FrontPlate_2d(true);
    translate([0.2,height+0.4]) BackPlate_2d();

	translate([width+0.4,0.2]) LeftPlate_2d();
	translate([width+0.4,height+0.4]) RightPlate_2d();

    translate([width+length+0.6+wheel_diameter/2,0.2+wheel_diameter/2]) Wheel_2d();
    translate([24-wheel_diameter/2-0.2,wheel_diameter+1]) Wheel_2d();
    if (wheel_stack > 1) translate([width+length+0.6+wheel_diameter/2,0.2+wheel_diameter/2+4.6]) Wheel_2d();
    if (wheel_stack > 1) translate([24-wheel_diameter/2-0.2,wheel_diameter+5.6]) Wheel_2d();
}

module LaserCutterLayoutTwo_2d() {
	translate([0.2,0.2]) TopPlate_2d();
	translate([width+0.4,0.2]) BottomPlate_2d();
}

LaserCutterLayoutOne_2d();
//LaserCutterLayoutTwo_2d();
