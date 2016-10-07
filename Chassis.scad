res = 100;

isThick = true; //Whether using 3mm or 6mm ply.

thickness = 0.25;

kerf = 0.00;
kerf_2 = kerf / 2;

width = 7;
length = 6;
height = 4;

module InterlockingPlate(width, height, botT, topT, leftT, rightT, bottomOffset=0) {
	numBT = width*2;
	numLR = height*2;
	difference() {
		square([width,height]);
		union() {
			if(bottomOffset == 0) for(i=[width*botT/numBT:width*2/numBT:width-.01]) translate([i,-0.01,0]) square([width/numBT-kerf,thickness-kerf_2+.01]);
			else for(i=[width*botT/numBT:width*2/numBT:width-.01]) translate([i,bottomOffset+kerf_2,0]) square([width/numBT-kerf,thickness-kerf+.01]);
			for(i=[width*topT/numBT:width*2/numBT:width-.01]) translate([i,height-thickness+kerf_2,0]) square([width/numBT-kerf,thickness+.01]);
			for(i=[height*leftT/numLR:height*2/numLR:height-.01]) translate([-0.01,i,0]) square([thickness+.01-kerf_2,height/numLR-kerf]);
			for(i=[height*rightT/numLR:height*2/numLR:height-.01]) translate([width-thickness+kerf_2,i,0]) square([thickness+.01,height/numLR-kerf]);
		}
	}
}

module FrontPlate_2d(is_square) {
	eye_size = 1.26;
	difference() {
		InterlockingPlate(width,height,0,0,0,1,0.25);
		union() {
			if(is_square) {
				translate([width*.3-eye_size/2,height/2]) square([eye_size, eye_size]);
				translate([width*.7-eye_size/2,height/2]) square([eye_size, eye_size]);
			} else {
				translate([width*.3,height/2+eye_size/2]) circle(eye_size/2, $fn=res);
				translate([width*.7,height/2+eye_size/2]) circle(eye_size/2, $fn=res);
			}
			translate([width/2,height*.45]) square([.32,.32],center=true);
		}
	}
}

module LeftPlate_2d() {
	difference() {
		InterlockingPlate(length,height,0,0,0,1,0.25);
		translate([length/2,height/2]) circle(.093, $fn=res);
	}
}

module RightPlate_2d() {
	difference() {
		InterlockingPlate(length,height,0,1,1,0,0.25);
		translate([length/2,height/2]) circle(.093, $fn=res);
	}
}

module BackPlate_2d() {
	difference() {
		InterlockingPlate(width,height,0,1,0,1,0.25);
		union() {
			translate([width/2-.495, height*.8]) circle(.32, $fn=res);
			translate([width/2+.495, height*.8]) circle(.32, $fn=res);
		}
	}
}

module MotorMount_2d() {
	motor_mount_length = 1.25;
	motor_mount_width = 0.85;
	motor_mount_rad = 0.065;
	translate([-motor_mount_length/2,-motor_mount_width/2,0]) union() {
		circle(motor_mount_rad, $fn=res);
		translate([motor_mount_length,0,0]) circle(motor_mount_rad, $fn=res);
		translate([0,motor_mount_width,0]) circle(motor_mount_rad, $fn=res);
		translate([motor_mount_length,motor_mount_width,0]) circle(motor_mount_rad, $fn=res);
	}
}

module BottomPlate_2d() {
	wall_dist = 2.1;
	union() {
		difference() {
			InterlockingPlate(width,length,1,0,1,1);
			union() {
				translate([wall_dist,length/3,0]) MotorMount_2d();
				translate([width-wall_dist,length/3]) MotorMount_2d();
				translate([wall_dist-1.725,length/12]) square([0.6,length/2]);
				translate([width-wall_dist+1.125,length/12]) square([0.6,length/2]);
				translate([width/2,length*4/5]) circle(0.25, $fn=res);
				translate([width/2+0.5,length*4/5]) circle(0.125, $fn=res);
			}
		}
		//translate([width-thickness,0]) square([thickness,thickness]);
		//translate([0,length-thickness]) square([thickness,thickness]);
	}
}

module ServoMount_2d() {
	square([0.475,0.895], center=true);
	translate([0,0.895/2+0.1]) circle(.036, $fn=res);
	translate([0,-0.895/2-0.1]) circle(.036, $fn=res);
	translate([0,0.895/2+0.3]) square([.32,.125], center=true);
}

module TopPlate_2d() {
	union() {
		difference() {
			InterlockingPlate(width,length,1,1,0,1);
			union() {
				translate([width-.75,length-.75]) circle(0.39,$fn=res);
				translate([width/7,length*.18]) ServoMount_2d();
				translate([6*width/7,length*.18]) ServoMount_2d();
				translate([width/2,length*.8]) circle(.036, $fn=res);
				translate([width/2,length*.9]) circle(.093, $fn=res);
				translate([width/2,length*.1]) circle(.093, $fn=res);
				translate([0.75,length-.75]) circle(.125, $fn=res);
				translate([0.75,length-1.25]) circle(.125, $fn=res);
			}
		}
		square([thickness,thickness]);
		translate([width-thickness,0]) square([thickness,thickness]);
	}
}

module Wheel_2d() {
	diam = 2.625;
	screw_diam = 0.08;
	difference() {
		circle(diam/2, $fn=res);
		union() {
			translate([0.25,0,0]) circle(screw_diam/2, $fn=res);
			translate([-0.25,0,0]) circle(screw_diam/2, $fn=res);
			translate([0,0.25,0]) circle(screw_diam/2, $fn=res);
			translate([0,-0.25,0]) circle(screw_diam/2, $fn=res);
		}
	}
}

module LaserCutterLayout_2d() {
	FrontPlate_2d(true);
	translate([width+0.1,0]) LeftPlate_2d();
	translate([width+length+0.2,0]) BackPlate_2d();
	translate([0,height+0.1]) TopPlate_2d();
	translate([width+0.1,height+0.1]) RightPlate_2d();
	translate([width+length+0.2,height+0.1]) BottomPlate_2d();
}

module CheckLayout_3d() {
	color([1,0,0]) translate([0,0,0.25]) linear_extrude(height=thickness) BottomPlate_2d();
	color([0,1,0]) translate([0,thickness,0]) rotate([90,0,0]) linear_extrude(height=thickness) FrontPlate_2d(true); 
	color([0,0,1]) translate([width-thickness,0,0]) rotate([90,0,90]) linear_extrude(height=thickness) LeftPlate_2d();
	color([1,1,0]) translate([width,length-thickness,0]) rotate([90,0,180]) linear_extrude(height=thickness) BackPlate_2d();
	color([1,0,1]) translate([0,0,0]) rotate([90,0,90]) linear_extrude(height=thickness) RightPlate_2d();
	color([0,1,1]) translate([0,0,4-thickness]) linear_extrude(height=thickness) TopPlate_2d(); 
	color([1,1,1]) {
			translate([.55,length/3,0.56+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness) Wheel_2d();
			translate([width-thickness-.55,length/3,0.56+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness) Wheel_2d();
	}
}

//CheckLayout_3d();
LaserCutterLayout_2d();
