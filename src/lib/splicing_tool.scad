// Length of tool shaft, not including pommel
length_shaft = 200;

// Width of marlinspike side where shaft meets pommel
base_width_fid = 30;

// Width of marlinspike side where shaft meets pommel
base_width_marlinspike = 20;

// Width of chisel tip on fid side
chisel_width_fid = 1;

// Length of splicing hole (may end up being set lower if thickness is too large)
desired_length = 55;

// Offset of splicing tool from where shaft meets pommel
offset = 110;

// Thickness of tool material around splicing tool
thickness = 4;

module splicing_tool(length_shaft, base_width_fid, base_width_marlinspike, chisel_width_fid, desired_length, offset, thickness) {
  // Epsilon to ensure no false borders
  eps = 0.01;

  // Taper angles based on overall shaft geometry
  tan_taper_x = 2*length_shaft/(base_width_fid - chisel_width_fid);
  deg_taper_x = atan(tan_taper_x);
  sin_taper_x = sin(deg_taper_x);
  tan_taper_const = (1 + tan_taper_x*tan_taper_x)/(tan_taper_x*tan_taper_x);

  // Dimensions of shackle key, overall
  length_s = min(base_width_fid*tan_taper_x/2 - thickness*tan_taper_x/sin_taper_x - offset, desired_length);
  width_s_base = max(base_width_fid - 2*(offset/tan_taper_x + thickness/sin_taper_x), 0);
  width_s_top = max(base_width_fid - 2*((length_s + offset)/tan_taper_x + thickness/sin_taper_x), 0);

  radius_s_base = sqrt((width_s_base/2)^2 * tan_taper_const);
  radius_s_top = sqrt((width_s_top/2)^2 * tan_taper_const);
  roundover_s_base_offset = sqrt(radius_s_base^2 - (width_s_base/2)^2);
  roundover_s_top_offset = sqrt(radius_s_top^2 - (width_s_top/2)^2);

  length_s_straight = length_s - radius_s_top - roundover_s_base_offset - radius_s_base - roundover_s_top_offset; // length of just the straight part of shackle key (i.e. not including semicircular cutouts at each end)
  modified_width_s_top = max(base_width_fid - 2*((length_s_straight + offset)/tan_taper_x + thickness/sin_taper_x), 3.2);
  scale_s = modified_width_s_top/width_s_base;
  modified_length_s_straight = tan_taper_x*(-0.5*(modified_width_s_top - base_width_fid) - thickness/sin_taper_x) - offset;

  translate([0, 0, radius_s_base - roundover_s_base_offset]) union() {
    // rectangular cutout
    translate([0, 0, offset]) linear_extrude(modified_length_s_straight, scale=[scale_s, 1]) square([width_s_base, base_width_marlinspike], center=true);

    // semicircular cutout, -z side
    rotate([0, 0, 90]) translate([-base_width_fid/2, 0, offset + roundover_s_base_offset + eps]) rotate([0, 90, 0]) linear_extrude(base_width_fid) difference() {
      circle(d=width_s_base, $fn=100);
      translate([-width_s_base/2, 0, 0]) square(width_s_base, center=true);
    }

    // semicircular cutout, +z side
    rotate([0, 0, 90]) translate([base_width_fid/2, 0, offset + modified_length_s_straight - roundover_s_top_offset - eps]) rotate([0, 270, 0]) linear_extrude(base_width_fid) difference() {
      circle(d=modified_width_s_top, $fn=100);
      translate([-modified_width_s_top/2, 0, 0]) square(modified_width_s_top, center=true);
    }
  }
}