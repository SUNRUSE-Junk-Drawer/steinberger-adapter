use <torus.scad>
use <screw-thread.scad>

string_spacing = 7;
number_of_strings = 6;

string_bend_radius = 4;
string_bend_points = 16;

channel_radius = 1;
channel_points = 8;

kick_angle = 15.945;
neck_points = 32;

truss_plug_radius = 4.04;
truss_plug_length = 5.31;
truss_plug_points = 24;
truss_plug_vertical = -4.5;

screw_plug_radius = 3.43;
screw_plug_length = 4.2;
screw_plug_points = 20;
screw_plug_spacing = 20;
screw_plug_vertical = -3.8;

width = string_spacing * number_of_strings;
furthest_channel_width = string_spacing * (number_of_strings - 1);

screw_height = 5;
screw_radius = 3;
screw_thread_depth = 1;
screw_hole_tolerance = 0.4;
screw_points_per_revolution = 24;
screw_height_per_revolution = 1.5;

screw_plate_margin = 3;
screw_plate_radius = string_spacing / 2 + screw_plate_margin;
screw_plate_height = string_bend_radius + screw_height;

translate([0, 0, truss_plug_vertical]) {
    rotate([90, 0, 0]) {
        cylinder(
            r = truss_plug_radius,
            h = truss_plug_length,
            $fn = truss_plug_points
        );
    };
};

translate([screw_plug_spacing / -2, 0, screw_plug_vertical]) {
    rotate([90, 0, 0]) {
        cylinder(
            r = screw_plug_radius,
            h = screw_plug_length,
            $fn = screw_plug_points
        );
    };
};

translate([screw_plug_spacing / 2, 0, screw_plug_vertical]) {
    rotate([90, 0, 0]) {
        cylinder(
            r = screw_plug_radius,
            h = screw_plug_length,
            $fn = screw_plug_points
        );
    };
};

intersection() {
    rotate([90, 0, 0]) {
        cylinder(
            d = width,
            h = width,
            center = true,
            $fn = neck_points
        );
    };
    union() {
        intersection() {
            translate([
                width / -2, 
                0,
                -string_bend_radius
            ]) {
                cube([
                    width, string_bend_radius, string_bend_radius * 2]);
            };
            
            difference() {
                rotate([0, 90, 0]) {
                    rotate([0, 0, -kick_angle]) {
                        cylinder(
                            r = string_bend_radius, 
                            h = width, 
                            center = true, 
                            $fn = string_bend_points
                        );
                    };
                };

                for (x = [furthest_channel_width / -2:string_spacing:furthest_channel_width / 2]) {
                    translate([x, 0, 0]) {
                        rotate([0, 90, 0]) {
                            rotate([0, 0, -kick_angle]) {
                                torus(
                                    string_bend_radius - channel_radius,
                                    string_bend_radius + channel_radius,
                                    string_bend_points,
                                    channel_points
                                );
                            };
                        };
                    };
                };
            };
        };

        rotate([-kick_angle, 0, 0]) {
            difference() {
                translate([width / -2, 0, -width]) {
                    cube([width, string_bend_radius, width]);
                };
                
                for (x = [furthest_channel_width / -2:string_spacing:furthest_channel_width / 2]) {
                    translate([x, string_bend_radius, -width]) {            
                        cylinder(
                            r = channel_radius, 
                            h = width, 
                            $fn = channel_points
                        );
                    };
                };
            };
        };
    };
};