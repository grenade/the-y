use <plot.scad>
use <tree.scad>

wing_x = 9;
wing_y = 9;
wing_z = 3;
slab_z = 0.5;
roof_z = 1;
center_d = 5.2;

translate([-11, 10, 0]) rotate(70) scale([0.05, 0.05, 0.06]) tree(
    h_increment     = 10,
    r_decrement     = 0.7,
    md_init         = 20,
    main_depth      = 20,
    rnd_seed        = 42,
    scaling         = 0.97,
    s_variance      = 0.1,
    bd_init         = 4,
    branch_depth    = 4,
    branch_angle    = 60,
    branch_min_size = 0.3,
    branch_max_size = 0.8
) {
    circle(d = 10, $fn = 8);
    square([2, 2]);
}

plot();

for(i=[0:2])
    translate([0, 0, (i * wing_z)]) floor();
translate([0, 0, (3 * wing_z)]) roof();


module floor() {
    R=3.895;
    for(i=[0:2]) {
        center_slab();
        rotate((i * 120)) translate([0, R*sqrt(3.32), 0]) wing();
    }
}

module roof() {
    R=3.895;
    for(i=[0:2]) {
        rotate((i * 120)) translate([0, R*sqrt(3.32), 0]) wing_roof();
    }
}

module center_slab() {
    rotate(30) color("#cccccc", 1) cylinder(slab_z, center_d, center_d, $fn=3);
}

module wing() {
    wing_slab();
    rotate(90) wing_window();
    rotate(180) wing_window();
    rotate(270) wing_window();
}

module wing_roof() {
    points = [
        // base corners
        [0, 0, 0],
        [wing_x, 0, 0],
        [wing_x, wing_y, 0],
        [0, wing_y, 0],

        // roof corners
        [wing_x / 2, (-(center_d/2)), roof_z],
        [wing_x / 2, wing_y, roof_z]      
    ];
    faces = [ 
        [0, 1, 2, 3],   // base
        [3, 4, 0],      // left triangle
        [1, 5, 2],      // right triangle
        [4, 5, 1, 0],   // front side,
        [5, 4, 3, 2]    // back side
    ];
    translate([(0 - (wing_x/2)), (0 - (wing_y/2)), 0])
        color("#666666")
        polyhedron(points, faces, convexity = 10);
}

module wing_window() {
    window_y = 0.1;
    window_z = (wing_z - slab_z);
    window_points = [
        [0, 0, 0], // 0
        [wing_x, 0, 0], // 1
        [wing_x, 0, window_z], // 2
        [0, 0, window_z], // 3
        [0, window_y, 0], // 4
        [wing_x, window_y, 0], // 5
        [wing_x, window_y, window_z], // 6
        [0, window_y, window_z], // 7
    ];
    window_faces=[
        [0,1,2,3], // bottom
        [4,5,1,0], // front
        [7,6,5,4], // top
        [5,6,2,1], // right
        [6,7,3,2], // back
        [7,4,0,3], // left
    ];
    translate([(0 - (wing_x/2)), (0 - (wing_y/2)), slab_z])
        color("#95c8d8", 0.4) 
        polyhedron(window_points, window_faces);
}

module wing_slab() {
    slab_points=[
        [0, 0, 0], // 0
        [wing_x, 0, 0], // 1
        [wing_x, wing_y, 0], // 2
        [0, wing_y, 0], // 3
        [0, 0, slab_z], // 4
        [wing_x, 0, slab_z], // 5
        [wing_x, wing_y, slab_z], // 6
        [0, wing_y, slab_z], // 7
    ];
    slab_faces=[
        [0,1,2,3], // bottom
        [4,5,1,0], // front
        [7,6,5,4], // top
        [5,6,2,1], // right
        [6,7,3,2], // back
        [7,4,0,3], // left
    ];
    translate([(0 - (wing_x/2)), (0 - (wing_y/2)), 0])
        color("#cccccc", 1)
        polyhedron(slab_points, slab_faces);
}
