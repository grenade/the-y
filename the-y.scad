use <plot.scad>
use <tree.scad>

// units are in millimetres
wing_x = 9000;
wing_y = 9000;
wing_z = 3000;
slab_z = 300;
roof_z = 1000;
roof_o = 500;
window_y = 100;
center_d = 5200;
rotate_y = 7100;
rotate_d = 120;

translate([-4000, 18000, 0]) scale([50, 60, 40]) tree(
    h_increment     = 10,
    r_decrement     = 0.7,
    md_init         = 20,
    main_depth      = 20,
    rnd_seed        = 42,
    scaling         = 0.97,
    s_variance      = 0.1,
    bd_init         = 3,
    branch_depth    = 4,
    branch_angle    = 60,
    branch_min_size = 0.3,
    branch_max_size = 0.8
)
{
    circle(d = 10, $fn = 8);
    square([2, 2]);
}

translate([-11000, 10000, 0]) rotate(70) scale([50, 50, 50]) tree(
    h_increment     = 10,
    r_decrement     = 0.7,
    md_init         = 20,
    main_depth      = 20,
    rnd_seed        = 42,
    scaling         = 0.97,
    s_variance      = 0.1,
    bd_init         = 3,
    branch_depth    = 4,
    branch_angle    = 60,
    branch_min_size = 0.3,
    branch_max_size = 0.8
)
{
    circle(d = 10, $fn = 8);
    square([2, 2]);
}


scale([1000, 1000, 1]) plot();

for(i=[0:2])
    translate([0, 0, (i * wing_z)]) floor();
translate([0, 0, (3 * wing_z)]) roof("#666666");


module floor() {
    for(i=[0:2]) {
        center_slab();
        rotate((i * rotate_d)) translate([0, rotate_y, 0]) wing();
    }
}

module roof(color) {
    for(i=[0:2]) {
        rotate((i * rotate_d)) translate([0, rotate_y, 0]) wing_roof(color);
    }
}

module center_slab() {
    rotate(30) color("#cccccc", 1) cylinder(slab_z, center_d, center_d, $fn=3);
}

module wing() {
    wing_slab();
    for(i=[1:3]) {
        rotate((i * 90)) wing_window();
    }
}

module wing_roof(color) {
    
    roof_x = wing_x + (roof_o * 2);
    roof_y = wing_y + roof_o;
    points = [
        // base corners
        [0, 0, 0],
        [roof_x, 0, 0],
        [roof_x, roof_y, 0],
        [0, roof_y, 0],

        // roof corners
        [(roof_x / 2), (0 - (center_d / 2)), roof_z],
        [(roof_x / 2), roof_y, roof_z]      
    ];
    faces = [ 
        [0, 1, 2, 3],   // base
        [3, 4, 0],      // left triangle
        [1, 5, 2],      // right triangle
        [4, 5, 1, 0],   // front side,
        [5, 4, 3, 2]    // back side
    ];
    translate([(0 - (roof_x / 2)), (0 - (wing_y / 2)), 0])
        color(color)
        polyhedron(points, faces, convexity = 10);
}

module wing_window() {
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
    translate([(0 - (wing_x / 2)), (0 - (wing_y / 2)), slab_z])
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
