// a recursive tree
module tree(
    h_increment,
    r_decrement,
    md_init,
    main_depth,
    rnd_seed,
    scaling,
    s_variance,
    bd_init,
    branch_depth,
    branch_angle,
    branch_min_size,
    branch_max_size
) {
    rnd_values = rands(0, 1, 10, rnd_seed);        

    function z(from, to, idx) = rnd_values[idx] * (to - from) + from;

    if ((branch_depth < 1) && ($children > 1)) {
        color([(0 / 255), (255 / 255), (0 / 255)]) rotate([(floor(rnd_seed) % 2 == 0) ? 45 : -45, 0, 0]) linear_extrude(height = 0.1) children(1);
    } else {
        sf = scaling + z(-1, 1 ,1) * s_variance;

        linear_extrude(height = h_increment, scale = sf)
        color([(139 / 255), (69 / 255), (19 / 255)])
        children(0);

        // should we branch?
        if ((branch_depth > 0) && (z(0, 0.8, 2) < ((md_init - main_depth) / md_init))) {
            r_angle  = z(0, 720, 3);
            br_angle = branch_angle / 2 + z(0, 0.5, 4) * branch_angle;

            new_increment = (h_increment - h_increment / 2.5 * pow(r_decrement, branch_depth));

            // goes to 0, if br_angle is large
            // goes to 1, if br_angle is small
            branch_ratio = (branch_angle / br_angle) - 1.0;
            branch_scaling = (branch_min_size * branch_ratio + branch_max_size * (1.0 - branch_ratio));
            main_scaling = (sf * branch_ratio + branch_max_size * (1.0 - branch_ratio));

            translate([0, 0, h_increment])
            rotate([0, 0, r_angle])
            rotate([br_angle, 0, 0])
            tree(
                new_increment,
                r_decrement,
                md_init,
                md_init,
                z(0, 100, 5),
                scaling,
                s_variance,
                bd_init,
                branch_depth - 1,
                branch_angle,
                branch_min_size,
                branch_max_size
            ) {
                scale([branch_scaling, branch_scaling])
                color([(139 / 255), (69 / 255), (19 / 255)])
                children(0);
                if ($children > 1) {
                    children(1);
                }
            }

            // smooth out connection to branching path
            hull() {
                translate([0, 0, h_increment])
                linear_extrude(height = 0.01)
                scale([sf, sf])
                color([(139 / 255), (69 / 255), (19 / 255)])
                children(0);

                translate([0, 0, h_increment])
                rotate([0, 0, r_angle])
                rotate([br_angle, 0, 0])
                linear_extrude(height = new_increment / 2, scale = pow(scaling, (1 / 3)))
                scale([branch_scaling, branch_scaling])
                color([(139 / 255), (69 / 255), (19 / 255)])
                children(0);
            }

            // main path rotated in counter-direction
            if (main_depth > 0) {
                translate([0, 0, h_increment])
                rotate([0, 0, r_angle])
                rotate([-(branch_angle - br_angle), 0, 0])
                tree(
                    new_increment,
                    r_decrement,
                    md_init,
                    main_depth - 1 - z(0, 2, 6),
                    z(0, 100, 7),
                    scaling,
                    s_variance,
                    bd_init,
                    branch_depth,
                    branch_angle,
                    branch_min_size,
                    branch_max_size
                ) {
                    scale([main_scaling, main_scaling])
                    color([(139 / 255), (69 / 255), (19 / 255)])
                    children(0);
                    if ($children > 1) {
                        children(1);
                    }
                }

                // smooth out connection to main path
                hull() {
                    translate([0, 0, h_increment])
                    linear_extrude(height = 0.01)
                    scale([sf,sf])
                    color([(139 / 255), (69 / 255), (19 / 255)])
                    children(0);

                    translate([0, 0, h_increment])
                    rotate([0, 0, r_angle])
                    rotate([-(branch_angle - br_angle), 0, 0])
                    linear_extrude(height = (new_increment / 2), scale = pow(scaling, (1 / 3)))
                    scale([main_scaling, main_scaling])
                    color([(139 / 255), (69 / 255), (19 / 255)])
                    children(0);
                }
            }
        } else {
            if (main_depth > 0) {
                translate([0, 0, h_increment])
                tree(
                    h_increment,
                    r_decrement,
                    md_init,
                    main_depth - 1 - z(0, 2, 0),
                    z(0, 100, 9),
                    scaling,
                    s_variance,
                    bd_init,
                    branch_depth,
                    branch_angle,
                    branch_min_size,
                    branch_max_size
                ) {
                    scale([sf, sf])
                    color([(139 / 255), (69 / 255), (19 / 255)])
                    children(0);
                    if ($children > 1) {
                        children(1);
                    }
                }
            }

            if ((branch_depth < 2) && ($children > 1)) {
                color([(0 / 255), (255 / 255), (0 / 255)])
                rotate([(floor(rnd_seed) % 2 == 0) ? 45 : -45, 0, 0])
                linear_extrude(height = 0.1)
                children(1);
            }
        }
    }
}

srnd = rands(0, 1000, 1)[0];
echo(srnd);
tree(
    h_increment     = 10,
    r_decrement     = 0.7,
    md_init         = 20,
    main_depth      = 20,
    rnd_seed        = 42,
    scaling         = 0.97,
    s_variance      = 0.1,
    bd_init         = 3,
    branch_depth    = 3,
    branch_angle    = 60,
    branch_min_size = 0.3,
    branch_max_size = 0.8
) {
    circle(d = 10, $fn = 8);
    square([2, 2]);
}
