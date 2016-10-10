res = 100;
screw_diameter = 0.125;

// uses 3/8" ball bearing
module BallCaster_3d(show_ball) {
    m_screw_diameter = screw_diameter * 25.4;

    deck_height = 13;
    ball_diameter = 10;
    ball_tolerance = 0.4;
    wall_thickness = 2.5;

    gap_width = ball_diameter / 3;
    base_thickness = 4;
    pedistal_width = ball_diameter + wall_thickness * 2;

    baseWidth = 25.4;
    baseHeight = deck_height-ball_diameter/2;


    rotate([0, 0, 90]) difference() {
        union() {
            translate([-baseWidth/2, -wall_thickness - m_screw_diameter / 2, 0]) cube([baseWidth, wall_thickness * 2 + m_screw_diameter, base_thickness]);

            translate([baseWidth / 2, 0, 0]) cylinder(base_thickness, m_screw_diameter / 2 + wall_thickness, m_screw_diameter / 2 + wall_thickness, $fn=res);
            translate([-baseWidth / 2, 0, 0]) cylinder(base_thickness, m_screw_diameter / 2 + wall_thickness, m_screw_diameter / 2 + wall_thickness, $fn=res);

            translate([0, 0, 0]) cylinder(baseHeight-2, pedistal_width/2, pedistal_width/2, $fn=res);

            difference(){
                translate([0, 0, baseHeight-2]) sphere(pedistal_width/2,$fn=res);
                translate([0, 0, baseHeight+ball_diameter/2 - ball_diameter/5]) cylinder(25, 25, 25, $fn=res);
                translate([0, 0, -12]) cylinder(12, 25, 25, $fn=res);
            };
        }

        translate([0,0,baseHeight+ball_tolerance]) sphere(ball_diameter/2+ball_tolerance,$fn=res);
        translate([-gap_width/2,-baseWidth/2,base_thickness]) cube([gap_width,baseWidth,ball_diameter]);
        translate([-25, ball_diameter/2+0.5,0]) cube([50,ball_diameter, 50]);
        translate([-25, -ball_diameter-0.5,0]) cube([50,ball_diameter/2, 50]);

        translate([baseWidth/2,0,0]) cylinder(base_thickness+2,m_screw_diameter/2,m_screw_diameter/2,$fn=res);
        translate([-baseWidth/2,0,0]) cylinder(base_thickness+2,m_screw_diameter/2,m_screw_diameter/2,$fn=res);

    }

    if (show_ball) translate([0, 0, baseHeight]) sphere(ball_diameter/2, $fn=50);
}
