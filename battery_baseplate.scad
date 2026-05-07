// 电池包底板独立建模 + 拓扑优化后结构重建
// 单位: mm

$fn = 64;

// ---------- 全局参数 ----------
L = 1600;          // 长
W = 1200;          // 宽
T = 4;             // 初始底板厚度
BORDER = 30;       // 边框保留带
RIB_H = 18;        // 加强筋高度
RIB_T = 3;         // 加强筋厚度
MOUNT_D = 16;      // 安装孔孔径

module mount_holes(h) {
  for (p = [
    [80,80], [L-80,80], [80,W-80], [L-80,W-80],
    [L/2,120], [L/2,W-120], [120,W/2], [L-120,W/2]
  ]) {
    translate([p[0], p[1], -1]) cylinder(h = h, d = MOUNT_D);
  }
}

module raw_baseplate(){
  difference(){
    cube([L, W, T], center = false);
    mount_holes(T + 2);
  }
}

// 以“拓扑优化结果”重建：
// 1) 边界连续承载环
// 2) 沿主应力路径的 X 向/十字向筋
// 3) 局部载荷区保留实体岛
module optimized_baseplate(){
  difference() {
    union(){
      // 薄板底层
      cube([L, W, T], center = false);

      // 边框承载带
      difference(){
        translate([0,0,T]) cube([L, W, RIB_T], center = false);
        translate([BORDER, BORDER, T-0.5]) cube([L-2*BORDER, W-2*BORDER, RIB_T+1], center = false);
      }

      // X 向主筋（工况：纵向冲击/弯曲）
      linear_extrude(height = RIB_H)
        polygon(points = [
          [BORDER+20, BORDER+20],
          [BORDER+60, BORDER+20],
          [L-BORDER-20, W-BORDER-20],
          [L-BORDER-60, W-BORDER-20]
        ]);

      linear_extrude(height = RIB_H)
        polygon(points = [
          [L-BORDER-20, BORDER+20],
          [L-BORDER-60, BORDER+20],
          [BORDER+20, W-BORDER-20],
          [BORDER+60, W-BORDER-20]
        ]);

      // 横向筋（工况：托底/石击引起局部弯曲）
      for (y = [W*0.25, W*0.5, W*0.75]){
        translate([BORDER, y-RIB_T/2, T]) cube([L-2*BORDER, RIB_T, RIB_H], center = false);
      }

      // 纵向筋（工况：电池模组质量引起跨距挠度）
      for (x = [L*0.2, L*0.4, L*0.6, L*0.8]){
        translate([x-RIB_T/2, BORDER, T]) cube([RIB_T, W-2*BORDER, RIB_H], center = false);
      }

      // 局部载荷实体岛（千斤顶/吊装/碰撞热点）
      for (p = [[L*0.33, W*0.33], [L*0.66, W*0.66], [L*0.66, W*0.33], [L*0.33, W*0.66]]) {
        translate([p[0]-55, p[1]-55, T]) cube([110, 110, RIB_H*0.6], center = false);
      }
    }

    // 安装孔贯穿优化后结构
    mount_holes(T + RIB_H + 5);
  }
}

// 切换显示：
// raw_baseplate();
optimized_baseplate();
