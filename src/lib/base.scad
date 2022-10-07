// Length of tool shaft, not including pommel
length_shaft = 200;

// Length of tool pommel
length_pommel = 15;

// Total length of tool, including shaft and pommel
length_total = length_shaft + length_pommel;

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

module pommel(length_pommel, base_width_fid, base_width_marlinespike, desired_base_width_flat) {
  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinespike/2);

  union() {
    // Pommel flat
    translate([0, base_width_flat/2, 0]) rotate([90, 0, 0]) linear_extrude(base_width_flat) scale([base_width_fid/base_width_marlinespike, 2*length_pommel/base_width_marlinespike, 1]) difference() {
      circle(d=base_width_marlinespike);
      translate([0, base_width_marlinespike/2, 0]) square(base_width_marlinespike, center=true);
    }

    // Pommel hemisphere, -y side
    translate([0, -base_width_flat/2, 0]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike, 2*length_pommel/base_width_marlinespike]) {
      difference() {
        difference() {
          sphere(d=base_width_marlinespike);
          translate([0, base_width_marlinespike/4, 0]) cube([base_width_fid, base_width_marlinespike/2, base_width_fid], center=true);
        }
        
        translate([0, 0, base_width_marlinespike/2]) cube(base_width_marlinespike, center=true);
      }
    }

    // Pommel hemisphere, +y side
    translate([0, base_width_flat/2, 0]) rotate([180, 180, 0]) scale([base_width_fid/base_width_marlinespike, (base_width_marlinespike - base_width_flat)/base_width_marlinespike, 2*length_pommel/base_width_marlinespike]) {
      difference() {
        difference() {
          sphere(d=base_width_marlinespike);
          translate([0, base_width_marlinespike/4, 0]) cube([base_width_fid, base_width_marlinespike/2, base_width_fid], center=true);
        }
        
        translate([0, 0, base_width_marlinespike/2]) cube(base_width_marlinespike, center=true);
      }
    }
  }
}

shaft(length_shaft, base_width_fid, base_width_marlinespike, desired_base_width_flat, chisel_width_fid, chisel_width_marlinespike);
pommel(length_pommel, base_width_fid, base_width_marlinespike, desired_base_width_flat);