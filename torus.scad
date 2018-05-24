module torus(
    inner_radius, 
    outer_radius, 
    major_points, 
    minor_points
) {
    rotate_extrude($fn = major_points) {
        translate([(inner_radius + outer_radius) * 0.5, 0, 0]) {
            circle(d = outer_radius - inner_radius, $fn = minor_points);
        }
    }
};

torus(10, 15, 8, 4);