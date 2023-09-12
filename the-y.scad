plot_boundary=[
    [332600.56300000, 4634190.49600000], // south
    [332600.56300000, 4634190.49600000], // south
    [332601.66300000, 4634193.92500000], // south
    [332592.83700000, 4634197.71800000], // south-west
    [332600.75000000, 4634216.13200000], // west
    [332613.90400000, 4634229.72000000], // north-west
    [332625.15300000, 4634222.72400000], // north
    [332625.50000000, 4634222.56700000], // north
    [332624.94600000, 4634221.79300000], // north
    [332637.40600000, 4634212.34800000], // north-east
    [332622.91400000, 4634193.23000000], // east
    [332617.36000000, 4634194.95800000], // east
    [332611.44000000, 4634193.23700000], // south-east
];

wing_x=9;
wing_y=9;
slab_z=0.5;


translate([-332616, -4634209, 0]) color("#486f38", .5) plot();
//center_slab();

R=3.895;
h=1;
for(i=[0:2])
    rotate((i * 120)) translate([0, R*sqrt(3.32), 0]) color("#cccccc", 1) wing_slab();

module plot() {
    polygon(points=plot_boundary);
}


module center_slab() {
    h=pow((pow(wing_x, 2) - (pow(wing_x, 2) / 4)), (1 / 2));
    slab_points=[
        [0, 0, 0], // 0
        [wing_x, 0, 0], // 1
        [(wing_x / 2), h, 0], // 2

        [0, 0, slab_z], // 3
        [wing_x, 0, 0slab_z], // 4
        [(wing_x / 2), h, slab_z], // 5
    ];
    slab_faces=[
        [0,1,2], // bottom
        [3,4,1,0], // front
        [5,4,3], // top
        [4,5,2,1], // right
        [2,5,0,3], // left
    ];
    translate([(0 - (wing_x/2)), (0 - (h/2)), 0])
        polyhedron(slab_points, slab_faces);
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
        polyhedron(slab_points, slab_faces);
}
