res = 100;

thickness = 0.25;

kerf = 0.00;
kerf_2 = kerf / 2;

width = 10;
length = 8;
height = 5;

wheel_diameter = 3;
screw_diameter = 0.125;
wheel_stack = 1;
wheel_location = 1/3.8;

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
	difference() {
		InterlockingPlate(width,height,0,0,0,1,0.25);
		union() {
			translate([width*.28,height/1.6]) SonarEye_2d();
			translate([width*.72,height/1.6]) SonarEye_2d(true);
		} translate([width/2,height*.45]) square([.32,.32],center=true);
	}
}

module SonarEye_2d(second) {
    eye_size = 2.2;
    dual_supports = false;
    support_angle = 20;
    union() {
        difference() {
            circle(eye_size/2, $fn=res);
            circle(eye_size/2.3, $fn=res);
            rotate((second?-1:1)*support_angle) square([eye_size,eye_size/8],center=true);
            if (dual_supports) rotate(90+(second?-1:1)*support_angle) square([eye_size,eye_size/8],center=true);
        } PingSensor_2d();
    }
}

module LeftPlate_2d() {
	difference() {
        InterlockingPlate(length,height,0,0,0,1,0.25);
        translate([length/2,height*.8]) PingSensor_2d();
    }
}

module RightPlate_2d() {
    difference() {
        InterlockingPlate(length,height,0,1,1,0,0.25);
        translate([length/2,height*.8]) PingSensor_2d();
    }
}

module BackPlate_2d() {
	difference() {
		InterlockingPlate(width,height,0,1,0,1,0.25);
        translate([width/2,height*.8]) PingSensor_2d();
	}
}

module PingSensor_2d() {
    union() {
		translate([-0.495, 0]) circle(.315, $fn=res);
		translate([0.495, 0]) circle(.315, $fn=res);
	}
}

module MotorMount_2d() {
	motor_mount_length = 2.52;
    motor_mount_width = 0.5;
    
	translate([motor_mount_width/2,-motor_mount_length/2]) union() {
		circle(screw_diameter/2, $fn=res);
        translate([0,motor_mount_length]) circle(screw_diameter/2, $fn=res);
	}
}

module BottomPlate_2d() {
	wall_dist = 1.75;
    axle_length = 0.7;
    wheel_width = 0.75;

	union() {
		difference() {
			InterlockingPlate(width,length,1,0,1,1);
			union() {
				translate([wall_dist,length*wheel_location,0]) MotorMount_2d();
				translate([width-wall_dist,length*wheel_location]) rotate(180) MotorMount_2d();
                
				translate([wall_dist-axle_length,length*wheel_location]) square([wheel_width,wheel_diameter], center=true);
				translate([width-wall_dist+axle_length,length*wheel_location]) square([wheel_width,wheel_diameter], center=true);
			}
		}
	}
}

module TopPlate_2d() {
    InterlockingPlate(width,length,1,1,0,1);
}

module Wheel_2d() {
    bolt_circle = 0.63;
    shaft_diameter = 0.25;
    
    bump_angle = 5;
    bump_scale = 0.0125;
    
	difference() {
		circle(wheel_diameter/2, $fn=res);
        
        for (i=[0:bump_angle:360-bump_angle]) {
            translate([wheel_diameter*cos(i)/2,wheel_diameter*sin(i)/2]) circle(bump_scale*wheel_diameter, $fn=res);
        }
        
        translate([bolt_circle/2,0]) circle(screw_diameter/2,$fn=res);
        translate([-bolt_circle/2,0]) circle(screw_diameter/2,$fn=res);
        translate([0,bolt_circle/2]) circle(screw_diameter/2,$fn=res);
        translate([0,-bolt_circle/2]) circle(screw_diameter/2,$fn=res);
        circle(shaft_diameter/2,$fn=res);
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
	color([0,1,1]) translate([0,0,height-thickness]) linear_extrude(height=thickness) TopPlate_2d(); 
	color([1,1,1]) {
			translate([.55,length/3,0.56+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness) Wheel_2d();
			translate([width-thickness-.55,length/3,0.56+.25+thickness]) rotate([90,0,90]) linear_extrude(height=thickness) Wheel_2d();
	}
}

CheckLayout_3d();
//LaserCutterLayout_2d();
