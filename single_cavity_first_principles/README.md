# 单腔一阶原理 MATLAB 模型

这是从声学 Helmholtz 方程重新建立的三维 MATLAB 求解器。它不调用 COMSOL、
LiveLink、既有理论/拟合程序，也不使用 TCMT。默认空间离散采用线性四面体
Galerkin FEM；实体壁面为零法向通量，轴向开放端采用圆管模态辐射边界。
`frozen_geometry_mesh.mat` 只保存几何顶点和单元连接关系，不含 COMSOL
矩阵、场解或拟合系数。刚度、质量、辐射矩阵均在 MATLAB 中从弱式重新组装。

## 运行

```matlab
cd('G:\非对称辐射\理论codex\single_cavity_first_principles')
result = run_single_cavity_first_principles;
comparison = compare_independent_with_comsol;
convergence = run_order_convergence;
```

默认使用二次四面体 Galerkin 离散。`run_order_convergence` 会独立比较 P1 与
P2 形函数，检查空间离散收敛。理论求解和 COMSOL 比较是两个分开的步骤；
`comsol_reference.csv` 只由比较脚本读取，不进入求解方程。

## 输出

- `output/independent_result.mat`：本征模与点源频域解；
- `output/six_channel_fractions.csv`：题目要求的六个归一化通道；
- `output/comparison_error.csv`：独立计算与冻结 COMSOL 基准的误差。
- `output/order_convergence.csv`：P1/P2 阶次收敛结果。

通道顺序严格保持模型中的四探针 DFT 约定：下侧为
`Eoz1,Eoz0,Eoz_1`，上侧为 `Eof1,Eof0,Eof_1`。
