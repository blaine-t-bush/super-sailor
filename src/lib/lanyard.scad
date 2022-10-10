// Length of tool pommel
length_pommel = 15;

// Width of marlinspike side where shaft meets pommel
base_width_marlinspike = 20;

// Diameter of lanyard hole
diameter_lanyard = 10;

// Distance from edge of lanyard hole to tip of pommel
offset_lanyard = 5;

module lanyard(length_pommel, diameter_lanyard, offset_lanyard, base_width_marlinspike) {
  rotate([0, 0, 90]) translate([0, 0, -length_pommel + diameter_lanyard/2 + offset_lanyard]) rotate([90, 0, 0]) cylinder(d=diameter_lanyard, h=base_width_marlinspike*2, center=true, $fn = 50);
}

lanyard(length_pommel, diameter_lanyard, offset_lanyard, base_width_marlinspike);