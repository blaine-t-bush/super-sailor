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

shaft(length_shaft, base_width_fid, base_width_marlinspike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinspike);