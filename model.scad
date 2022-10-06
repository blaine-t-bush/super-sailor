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
// Length of shackle key
length_s = 100;
// Offset of shackle key from where shaft meets pommel
offset_s = 10;
// Thickness of tool around shackle key
thickness_s = 6;
// Eyelet outer diameter
eyelet_od = 10;
// Eyelet inner diameter
eyelet_id = 6;
// Eyelet shaft length
eyelet_shaft_length = 2.5;
// Eyelet shaft diameter
eyelet_shaft_width = 7.5;

// Epsilon to ensure no false borders
eps = 0.01;

// Scale factor to increase smoothing (1 = no increase)
scale_factor = 20;
scale_inverse = 1/scale_factor;

// Shackle key geometry
tan_taper_y = 2*length/(width_y - width_center - chisel_y/4);
width_s = (length_s - offset_s)/length_s * (width_y - 2*thickness_s);
scale_s = (width_s - 2*(length_s - offset_s)/tan_taper_y)/width_s;

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
      translate([0, -width_center/2, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 1]) {
        difference() {
          difference() {
            sphere(d=width_y);
            translate([0, width_y/4, 0]) cube([width_x, width_y/2, width_x], center=true);
          }
          
          translate([0, 0, width_y/2]) cube(width_y, center=true);
        }
      }

      // pommel hemisphere, +y side
      translate([0, width_center/2, 0]) rotate([180, 0, 0]) scale([width_x/width_y, (width_y - width_center)/width_y, 1]) {
        difference() {
          difference() {
            sphere(d=width_y);
            translate([0, width_y/4, 0]) cube([width_x, width_y/2, width_x], center=true);
          }
          
          translate([0, 0, -width_y/2]) cube(width_y, center=true);
        }
      }

      // pommel flat
      translate([0, width_center/2, 0]) rotate([90, 0, 0]) linear_extrude(width_center) scale([width_x/width_y, 1, 1]) difference() {
        circle(d=width_y);
        translate([0, width_y/2, 0]) square(width_y, center=true);
      }
      
      // pommel eyelet
      difference() {
        union() {
          translate([0, 0, -eyelet_shaft_length - eyelet_od/2 - width_y/2]) scale(scale_inverse) cylinder(h=(scale_factor*(eyelet_shaft_length + eyelet_od)), d=scale_factor*eyelet_shaft_width);
          translate([0, 0, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) scale(scale_inverse) sphere(d=scale_factor*eyelet_od);
        }
        translate([0, 0, -eyelet_shaft_length - width_y/2 - eyelet_od/2]) rotate([90, 0, 0]) scale(scale_inverse) cylinder(h=scale_factor*eyelet_od, d=scale_factor*eyelet_id, center=true);
      }
    }
  }
 
  // all holes
  union() {
    // shackle key
    union() {
      // shackle key rectangular cutout
      translate([0, 0, offset_s]) linear_extrude(length_s, scale=[1, scale_s]) square([width_x, width_s], center=true);

      // shackle key semicircular cutout, -z side
      translate([-width_x/2, 0, offset_s + eps]) rotate([0, 90, 0]) linear_extrude(width_x) difference() {
        scale(scale_inverse) circle(d=scale_factor * width_s);
        translate([-width_s/2, 0, 0]) square(width_s, center=true);
      }

      // shackle key semicircular cutout, +z side
      translate([width_x/2, 0, offset_s + length_s - eps]) rotate([0, 270, 0]) linear_extrude(width_x) difference() {
        scale(scale_inverse) circle(d=scale_factor * scale_s * width_s);
        translate([-scale_s * width_s/2, 0, 0]) square(scale_s * width_s, center=true);
      }
    }
  }
}