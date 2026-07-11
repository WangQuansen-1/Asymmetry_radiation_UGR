# 特征频率、Forward 与 Backward 专项比较

## 定义

对每个复本征模分别计算

\[
\mathrm{Forward}=\frac{Eoz1}{Eoz1+Eoz0+Eoz_{-1}},
\qquad
\mathrm{Backward}=\frac{Eof1}{Eof1+Eof0+Eof_{-1}}.
\]

本次模式配对只使用复特征频率、Forward 和 Backward，不使用其余四个通道
作为主配对量。

## 全谱结果

| 项目 | 数值 |
|---|---:|
| COMSOL 特征值总数 | 60 |
| COMSOL 物理模 | 31 |
| COMSOL PML 主导模 | 29 |
| MATLAB 理论候选模 | 31 |
| 完成配对的物理模 | 31 |
| 高置信度配对 | 5 |
| 全部物理配对实频 RMSE | 28.174 Hz |
| 全部物理配对实频中位绝对误差 | 17.918 Hz |
| 全部物理配对虚频 RMSE | 43.571 Hz |
| 全部物理配对 Forward RMSE | 0.25614 |
| 全部物理配对 Backward RMSE | 0.26313 |
| 高置信度实频 RMSE | 0.61482 Hz |
| 高置信度 Forward RMSE | 0.02190 |
| 高置信度 Backward RMSE | 0.02001 |

“全部物理配对”包含低置信度和密集近简并模式，整体 RMSE 不能解释为每一个
模式都已高精度重现。高置信度统计更能代表当前理论对可唯一识别模式的表现。

## 1479 Hz 目标模

| 数量 | COMSOL | MATLAB | MATLAB − COMSOL |
|---|---:|---:|---:|
| 实频率 (Hz) | 1479.181830 | 1478.730811 | −0.451018 |
| 虚频率 (Hz) | 4.276055 | 4.272546 | −0.003509 |
| Forward | 0.989619 | 0.984267 | −0.005352 |
| Backward | 0.993294 | 0.988888 | −0.004407 |

## 输出文件

- `output_eigen_fb/eigenfrequency_forward_backward_comparison.csv`：31 个物理模
  的逐模复频率、Forward、Backward、误差、配对代价与置信度；
- `output_eigen_fb/all_comsol_eigenfrequency_forward_backward.csv`：全部 60 个
  COMSOL 模。PML 主导模的理论列保留为空值；
- `output_eigen_fb/eigenfrequency_forward_backward_summary.csv`：汇总统计；
- `output_eigen_fb/matlab_eigenfrequency_forward_backward.csv`：31 个 MATLAB
  候选模的原始结果。
