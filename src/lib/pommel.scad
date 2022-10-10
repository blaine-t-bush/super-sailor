// Length of tool pommel
length_pommel = 15;

// Width of fid side where shaft meets pommel
base_width_fid = 30;

// Width of marlinespike side where shaft meets pommel
base_width_marlinespike = 20;

// Desired width of shaft flat (may be decreased if fid width is low)
desired_base_width_flat = 10;

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

module pommel_square(length_pommel, base_width_fid, base_width_marlinespike, desired_base_width_flat) {
  translate([0, 0, -length_pommel/2]) cube([base_width_fid, base_width_marlinespike, length_pommel], center=true);
}