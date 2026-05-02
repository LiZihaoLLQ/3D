/*
 EV Battery Pack - sectional/exploded visualization
 Units: millimeters
 Open in OpenSCAD and render (F6). Toggle explode_view.
*/

$fn = 48;

explode_view = true;
exploded_gap = 120;

// Overall dimensions
pack_len = 1800;
pack_wid = 1300;
pack_hei = 150;

// Subassembly heights
bottom_plate_h = 8;
module_zone_h = 105;
top_cover_h = 6;

// Modules
module_cols = 6;
module_rows = 4;
module_len = 250;
module_wid = 240;
module_h = 90;
module_gap_x = 28;
module_gap_y = 20;

// Cooling plate
cooling_plate_h = 6;

// Busbar / BMS simple visuals
busbar_h = 4;
busbar_w = 18;

function offset_z(i) = explode_view ? i * exploded_gap : 0;

module rounded_box(l, w, h, r=8) {
  hull() {
    for (x = [-l/2+r, l/2-r])
      for (y = [-w/2+r, w/2-r])
        translate([x, y, 0]) cylinder(r=r, h=h);
  }
}

module bottom_tray() {
  color("#474b52")
  difference() {
    rounded_box(pack_len, pack_wid, bottom_plate_h + module_zone_h + 18, r=25);
    translate([0,0,6])
      rounded_box(pack_len-36, pack_wid-36, module_zone_h+25, r=18);
  }
}

module cooling_plate() {
  color("#4ea3d9", 0.9)
  rounded_box(pack_len-80, pack_wid-80, cooling_plate_h, r=14);
}

module battery_module() {
  color("#f0f3f6")
  rounded_box(module_len, module_wid, module_h, r=10);

  // top cap
  color("#c9d1d9")
  translate([0,0,module_h])
    rounded_box(module_len-20, module_wid-20, 8, r=6);

  // terminal posts
  color("#d9b44a")
  for (x = [-35, 35])
    translate([x, module_wid/2-35, module_h+8])
      cylinder(r=7, h=12);
}

module module_array() {
  total_x = module_cols * module_len + (module_cols-1)*module_gap_x;
  total_y = module_rows * module_wid + (module_rows-1)*module_gap_y;

  for (i = [0:module_cols-1])
    for (j = [0:module_rows-1]) {
      x = -total_x/2 + module_len/2 + i*(module_len+module_gap_x);
      y = -total_y/2 + module_wid/2 + j*(module_wid+module_gap_y);
      translate([x,y,0]) battery_module();
    }
}

module busbar_layer() {
  color("#e0a458")
  union() {
    // horizontal bars
    for (j = [0:module_rows-1]) {
      y = -(module_rows-1)*(module_wid+module_gap_y)/2 + j*(module_wid+module_gap_y) + module_wid/2 - 35;
      translate([0,y,0]) cube([pack_len-380,busbar_w,busbar_h], center=true);
    }
    // vertical bars
    for (i = [0:module_cols-1]) {
      x = -(module_cols-1)*(module_len+module_gap_x)/2 + i*(module_len+module_gap_x) + 35;
      translate([x,0,0]) cube([busbar_w,pack_wid-340,busbar_h], center=true);
    }
  }
}

module bms_box() {
  color("#2f7f5f")
  translate([pack_len/2-220, -pack_wid/2+180, 0])
    rounded_box(260, 140, 34, r=8);

  color("#88d498")
  translate([pack_len/2-220, -pack_wid/2+180, 34])
    rounded_box(220, 100, 6, r=6);
}

module top_cover() {
  color("#6b7280", 0.78)
  difference() {
    rounded_box(pack_len, pack_wid, top_cover_h, r=25);
    for (x = [-pack_len/2+110 : 220 : pack_len/2-110])
      for (y = [-pack_wid/2+90 : 180 : pack_wid/2-90])
        translate([x,y,-1]) cylinder(r=5,h=10);
  }
}

// Assembly (exploded by Z layers)
translate([0,0,offset_z(0)]) bottom_tray();
translate([0,0,bottom_plate_h + 10 + offset_z(1)]) cooling_plate();
translate([0,0,bottom_plate_h + cooling_plate_h + 16 + offset_z(2)]) module_array();
translate([0,0,bottom_plate_h + cooling_plate_h + module_h + 30 + offset_z(3)]) busbar_layer();
translate([0,0,bottom_plate_h + cooling_plate_h + module_h + 20 + offset_z(3)]) bms_box();
translate([0,0,pack_hei + offset_z(4)]) top_cover();
