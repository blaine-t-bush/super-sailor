// Total length of the tool
length = 200;
// Width of fib at tool base
width_x = 30;
// Width of marlinespike at tool base
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
offset_s = 0;
// Thickness of tool around shackle key
thickness_s = 5;

// // Eyelet outer diameter
// eyelet_od = 10;
// // Eyelet inner diameter
// eyelet_id = 6.5;
// // Eyelet shaft length
// eyelet_shaft_length = 2.5;
// // Eyelet shaft diameter
// eyelet_shaft_width = 6.75;

// Epsilon to ensure no false borders
eps = 0.01;

// Scale factor to increase smoothing (1 = no increase)
scale_factor = 20;
scale_inverse = 1/scale_factor;

// Shackle key geometry
tan_taper_y = 2*length/(width_y - chisel_y);
deg_taper_y = atan(tan_taper_y);
sin_taper_y = sin(deg_taper_y);
length_s = min(width_y*tan_taper_y/2 - thickness_s*tan_taper_y/sin_taper_y - offset_s, desired_length_s);
width_s_base = max(width_y - 2*(offset_s/tan_taper_y + thickness_s/sin_taper_y), 0);
width_s_top = max(width_y - 2*((length_s + offset_s)/tan_taper_y + thickness_s/sin_taper_y), 0);
echo(width_s_top);
tan_taper_const = (1 + tan_taper_y*tan_taper_y)/(tan_taper_y*tan_taper_y);
radius_s_base = sqrt((width_s_base*width_s_base/4) * tan_taper_const); // bottom shackle key round radius
radius_s_top = sqrt((width_s_top*width_s_top/4) * tan_taper_const); // Top shackle key round radius
offset_s_base = sqrt(radius_s_base*radius_s_base - (width_s_base*width_s_base/4));
offset_s_top = sqrt(radius_s_top*radius_s_top - (width_s_top*width_s_top/4));
roundover_s_base_offset = sqrt(radius_s_base^2 - (width_s_base/2)^2);
roundover_s_top_offset = sqrt(radius_s_top^2 - (width_s_top/2)^2);
length_s_straight = length_s - roundover_s_base_offset - roundover_s_top_offset; // length of just the straight part of shackle key (i.e. not including semicircular cutouts at each end)
modified_width_s_top = width_y - 2*((length_s_straight + offset_s)/tan_taper_y + thickness_s/sin_taper_y);
scale_s = modified_width_s_top/width_s_base;

difference() {
  union() {
    // shaft
    linear_extrude(length, scale=[chisel_x/width_x, chisel_y/width_y]) union() {
      // shaft hemiellipse, -y side
      translate([0, -width_center/2, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 1]) difference() {
        circle(d=width_y);
        translate([0, width_y/4, 0]) square([width_x, width_y/2], center=true);
      }

      // shaft hemiellipse, +y side
      translate([0, width_center/2, 0]) rotate([180, 0, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 1]) difference() {
        circle(d=width_y);
        translate([0, width_y/4, 0]) square([width_x, width_y/2], center=true);
      }

      // shaft flat
      square([width_x, width_center], center=true);
    }

    // pommel
    union() {
      // pommel hemisphere, -y side
      translate([0, -width_center/2, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 2*pommel_z/width_y]) {
        difference() {
          difference() {
            sphere(d=width_y);
            translate([0, width_y/4, 0]) cube([width_x, width_y/2, width_x], center=true);
          }
          
          translate([0, 0, width_y/2]) cube(width_y, center=true);
        }
      }

      // pommel hemisphere, +y side
      translate([0, width_center/2, 0]) rotate([180, 0, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 2*pommel_z/width_y]) {
        difference() {
          difference() {
            sphere(d=width_y);
            translate([0, width_y/4, 0]) cube([width_x, width_y/2, width_x], center=true);
          }
          
          translate([0, 0, -width_y/2]) cube(width_y, center=true);
        }
      }

      // pommel flat
      translate([0, width_center/2, 0]) rotate([90, 0, 0]) linear_extrude(width_center) scale([width_x/width_y, 2*pommel_z/width_y, 1]) difference() {
        circle(d=width_y);
        translate([0, width_y/2, 0]) square(width_y, center=true);
      }
      
      // pommel eyelet
      // difference() {
      //   union() {
      //     translate([0, 0, -eyelet_shaft_length - eyelet_od/2 - width_y/2]) scale(scale_inverse) cylinder(h=(scale_factor*(eyelet_shaft_length + eyelet_od)), d=scale_factor*eyelet_shaft_width);
      //     translate([0, 0, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) scale(scale_inverse) sphere(d=scale_factor*eyelet_od);
      //   }
      //   union() {
      //     // eyelet hole
      //     translate([0, 0, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) rotate([90, 0, 0]) scale(scale_inverse) cylinder(h=scale_factor*eyelet_od, d=scale_factor*eyelet_id, center=true);
      //     // rounding for eyelet hole, -y side
      //     translate([0, -(eyelet_shaft_width + eyelet_id)/2, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) scale(scale_inverse) sphere(d=scale_factor*eyelet_od);
      //     // rounding for eyelet hole, +y side
      //     translate([0, (eyelet_shaft_width + eyelet_id)/2, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) scale(scale_inverse) sphere(d=scale_factor*eyelet_od);
      //   }
      // }
    }
  }
 
  // all holes
  union() {
    // shackle key
    translate([0, 0, radius_s_base - roundover_s_base_offset]) union() {
      // shackle key rectangular cutout
      translate([0, 0, offset_s]) linear_extrude(length_s_straight, scale=[1, scale_s]) square([width_x, width_s_base], center=true);

      // shackle key semicircular cutout, -z side
      translate([-width_x/2, 0, offset_s + roundover_s_base_offset + eps]) rotate([0, 90, 0]) linear_extrude(width_x) difference() {
        scale(scale_inverse) circle(r=scale_factor * radius_s_base);
        translate([-radius_s_base, 0, 0]) square(2*radius_s_base, center=true);
      }

      // shackle key semicircular cutout, +z side
      translate([width_x/2, 0, offset_s + length_s_straight - roundover_s_top_offset - eps]) rotate([0, 270, 0]) linear_extrude(width_x) difference() {
        scale(scale_inverse) circle(r=scale_factor * radius_s_top);
        translate([-radius_s_top, 0, 0]) square(2*radius_s_top, center=true);
      }
    }

    // lanyard hole
    union() {
      // primary hole
      translate([0, 0, -pommel_z + diameter_l/2 + offset_l]) rotate([90, 0, 0]) scale(scale_inverse) cylinder(d=scale_factor*diameter_l, h=scale_factor*width_y*2, center=true);
      // roundover, -y side
      // translate([0, 0.9*(-width_y + diameter_l), -pommel_z + diameter_l/2 + offset_l]) rotate([90, 0, 0]) linear_extrude(diameter_l, scale=3) scale(scale_inverse) circle(d=scale_factor*diameter_l);
      // roundover, +y side
      // translate([0, 0.9*(width_y - diameter_l), -pommel_z + diameter_l/2 + offset_l]) rotate([270, 0, 0]) linear_extrude(diameter_l, scale=3) scale(scale_inverse) circle(d=scale_factor*diameter_l);
    }
  }
}