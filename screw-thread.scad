module screw_thread (
    points_per_revolution,
    height_per_revolution,
    height,
    inner_radius,
    outer_radius
) {
    number_of_points = ceil(points_per_revolution * height / height_per_revolution) + points_per_revolution * 2;

    inner_points = [for(point = [0:number_of_points])[
        sin(360 * point / points_per_revolution) * inner_radius,
        cos(360 * point / points_per_revolution) * inner_radius,
        point * height_per_revolution / points_per_revolution
    ]];

    outer_points = [for(point = [0:number_of_points - points_per_revolution])[
        sin(360 * point / points_per_revolution) * outer_radius,
        cos(360 * point / points_per_revolution) * outer_radius,
        point * height_per_revolution / points_per_revolution + height_per_revolution / 2
    ]];

    points = concat(inner_points, outer_points, [
        [0, 0, 0],
        [0, 0, height + height_per_revolution * 2]
    ]);

    lower_faces_a = [for(point = [0:number_of_points - points_per_revolution - 1])[
        point,
        point + 1,
        point + number_of_points + 2
    ]];

    lower_faces_b = [for(point = [0:number_of_points - points_per_revolution - 1])[
        point + number_of_points + 2,    
        point + number_of_points + 1,
        point
    ]];

    lower_faces = concat(lower_faces_a, lower_faces_b);

    upper_faces_a = [for(point = [0:number_of_points - points_per_revolution - 1])[
        point + points_per_revolution + 1,    
        point + points_per_revolution,
        point + number_of_points + 1
    ]];

    upper_faces_b = [for(point = [0:number_of_points - points_per_revolution - 1])[
        point + number_of_points + 1,    
        point + number_of_points + 2,
        point + points_per_revolution + 1
    ]];

    upper_faces = concat(upper_faces_a, upper_faces_b);

    lower_cap_faces = [for(point = [0:points_per_revolution - 1]) [
        2 + number_of_points + number_of_points - points_per_revolution,
        point + 1,
        point
    ]];

    lower_cap_to_side_faces = [[
        0,
        number_of_points + 1,
        points_per_revolution,
        2 + number_of_points + number_of_points - points_per_revolution
    ]];

    upper_cap_faces = [for(point = [0:points_per_revolution - 1]) [
        3 + number_of_points + number_of_points - points_per_revolution,
        number_of_points - points_per_revolution + point,
        number_of_points - points_per_revolution + point + 1
    ]];

    upper_cap_to_side_faces = [[
        number_of_points,
        1 + number_of_points + number_of_points - points_per_revolution,
        number_of_points - points_per_revolution,
        3 + number_of_points + number_of_points - points_per_revolution
    ]];

    faces = concat(
        lower_faces, 
        upper_faces, 
        lower_cap_faces, 
        lower_cap_to_side_faces, 
        upper_cap_faces, 
        upper_cap_to_side_faces
    );

    intersection() {
        translate([0, 0, height / 2]) {
            cube([
                outer_radius * 2, 
                outer_radius * 2,
                height
            ], center = true);
        };
        
        translate([0, 0, -height_per_revolution]) {
            polyhedron(points = points, faces = faces);
        };
    };
}

screw_thread(8, 3, 100, 7, 8);