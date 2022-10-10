// Length of tool shaft, not including pommel
length_shaft = 200;

// Width of marlinspike side where shaft meets pommel
base_width_fid = 30;

// Width of marlinspike side where shaft meets pommel
base_width_marlinspike = 20;

// Width of chisel tip on marlinspike side
chisel_width_marlinspike = 1;

// Length of shackle key (may end up being set lower if thickness is too large)
desired_length = 50;

// Offset of shackle key from where shaft meets pommel
offset = 10;

// Thickness of tool material around shackle key
thickness = 5;

module shackle_key(length_shaft, base_width_fid, base_width_marlinspike, chisel_width_marlinspike, desired_length, offset, thickness) {
  // Epsilon to ensure no false borders
  eps = 0.01;

  // Taper angles based on overall shaft geometry
  tan_taper_y = 2*length_shaft/(base_width_marlinspike - chisel_width_marlinspike);
  deg_taper_y = atan(tan_taper_y);
  sin_taper_y = sin(deg_taper_y);
  tan_taper_const = (1 + tan_taper_y*tan_taper_y)/(tan_taper_y*tan_taper_y);

  // Dimensions of shackle key, overall
  length_s = min(base_width_marlinspike*tan_taper_y/2 - thickness*tan_taper_y/sin_taper_y - offset, desired_length);
  width_s_base = max(base_width_marlinspike - 2*(offset/tan_taper_y + thickness/sin_taper_y), 0);
  width_s_top = max(base_width_marlinspike - 2*((length_s + offset)/tan_taper_y + thickness/sin_taper_y), 0);

  radius_s_base = sqrt((width_s_base*width_s_base/4) * tan_taper_const);
  radius_s_top = sqrt((width_s_top*width_s_top/4) * tan_taper_const);
  offset_base = sqrt(radius_s_base*radius_s_base - (width_s_base*width_s_base/4));
  offset_top = sqrt(radius_s_top*radius_s_top - (width_s_top*width_s_top/4));
  roundover_s_base_offset = sqrt(radius_s_base^2 - (width_s_base/2)^2);
  roundover_s_top_offset = sqrt(radius_s_top^2 - (width_s_top/2)^2);

  length_s_straight = length_s - roundover_s_base_offset - roundover_s_top_offset; // length of just the straight part of shackle key (i.e. not including semicircular cutouts at each end)
  modified_width_s_top = base_width_marlinspike - 2*((length_s_straight + offset)/tan_taper_y + thickness/sin_taper_y);
  scale_s = modified_width_s_top/width_s_base;


  translate([0, 0, radius_s_base - roundover_s_base_offset]) union() {
    // rectangular cutout
    translate([0, 0, offset]) linear_extrude(length_s_straight, scale=[1, scale_s]) square([base_width_fid, width_s_base], center=true);

    // semicircular cutout, -z side
    translate([-base_width_fid/2, 0, offset + roundover_s_base_offset + eps]) rotate([0, 90, 0]) linear_extrude(base_width_fid) difference() {
      circle(r=radius_s_base, $fn=100);
      translate([-radius_s_base, 0, 0]) square(2*radius_s_base, center=true);
    }

    // semicircular cutout, +z side
    translate([base_width_fid/2, 0, offset + length_s_straight - roundover_s_top_offset - eps]) rotate([0, 270, 0]) linear_extrude(base_width_fid) difference() {
      circle(r=radius_s_top, $fn=100);
      translate([-radius_s_top, 0, 0]) square(2*radius_s_top, center=true);
    }
  }
}