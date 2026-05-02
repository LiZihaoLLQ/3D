/*
 EV Battery Pack - sectional/exploded visualization
 Refined with Tesla-inspired structural pack cues:
 - cell-to-pack style dense cylindrical cell layout
 - serpentine cooling channels
 - perimeter crash rail + cross members
 - simplified high-voltage manifold and service disconnect
 Units: millimeters
 Open in OpenSCAD and render (F6). Toggle explode_view.
*/

$fn = 56;

explode_view = true;
exploded_gap = 105;

// Overall dimensions
pack_len = 1800;
pack_wid = 1300;
pack_hei = 150;

// Subassembly heights
bottom_plate_h = 8;
module_zone_h = 105;
top_cover_h = 6;

// Tesla-like large cylindrical cells (visual approximation)
cell_d = 46;
cell_h = 82;
cell_pitch = 52;
module_cols = 6;
module_rows = 4;
module_len = 250;
module_wid = 240;
module_h = 90;
module_gap_x = 28;
module_gap_y = 20;

// Cooling plate
cooling_plate_h = 7;
channel_w = 10;
channel_d = 3.2;

// Busbar / HV elements
busbar_h = 3;
busbar_w = 14;

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
    rounded_box(pack_len, pack_wid, bottom_plate_h + module_zone_h + 20, r=25);
    translate([0,0,6])
      rounded_box(pack_len-34, pack_wid-34, module_zone_h+28, r=18);
  }

  // Perimeter crash rail
  color("#3b4048")
  difference() {
    translate([0,0,bottom_plate_h+2]) rounded_box(pack_len-58, pack_wid-58, 24, r=18);
    translate([0,0,bottom_plate_h+2]) rounded_box(pack_len-112, pack_wid-112, 24.1, r=12);
  }

  // Cross members for structural pack stiffness
  color("#555c66")
  for (x = [-pack_len/3, 0, pack_len/3])
    translate([x,0,bottom_plate_h+3]) cube([20, pack_wid-120, 20], center=true);
}

module cooling_plate() {
  color("#4ea3d9", 0.92)
  difference() {
    rounded_box(pack_len-80, pack_wid-80, cooling_plate_h, r=14);

    // Serpentine channels (visual approximation)
    for (row = [-3:3]) {
      y = row * 90;
      for (x = [-pack_len/2+170 : 180 : pack_len/2-170]) {
        translate([x, y, cooling_plate_h-channel_d])
          rounded_box(120, channel_w, channel_d+0.5, r=3);
      }
      if (row < 3) {
        x_join = (row % 2 == 0) ? pack_len/2-170 : -pack_len/2+170;
        translate([x_join, y+45, cooling_plate_h-channel_d])
          rounded_box(channel_w, 90, channel_d+0.5, r=3);
      }
    }
  }

  // Coolant inlet/outlet manifold
  color("#2b6f99") {
    translate([-pack_len/2+130, -pack_wid/2+95, cooling_plate_h]) cylinder(d=24, h=20);
    translate([ pack_len/2-130, -pack_wid/2+95, cooling_plate_h]) cylinder(d=24, h=20);
  }
}

module cell_cluster() {
  // Hex-packed cylindrical cells, Tesla-like 4680 visual language
  color("#dde3ea")
  for (iy = [0:3])
    for (ix = [0:3]) {
      x = (ix-1.5) * cell_pitch + ((iy % 2) * cell_pitch/2);
      y = (iy-1.5) * (cell_pitch*0.88);
      translate([x,y,0]) cylinder(d=cell_d, h=cell_h);
    }

  // Dielectric foam/top interface
  color("#c9d1d9", 0.85)
  translate([0,0,cell_h]) rounded_box(module_len-24, module_wid-24, 6, r=6);
}

module battery_module() {
  color("#f0f3f6")
  rounded_box(module_len, module_wid, module_h, r=10);

  translate([0,0,4]) cell_cluster();

  // Terminal block
  color("#d9b44a")
  for (x = [-34, 34])
    translate([x, module_wid/2-34, module_h+2]) cylinder(r=6.5, h=10);
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
    // Row busbars
    for (j = [0:module_rows-1]) {
      y = -(module_rows-1)*(module_wid+module_gap_y)/2 + j*(module_wid+module_gap_y) + module_wid/2 - 34;
      translate([0,y,0]) cube([pack_len-380,busbar_w,busbar_h], center=true);
    }
    // Column busbars
    for (i = [0:module_cols-1]) {
      x = -(module_cols-1)*(module_len+module_gap_x)/2 + i*(module_len+module_gap_x) + 34;
      translate([x,0,0]) cube([busbar_w,pack_wid-340,busbar_h], center=true);
    }
  }

  // High voltage service disconnect (orange block)
  color("#f97316")
  translate([0,-pack_wid/2+170,busbar_h]) rounded_box(90, 56, 24, r=5);
}

module bms_box() {
  color("#2f7f5f")
  translate([pack_len/2-220, -pack_wid/2+180, 0])
    rounded_box(260, 140, 34, r=8);

  color("#88d498")
  translate([pack_len/2-220, -pack_wid/2+180, 34])
    rounded_box(220, 100, 6, r=6);

  // LV connector hint
  color("#111827")
  translate([pack_len/2-100, -pack_wid/2+228, 10]) cube([24, 18, 10], center=true);
}

module top_cover() {
  color("#6b7280", 0.78)
  difference() {
    rounded_box(pack_len, pack_wid, top_cover_h, r=25);
    for (x = [-pack_len/2+110 : 220 : pack_len/2-110])
      for (y = [-pack_wid/2+90 : 180 : pack_wid/2-90])
        translate([x,y,-1]) cylinder(r=5,h=10);
  }

  // Adhesive bead line visual
  color("#9ca3af", 0.65)
  translate([0,0,top_cover_h])
    difference() {
      rounded_box(pack_len-90, pack_wid-90, 2, r=20);
      rounded_box(pack_len-130, pack_wid-130, 2.2, r=15);
    }
}

// Assembly (exploded by Z layers)
translate([0,0,offset_z(0)]) bottom_tray();
translate([0,0,bottom_plate_h + 12 + offset_z(1)]) cooling_plate();
translate([0,0,bottom_plate_h + cooling_plate_h + 16 + offset_z(2)]) module_array();
translate([0,0,bottom_plate_h + cooling_plate_h + module_h + 30 + offset_z(3)]) busbar_layer();
translate([0,0,bottom_plate_h + cooling_plate_h + module_h + 20 + offset_z(3)]) bms_box();
translate([0,0,pack_hei + offset_z(4)]) top_cover();
