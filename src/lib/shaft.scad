// Length of tool shaft, not including pommel
length_shaft = 200;

// Width of fid side where shaft meets pommel
base_width_fid = 30;

// Width of marlinespike side where shaft meets pommel
base_width_marlinespike = 20;

// Desired width of shaft flat (may be decreased if fid width is low)
desired_base_width_flat = 10;

// Width of chisel tip on fid side
chisel_width_fid = 3;

// Width of chisel tip on marlinespike side
chisel_width_marlinespike = 1;

module shaft(length_shaft, base_width_fid, base_width_marlinespike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinespike) {
  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinespike/2);

  linear_extrude(length_shaft, scale=[chisel_width_fid/base_width_fid, chisel_width_marlinespike/base_width_marlinespike]) union() {
    // Shaft flat
    square([base_width_fid, base_width_flat], center=true);

    // Shaft hemiellipse, -y side
    translate([0, -base_width_flat/2]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike]) difference() {
      circle(d=base_width_marlinespike);
      translate([0, base_width_marlinespike/4, 0]) square([base_width_fid, base_width_marlinespike/2], center=true);
    }

    // Shaft hemiellipse, +y side
    translate([0, base_width_flat/2]) rotate([180, 0, 0]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike]) difference() {
      circle(d=base_width_marlinespike);
      translate([0, base_width_marlinespike/4, 0]) square([base_width_fid, base_width_marlinespike/2], center=true);
    }
  }
}

module shaft_square(length_shaft, base_width_fid, base_width_marlinespike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinespike) {
  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinespike/2);

  linear_extrude(length_shaft, scale=[chisel_width_fid/base_width_fid, chisel_width_marlinespike/base_width_marlinespike]) union() {
    // Shaft flat
    square([base_width_fid, base_width_flat], center=true);

    // Shaft hemiellipse, -y side
    translate([0, -base_width_flat/2]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike]) difference() {
      square(base_width_marlinespike, center=true);
      translate([0, base_width_marlinespike/4, 0]) square([base_width_fid, base_width_marlinespike/2], center=true);
    }

    // Shaft hemiellipse, +y side
    translate([0, base_width_flat/2]) rotate([180, 0, 0]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike]) difference() {
      square(base_width_marlinespike, center=true);
      translate([0, base_width_marlinespike/4, 0]) square([base_width_fid, base_width_marlinespike/2], center=true);
    }
  }
}

shaft(length_shaft, base_width_fid, base_width_marlinespike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinespike);