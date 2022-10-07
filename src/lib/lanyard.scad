// Length of tool pommel
length_pommel = 15;

// Width of marlinespike side where shaft meets pommel
base_width_marlinespike = 20;

// Diameter of lanyard hole
diameter_lanyard = 10;

// Distance from edge of lanyard hole to tip of pommel
offset_lanyard = 5;

module lanyard(length_pommel, diameter_lanyard, offset_lanyard, base_width_marlinespike) {
  translate([0, 0, -length_pommel + diameter_lanyard/2 + offset_lanyard]) rotate([90, 0, 0]) cylinder(d=diameter_lanyard, h=base_width_marlinespike*2, center=true);
}

lanyard(length_pommel, diameter_lanyard, offset_lanyard, base_width_marlinespike);