# 原型声学理论拟合程序

入口文件：`run_prototype_theory_fit.m`

程序通过 COMSOL 6.4 LiveLink 只读加载工作区根目录下的 `原型.mph`，直接读取已保存的 41 个频域解，不重新求解、不保存或修改 MPH 文件。

## 运行

先启动本地 COMSOL Server（当前机器通常已经在 2036 端口运行），然后在 MATLAB 中执行：

```matlab
cd('G:\非对称辐射\理论codex\prototype_theory_fit')
result = run_prototype_theory_fit;
```

默认入口只完成“原型 COMSOL 数据读取—MATLAB 降阶理论计算—误差比较”，不会搜索或重算新几何。

提高多起点次数和最大共享极点数：

```matlab
result = run_prototype_theory_fit( ...
    'MaxPoles', 7, ...
    'MultiStarts', 20, ...
    'TargetError', 1e-3);
```

强制重新从 MPH 提取数据：

```matlab
result = run_prototype_theory_fit('ForceExtract', true);
```

## 模型构成

1. 四点离散角向傅里叶变换，严格保持 COMSOL 中 `Ez1/Ez0/Ez_1/Ef1/Ef0/Ef_1`、`Forward/Backward`、`F1/B1` 的定义。
2. 六个功率通道使用共享复极点的正值 Fano/TCMT 降阶模型；共享极点保证六条曲线来自同一组结构共振，而不是六次互不相关的插值。
3. 极点数从 1 自动增加，采用多起点非线性优化和线性变量投影；达到目标误差或连续增加阶数不再显著降低误差时停止。
4. 六个通道共用同一组结构极点，Forward/Backward 与 F1/B1 由六通道理论功率重新计算，而不是单独拟合。
5. 几何参数、点源坐标和探针坐标均从当前 `原型.mph` 读取并归档。

## 主要输出

输出位于 `output/`：

- `comsol_reference.csv`：从 MPH 提取的基准数据；
- `theory_fit.csv`：降阶理论模型结果；
- `fit_error.csv`：各通道及 F/B/F1/B1 误差；
- `fit_history.csv`：不同共享极点阶数的收敛过程；
- `geometry_parameters.csv`：当前有效几何参数；
- `reduced_model.mat`：识别后的共享极点和通道系数；
- `six_channel_fit.png`、`forward_backward_fit.png`：COMSOL 与 MATLAB 理论对比图。

当前程序在原型模型保存的 2582.5–2622.5 Hz 频带内经过标定。超出该频带或改变几何参数后，需要新的 COMSOL 数据重新标定，不能把带内误差直接当作外推误差。
