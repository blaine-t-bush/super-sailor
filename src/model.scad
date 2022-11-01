// Total length of the tool, not including pommel
length = 180;
// Width of fib at tool base
width_x = 30;
// Width of marlinspike at tool base
width_y = 20;
// Width of the center flat
width_center = 10;
// Width of the chisel tip
chisel_x = 1;
// Thickness of the chisel tip
chisel_y = 4;
// Pommel height
pommel_z = 15;
// Distance of edge of lanyard hole from end of pommel
offset_l = 5;
// Diamater of lanyard hole
diameter_l = 8;
// Length of shackle key (may end up being set lower if thickness is too large)
desired_length_s = 80;
// Offset of shackle key from where shaft meets pommel
offset_s = 2;
// Thickness of tool around shackle key
thickness_s = 4;
// Length of splicing tool (may end up being set lower if thickness is too large)
desired_length_p = 60;
// Offset of splicing tool from end of shackle key
offset_p = 2;
// Thickness of tool around splicing tool
thickness_p = 3.5;
// Length of material to trim from tip
trim = 0;
// Length of blood grove
groove_length = 40;
// Diameter of blood groove
groove_diameter = 1;
// Diameter difference of ballooned opening at base of shackle key from default shackle key size at base.
extra_diameter_balloon = 2;

use <lib/lanyard.scad>
use <lib/pommel.scad>
use <lib/shackle_key.scad>
use <lib/shaft.scad>
use <lib/splicing_tool.scad>

difference() {
  // base material
  union() {
    shaft(length, width_x, width_y, width_center, chisel_x, chisel_y);
    pommel(pommel_z, width_x, width_y, width_center);
  }
 
  // holes and grooves
  union() {
    shackle_key(length, width_x, width_y, chisel_y, desired_length_s, offset_s, thickness_s);
    shackle_key_ballooning(length, width_x, width_y, chisel_y, desired_length_s, offset_s, thickness_s, extra_diameter_balloon);
    splicing_tool(length, width_x, width_y, chisel_x, desired_length_p, offset_p + offset_s + desired_length_s, thickness_p);
    lanyard(pommel_z, diameter_l, offset_l, width_y);
    // translate([-width_x/2, 0, diameter_s_e/2]) rotate([0, 90, 0]) linear_extrude(width_x) circle(d=diameter_s_e); // add ballooned hole at base of shackle key
    // groove(length, width_y, chisel_y, groove_length, groove_diameter);
    translate([0, 0, width_x/2 + length - trim]) cube(width_x, center=true); // remove some material from tip of tool
  }
}

// add hardpoints for cnc
// hardpoint_diameter = 10;
// hardpoint_length = 30;
// translate([0, 0, -pommel_z - hardpoint_length + 2]) cylinder(d=10, h=30);
// translate([0, 0, length - 30]) cylinder(d=10, h=30);