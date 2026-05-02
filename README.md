# 3D

## 电动汽车电池包 3D 建模（可分部分展示）

已添加 `ev_battery_pack.scad`，可在 OpenSCAD 中直接打开并查看电池包结构。

### 包含的分层部件
- 下壳体（Bottom Tray）
- 冷却板（Cooling Plate）
- 电池模组阵列（4 x 6）
- 汇流排层（Busbar Layer）
- BMS 控制盒
- 上盖（Top Cover）

### 使用方式
1. 安装并打开 OpenSCAD。
2. 打开 `ev_battery_pack.scad`。
3. 点击预览（F5）或渲染（F6）。
4. 通过文件顶部参数切换分解视图：
   - `explode_view = true;` 开启分层分解展示
   - `explode_view = false;` 关闭分解，查看整包装配
5. 可调整 `exploded_gap` 控制分层间距。

### 参数化建议
可直接修改以下参数生成不同规格电池包：
- `pack_len`, `pack_wid`, `pack_hei`
- `module_cols`, `module_rows`
- `module_len`, `module_wid`, `module_h`
- `module_gap_x`, `module_gap_y`
