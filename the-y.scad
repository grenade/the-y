render_windows = false;
render_plot = true;
render_roof = true;
plot_r = 72;
plot_g = 111;
plot_b = 56;
plot_opacity = 0.4;
slab_z = 300;
center_d = 5200;

rotate_y = 7100;

rotate_d = 120;

color_concrete = [128/255, 128/255, 118/255];

$fn = 360;

module plot(r = 72, g = 111, b = 56, o = 0.4) {
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
    difference() {
        color([(r / 255), (g / 255), (b / 255)], o)
            translate([0, 0, -1200])
            rotate([0, 4, 0])
            linear_extrude(height = 500, center = true, convexity = 10, twist = 0)
            scale([1000, 1000, 1])
            translate([-332616, -4634209, 0])
            polygon(points=plot_boundary);

        for(i=[0:2]) {
            rotate((i * rotate_d))
                translate([0, rotate_y, 0])
                cube([9000, 9000, 9000], center = true);
            /*
            rotate((i * rotate_d) + 60)
                translate([0, rotate_y, 0])
                cube([15000, 5000, 9000], center = true);
            */

            // stairwells
            rotate(((i * rotate_d) - 60))
                translate([0, rotate_y * 0.75, -6000])
                cylinder(9000, 2800, 2800, $fn = 360);
        }
    }
}

module curve_beam(width, depth, length, delta) {
    radius = (pow((length / 2), 2) + pow(delta, 2)) / (2 * delta);
    angle = 2 * asin((length / 2) / radius);
    translate([-(radius - delta), 0, -(width / 2)])
        rotate([0, 0, -(angle / 2)])
        rotate_extrude(angle = angle)
        translate([radius, 0, 0])
        square(size = [depth, width], center = true);
}

module curved_truss(
    top_chord_x = 2200,
    top_chord_y = 2600,
    top_chord_length = 6500,
    top_chord_delta = 1000,
    top_chord_width = 150,
    top_chord_height = 250,
    bottom_chord_z = 2200,
    bottom_chord_length = 6800,
    bottom_chord_delta = 800,
    bottom_chord_width = 100,
    bottom_chord_height = 200,
    web_length = 1450,
    web_width = 100,
    web_height = 150,
    web_z = 3750) {

    // right top_chord
    translate([top_chord_x, 0, top_chord_y])
        rotate([90, -40, 0])
        color([133/255, 94/255, 66/255], 1)
        curve_beam(width = top_chord_width, depth = top_chord_height, length = top_chord_length, delta = top_chord_delta);

    // left top_chord
    translate([-top_chord_x, 0, top_chord_y])
        rotate([90, 220, 0])
        color([133/255, 94/255, 66/255], 1)
        curve_beam(width = top_chord_width, depth = top_chord_height, length = top_chord_length, delta = top_chord_delta);

    // bottom_chord
    translate([0, 25, bottom_chord_z])
        rotate([0, -90, 90])
        color([133/255, 94/255, 66/255], 1)
        curve_beam(width = bottom_chord_width, depth = bottom_chord_height, length = bottom_chord_length, delta = bottom_chord_delta);

    // right web
    translate([1000, 75, web_z])
        rotate([0, 30, 0])
        color([133/255, 94/255, 66/255], 1)
        cube([150, 100, web_length], center = true);

    // left web
    translate([-1000, 75, web_z])
        rotate([0, -30, 0])
        color([133/255, 94/255, 66/255], 1)
        cube([web_height, web_width, web_length], center = true);
}

module center_slab(diameter = center_d, sides = 3) {
    rotate(30)
        color(color_concrete, 1)
        cylinder(slab_z, diameter, diameter, $fn = sides);
}

module square_roof_skin(width = 16000, depth = 10, length = 7500, delta = 1100, t_x = 2400, t_y = 7000, t_z = 2800) {
    translate([t_x, -t_y, t_z])
        rotate([90, -40, 0])
        color([1, 1, 1], 1)
        curve_beam(width = width, depth = depth, length = length, delta = delta);
    translate([-t_x, -t_y, t_z])
        rotate([90, 220, 0])
        color([1, 1, 1], 1)
        curve_beam(width = width, depth = depth, length = length, delta = delta);
}

module roof_skin(width = 16000, depth = 10, length = 7500, delta = 1100, t_x = 2400, t_y = 7000, t_z = 2800, difference_sphere = 7000, s_x = 0, s_y = 10000, s_z = 1000) {
    difference() {
        square_roof_skin(width = width, depth = depth, length = length, delta = delta, t_x = t_x, t_y = t_y, t_z = t_z);
        translate([s_x, s_y, -s_z]) sphere(difference_sphere);
        translate([s_x, -s_y, -s_z]) sphere(difference_sphere);
    }
        //translate([s_x, s_y, -s_z]) sphere(difference_sphere);
        //translate([0, -s_y, -s_z]) sphere(difference_sphere);
}


module wing_roof(brace_length = 2600) {

    // braces
    for(i=[0:4]) {
        translate([0, (5975 - (i * 2950)), 5125])
            color([133/255, 94/255, 66/255], 1)
            cube([150, brace_length, 250], center = true);
    }

    translate([0, 4425, 0])
        curved_truss();
    
    if (render_roof) {
        roof_skin();
    }
    
    translate([0, 1425, 0])
        curved_truss();

    translate([0, -1425, 0])
        curved_truss();

    translate([0, -4425, 0])
        curved_truss();
}

module wing_slab(width = 9000, height = slab_z, depth = 9000, render_stairwell = false) {
    difference() {
        color(color_concrete, 1)
            cube([width, depth, height], center = true);
        if (render_stairwell) {
            translate([-4501, -4500, -height])
                cube([1450, 2500, height * 3]);
        }
    }
}

module step(x = 1150, y = 300, z = 170) {
    color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cube([x, y, z]);
}

module steps(count = 10, step_x = 1150, step_y = 300, step_z = 170) {
    //lower landing
    /*
    color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cube([step_x, step_x, step_z]);
    */

    //steps
    for(i=[0:count]) {
        translate([0, -(i * step_y), (i * step_z)])
            step(x = step_x, y = step_y, z = step_z);
    }

    // upper landing
    /*
    translate([0, step_y-(step_x + ((count) * step_y)), ((count) * step_z)])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cube([step_x, step_x, step_z]);
    */

    // angled slab supporting steps
    slab_y = ((count) * sqrt((step_y * step_y) + (step_z * step_z)));
    slab_angle = 360 - atan(step_z / step_y);
    translate([0, -((count) * step_y), ((count) * step_z)])
        rotate([slab_angle, 0, 0])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cube([step_x, slab_y, (step_z * 0.9)]);
}


module wall_slab(width = 1000, height = 3000, depth = 300) {
    color(color_concrete, 1)
        cube([width, depth, height], center = true);
}


module window(width = 1000, height = 3000, depth = 20) {
    color([216/255, 228/255, 233/255], 0.5)
        cube([width, depth, height], center = true);
}



module stairwell() {
    translate([-4200, -3300, 2280])
        steps(count = 5, step_y = 300);

    // upper landing
    translate([5650, -6160, 2280])
        rotate([0, 0, 90])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cylinder(170, 680, 680, $fn=3);
    translate([6220, -5800, 2280])
        rotate([0, 0, 30])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cylinder(170, 680, 680, $fn=3);

    translate([5650, -4000, 1430])
        rotate([0, 0, 0])
        steps(count = 5, step_y = 300);

    // middle landing
    translate([6330, -3450, 1430])
        rotate([0, 0, 90])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cylinder(170, 550, 550, $fn=3);

    translate([-5650, -5200, 580])
        rotate([0, 0, 180])
        steps(count = 5, step_y = 300);

    // lower landing
    translate([3640, -2660, 580])
        rotate([0, 0, 90])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cylinder(170, 680, 680, $fn=3);
    translate([4220, -2350, 580])
        rotate([0, 0, 30])
        color([(204 / 255), (204 / 255), (204 / 255)], 1)
        cylinder(170, 680, 680, $fn=3);

    translate([4200, -4500, -270])
        rotate([0, 0, 180])
        steps(count = 5, step_y = 300);
}

module wing() {

    // wing roof
    translate([0, 0, 3800])
        wing_roof();
    translate([0, 0, 3150])
        wing_slab(render_stairwell = true);
    
    // ledges
    translate([4350, 0, 3550])
        rotate([0, 0, 90])
        wall_slab(height = 500, width = 9000);
    translate([-4350, 1250, 3550])
        rotate([0, 0, 90])
        wall_slab(height = 500, width = 6500);

    // side left front
    /*
    translate([-4350, -4000, 1500])
        rotate([0, 0, 90])
        wall_slab();
    */

    if (render_windows) {
        translate([-4490, -3000, 1500])
            rotate([0, 0, 90])
            window();
        translate([-4490, -2000, 1500])
            rotate([0, 0, 90])
            window();
        translate([-4490, -1000, 1500])
            rotate([0, 0, 90])
            window();

        translate([-4490, 1000, 1500])
            rotate([0, 0, 90])
            window();
        translate([-4490, 2000, 1500])
            rotate([0, 0, 90])
            window();
        translate([-4490, 3000, 1500])
            rotate([0, 0, 90])
            window();
    }

    // side left rear
    translate([-4350, 4000, 1500])
        rotate([0, 0, 90])
        wall_slab();

    // side right front
    translate([4350, -4000, 1500])
        rotate([0, 0, 90])
        wall_slab();

    if (render_windows) {
        translate([4490, -3000, 1500])
            rotate([0, 0, 90])
            window();
        translate([4490, -2000, 1500])
            rotate([0, 0, 90])
            window();
        translate([4490, -1000, 1500])
            rotate([0, 0, 90])
            window();

        translate([4490, 1000, 1500])
            rotate([0, 0, 90])
            window();
        translate([4490, 2000, 1500])
            rotate([0, 0, 90])
            window();
        translate([4490, 3000, 1500])
            rotate([0, 0, 90])
            window();
    }

    // side right rear
    translate([4350, 4000, 1500])
        rotate([0, 0, 90])
        wall_slab();

    // rear left
    translate([-4000, 4350, 1500])
        wall_slab();

    if (render_windows) {
        translate([-3000, 4490, 1500])
            window();
        translate([-2000, 4490, 1500])
            window();
        translate([-1000, 4490, 1500])
            window();
    }

    if (render_windows) {
        translate([1000, 4490, 1500])
            window();
        translate([2000, 4490, 1500])
            window();
        translate([3000, 4490, 1500])
            window();
    }

    // rear right
    translate([4000, 4350, 1500])
        wall_slab();

    // stairs
    stairwell();
    translate([0, 0, -3300]) stairwell();

    // ground floor slab
    translate([0, 0, -150])
        wing_slab(render_stairwell = true);

    // side left front
    /*
    translate([-4350, -4000, -1800])
        rotate([0, 0, 90])
        wall_slab();
    */

    // stairwell wall slabs
    translate([-4350, -1850, -150])
        wall_slab(height = 6900);
    translate([-6700, -3400, -150])
        rotate([0, 0, 60])
        wall_slab(height = 6900);
    translate([4350, -1850, -150])
        wall_slab(height = 6900);
        
    translate([-2900, -3500, -150])
        rotate([0, 0, 90])
        wall_slab(height = 6900);

    // side left center
    translate([-4350, -1500, -150])
        rotate([0, 0, 90])
        wall_slab(height = 6900);

    // side left rear
    translate([-4350, 4000, -1800])
        rotate([0, 0, 90])
        wall_slab();

    // side right front
    translate([4350, -4000, -1800])
        rotate([0, 0, 90])
        wall_slab();

    // side right center
    translate([4350, -1500, -150])
        rotate([0, 0, 90])
        wall_slab(height = 6900);

    // side right rear
    translate([4350, 4000, -1800])
        rotate([0, 0, 90])
        wall_slab();

    // front center
    translate([0, -4350, -1800])
        wall_slab();

    // rear left
    translate([-4000, 4350, -1800])
        wall_slab();

    // rear center
    translate([0, 4350, -1800])
        wall_slab();

    // rear right
    translate([4000, 4350, -1800])
        wall_slab();

    // center center
    translate([0, 0, -1800])
        wall_slab(width = 300);

    // basement slab
    translate([0, 0, -3450])
        wing_slab();
}


if (render_plot) {
    plot(plot_r, plot_g, plot_b, plot_opacity);
}

for(i=[0:2]) {
    // wings
    rotate((i * rotate_d))
        translate([0, rotate_y, 0])
        wing();

    // stairwells
    rotate(((i * rotate_d) - 60))
        translate([0, rotate_y * 0.75, -3600])
        center_slab(diameter = 2800, sides = 360);
    
    if (render_roof) {
        rotate(((i * rotate_d) - 60))
            translate([0, rotate_y * 0.65, 3600])
        // width = 16000, depth = 10, length = 7500, delta = 1100, t_x = 2400, t_y = 7000, t_z = 2800, difference_sphere = 7000, s_x = 0, s_y = 10000, s_z = 1000
            roof_skin(width = 8000, depth = 10, length = 4500, delta = 600, t_x = 1400, t_y = 3000, t_z = 1800, difference_sphere = 5000, s_x = 0, s_y = 7000, s_z = 1100);
    }
}

translate([0, 0, 3000])
    center_slab();

translate([0, 0, -300])
    center_slab();

translate([0, 0, -3600])
    center_slab();
