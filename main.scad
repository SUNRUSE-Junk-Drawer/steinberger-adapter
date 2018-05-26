use <torus.scad>
use <screw-thread.scad>

minimalist = false;

string_spacing = 7;
number_of_strings = 6;

string_bend_radius = 4;
string_bend_points = 24;

channel_radius = 1;
channel_points = 12;

kick_angle = 15.945;
neck_points = 64;

truss_plug_radius = 4.04;
truss_plug_length = 5.31;
truss_plug_points = 24;
truss_plug_vertical = -4.5;

screw_plug_radius = 3.43;
screw_plug_length = 2.4;
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

screw_plate_margin = 1.5;
screw_plate_radius = string_spacing / 2 + screw_plate_margin;
screw_plate_height = string_bend_radius + screw_height - channel_radius;
screw_plate_points = 32;

screw_notch_width = 3.5;
screw_notch_height = 1;
screw_notch_depth = 2.5;

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

difference() {
    union() {
        if (!minimalist) {
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
                        translate([width / -2, 0, -width]) {
                            cube([width, string_bend_radius, width]);
                        };
                    };
                };
            };
        };
        
        rotate([-kick_angle, 0, 0]) {
            translate([
                -furthest_channel_width / 2,
                screw_plate_height,
                -screw_plate_radius
            ]) {                        
                rotate([90, 0, 0]) {
                    cylinder(
                        r = screw_plate_radius,
                        h = screw_plate_height,
                        $fn = screw_plate_points
                    );
                };
            };
            
            translate([
                furthest_channel_width / 2,
                screw_plate_height,
                -screw_plate_radius
            ]) {                        
                rotate([90, 0, 0]) {
                    cylinder(
                        r = screw_plate_radius,
                        h = screw_plate_height,
                        $fn = screw_plate_points
                    );
                };
            };
            
            translate([
                furthest_channel_width / -2,
                0,
                screw_plate_radius * -2
            ]) {
                cube([
                    furthest_channel_width,
                    screw_plate_height,    
                    screw_plate_radius * 2
                ]);
            };
        };
    };
    
    rotate([-kick_angle, 0, 0]) {
        for (x = [furthest_channel_width / -2:string_spacing:furthest_channel_width / 2]) {
            translate([x, string_bend_radius - channel_radius, -screw_plate_radius]) {
                rotate([-90, 0, 0]) {
                    screw_thread(
                        screw_points_per_revolution,
                        screw_height_per_revolution,
                        screw_height + 1 /* Fixes a minor tolerance problem. */,
                        screw_radius + screw_hole_tolerance - screw_thread_depth,
                        screw_radius + screw_hole_tolerance
                    );
                };
            };
            
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

for (x = [furthest_channel_width / -2:string_spacing:furthest_channel_width / 2]) {
    translate([x, 10, -20]) {
        difference() {
            screw_thread(
                screw_points_per_revolution,
                screw_height_per_revolution,
                screw_height,
                screw_radius - screw_thread_depth,
                screw_radius
            );
            
            translate([
                screw_notch_width / -2,
                screw_notch_height / -2,
                screw_height - screw_notch_depth
            ]) {
                cube([screw_notch_width, screw_notch_height, screw_notch_depth]);
            };
        };
    };
}