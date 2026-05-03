# 3D

一个用于展示 3D 模型的静态页面，默认读取仓库根目录下的 `model.glb`。

## 使用方式

1. 将你的模型文件命名为 `model.glb` 放在项目根目录。
2. 启动一个本地静态服务器，例如：

```bash
python3 -m http.server 8000
```

3. 浏览器访问 `http://localhost:8000/index.html`。


## 电池包底板独立建模与拓扑优化

仓库新增了可直接修改的参数化模型与分析说明：

- `battery_baseplate.scad`：
  - `raw_baseplate()`：底板初始方案（独立建模）。
  - `optimized_baseplate()`：按多工况拓扑优化结果重建的工程可制造方案。
- `topo_optimization_plan.md`：多工况受力、拓扑优化参数、重建原则。

### 快速使用

1. 安装 OpenSCAD。
2. 打开 `battery_baseplate.scad`。
3. 通过注释切换展示：
   - 初始底板：启用 `raw_baseplate();`
   - 优化底板：启用 `optimized_baseplate();`
4. 按项目需求修改尺寸、筋高、孔位和工况权重。
