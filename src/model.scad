// Total length of the tool
length = 200;
// Width of fib at tool base
width_x = 30;
// Width of marlinspike at tool base
width_y = 20;
// Width of the center flat
width_center = 10;
// Width of the chisel tip
chisel_x = 3;
// Thickness of the chisel tip
chisel_y = 1;
// Pommel height
pommel_z = 15;
// Distance of edge of lanyard hole from end of pommel
offset_l = 5;
// Diamater of lanyard hole
diameter_l = 10;
// Length of shackle key (may end up being set lower if thickness is too large)
desired_length_s = 50;
// Offset of shackle key from where shaft meets pommel
offset_s = 10;
// Thickness of tool around shackle key
thickness_s = 5;
// Length of material to trim from tip
trim = 6;

use <lib/lanyard.scad>
use <lib/pommel.scad>
use <lib/shackle_key.scad>
use <lib/shaft.scad>

difference() {
  // base material
  union() {
    shaft(length, width_x, width_y, width_center, chisel_x, chisel_y);
    pommel(pommel_z, width_x, width_y, width_center);
  }
 
  // holes and grooves
  union() {
    shackle_key(length, width_x, width_y, chisel_y, desired_length_s, offset_s, thickness_s);
    lanyard(pommel_z, diameter_l, offset_l, width_y);
    translate([0, 0, width_x/2 + length - trim]) cube(width_x, center=true); // remove some material from tip of tool
  }
}