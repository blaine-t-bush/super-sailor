// Length of tool shaft, not including pommel
length_shaft = 200;

// Width of fid side where shaft meets pommel
base_width_fid = 30;

// Width of marlinspike side where shaft meets pommel
base_width_marlinspike = 20;

// Desired width of shaft flat (may be decreased if fid width is low)
desired_base_width_flat = 10;

// Width of chisel tip on fid side
chisel_width_fid = 3;

// Width of chisel tip on marlinspike side
chisel_width_marlinspike = 1;

module shaft(length_shaft, base_width_fid, base_width_marlinspike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinspike) {
  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinspike/2);

  linear_extrude(length_shaft, scale=[chisel_width_fid/base_width_fid, chisel_width_marlinspike/base_width_marlinspike]) union() {
    // Shaft flat
    square([base_width_fid, base_width_flat], center=true);

    // Shaft hemiellipse, -y side
    translate([0, -base_width_flat/2]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike]) difference() {
      circle(d=base_width_marlinspike, $fn=100);
      translate([0, base_width_marlinspike/4, 0]) square([base_width_fid, base_width_marlinspike/2], center=true);
    }

    // Shaft hemiellipse, +y side
    translate([0, base_width_flat/2]) rotate([180, 0, 0]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike]) difference() {
      circle(d=base_width_marlinspike, $fn=100);
      translate([0, base_width_marlinspike/4, 0]) square([base_width_fid, base_width_marlinspike/2], center=true);
    }
  }
}

module shaft_square(length_shaft, base_width_fid, base_width_marlinspike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinspike) {
  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinspike/2);

  linear_extrude(length_shaft, scale=[chisel_width_fid/base_width_fid, chisel_width_marlinspike/base_width_marlinspike]) union() {
    // Shaft flat
    square([base_width_fid, base_width_flat], center=true);

    // Shaft hemiellipse, -y side
    translate([0, -base_width_flat/2]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike]) difference() {
      square(base_width_marlinspike, center=true);
      translate([0, base_width_marlinspike/4, 0]) square([base_width_fid, base_width_marlinspike/2], center=true);
    }

    // Shaft hemiellipse, +y side
    translate([0, base_width_flat/2]) rotate([180, 0, 0]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike]) difference() {
      square(base_width_marlinspike, center=true);
      translate([0, base_width_marlinspike/4, 0]) square([base_width_fid, base_width_marlinspike/2], center=true);
    }
  }
}

module groove(length_shaft, base_width_marlinspike, chisel_width_marlinspike, groove_length, groove_diameter) {
  eps = 0.05;
  taper_angle = atan(2*length_shaft/(base_width_marlinspike - chisel_width_marlinspike));
  cylinder_diameter_top = groove_diameter + (base_width_marlinspike - chisel_width_marlinspike)/2;
  extrude_scale = cylinder_diameter_top/groove_diameter;
  // translate([0, 1.5*groove_diameter_max, length_shaft - groove_length/2]) rotate([90 - taper_angle, 0, 0]) translate([0, 0, -groove_length/2 + groove_diameter_min/2]) union() {
  //   cylinder(d1=groove_diameter_min, d2=groove_diameter_max, h=groove_length-groove_diameter_min/2 + eps, $fn=50);
  //   sphere(d=groove_diameter_min, $fn=50);
  // }
  translate([0, -cylinder_diameter_top, 0])
    linear_extrude(length_shaft, scale=[1, extrude_scale], $fn=50)
    translate([0, groove_diameter/2])
    circle(d=groove_diameter, $fn=50);
}

difference() {
  shaft(length_shaft, base_width_fid, base_width_marlinspike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinspike);
  groove(length_shaft, base_width_marlinspike, chisel_width_marlinspike, groove_length, groove_diameter);
}