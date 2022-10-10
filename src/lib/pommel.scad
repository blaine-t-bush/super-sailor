// Length of tool pommel
length_pommel = 15;

// Width of fid side where shaft meets pommel
base_width_fid = 30;

// Width of marlinspike side where shaft meets pommel
base_width_marlinspike = 20;

// Desired width of shaft flat (may be decreased if fid width is low)
desired_base_width_flat = 10;

module pommel(length_pommel, base_width_fid, base_width_marlinspike, desired_base_width_flat) {
  // Scale factor to increase smoothing (1 = no increase)
  scale_factor = 20;
  scale_inverse = 1/scale_factor;

  // Width of shaft flat
  base_width_flat = min(desired_base_width_flat, base_width_marlinspike/2);

  union() {
    // Pommel flat
    translate([0, base_width_flat/2, 0]) rotate([90, 0, 0]) linear_extrude(base_width_flat) scale([base_width_fid/base_width_marlinspike, 2*length_pommel/base_width_marlinspike, 1]) difference() {
      circle(d=base_width_marlinspike, $fn=100);
      translate([0, base_width_marlinspike/2, 0]) square(base_width_marlinspike, center=true);
    }

    // Pommel hemisphere, -y side
    translate([0, -base_width_flat/2, 0]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike, 2*length_pommel/base_width_marlinspike]) {
      difference() {
        difference() {
          sphere(d=base_width_marlinspike, $fn=100);
          translate([0, base_width_marlinspike/4, 0]) cube([base_width_fid, base_width_marlinspike/2, base_width_fid], center=true);
        }
        
        translate([0, 0, base_width_marlinspike/2]) cube(base_width_marlinspike, center=true);
      }
    }

    // Pommel hemisphere, +y side
    translate([0, base_width_flat/2, 0]) rotate([180, 180, 0]) scale([base_width_fid/base_width_marlinspike, (base_width_marlinspike - base_width_flat)/base_width_marlinspike, 2*length_pommel/base_width_marlinspike]) {
      difference() {
        difference() {
          sphere(d=base_width_marlinspike, $fn=100);
          translate([0, base_width_marlinspike/4, 0]) cube([base_width_fid, base_width_marlinspike/2, base_width_fid], center=true);
        }
        
        translate([0, 0, base_width_marlinspike/2]) cube(base_width_marlinspike, center=true);
      }
    }
  }
}

module pommel_square(length_pommel, base_width_fid, base_width_marlinspike, desired_base_width_flat) {
  translate([0, 0, -length_pommel/2]) cube([base_width_fid, base_width_marlinspike, length_pommel], center=true);
}