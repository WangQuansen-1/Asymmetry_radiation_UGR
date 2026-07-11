# 完全独立的 MATLAB 声学理论模型

本目录与 `prototype_theory_fit` 相互独立。理论求解器运行时不加载 `.mph`、不调用 COMSOL/LiveLink、不读取 COMSOL 曲线，也不拟合或缩放到 COMSOL。

## 运行

```matlab
cd('G:\非对称辐射\理论codex\prototype_first_principles')
result = run_first_principles_model( ...
    'Resolution','standard', ...
    'UseParallel',true);
```

默认使用 8 个 MATLAB worker 按频率并行。结构、材料、点源及探针参数均固化在 `prototype_parameters.m`。

## 理论组成

- 八个真实环形扇区侧腔；
- 三维 Legendre-Galerkin 弱式腔体模型；
- 官方热黏边界层阻抗的热/黏表面算子；
- 圆管传播模态与倏逝模态；
- 外壁角点单极点源；
- 与原模型一致的探针顺序、DFT 及 Forward/Backward/F1/B1 定义；
- COMSOL 相量约定 `exp(+i*omega*t)`。

同一开口的 Green 自作用目前使用局部 Neumann 半空间核及解析面积平均；不同开口之间使用完整圆管模态 Green。这一处理数值稳定，但大开口上的局部半空间近似仍是当前主要理论误差。要获得严格的圆管自作用，下一版应实现 Duffy 奇异双积分。

## 单独与 COMSOL 比较

必须先完成理论计算，再运行：

```matlab
comparison = compare_with_comsol;
```

比较脚本只生成误差表和图片，不会把误差反馈给理论求解器。

## 当前状态

程序已经完全脱离 COMSOL，并通过腔体径向基函数收敛检查。它尚未达到与 COMSOL 全频一致；请勿把当前误差解释为已经拟合成功。历史拟合程序和所有已有结果均保留，未删除。
