# 全部特征频率比较结果

## 范围和方法

COMSOL `dset1` 共包含 60 个复特征频率，实部范围为
1256.438–1825.909 Hz。MATLAB 使用五个复频移位覆盖低 Q、高 Q 和中等损耗
分支，每个移位提取 28 个本征对；严格去重后得到 31 个开放系统物理候选模。

COMSOL 的有限 PML 会额外产生离散特征模，而 MATLAB 使用解析圆管辐射边界，
不会产生这类人工模。因此对每个 COMSOL 模计算

\[
r_{\mathrm{PML}}=
\frac{\int_{\Omega_{\mathrm{PML}}}|p|^2\,dV}
{\int_{\Omega_{\mathrm{all}}}|p|^2\,dV}.
\]

采用 `pml_fraction < 0.30` 作为物理模判据。该阈值恰好将 60 个 COMSOL
特征值分为 31 个物理模和 29 个 PML 主导模，并与 MATLAB 的 31 个开放系统
候选模逐一配对。全部 60 个模都保留在分类表中；PML 主导模不会被强行分配
一个不存在的解析辐射边界本征模。

## 汇总

| 指标 | 数值 |
|---|---:|
| COMSOL 总模数 | 60 |
| COMSOL 物理模 | 31 |
| COMSOL PML 主导模 | 29 |
| MATLAB 候选模 | 31 |
| 完成一对一配对 | 31 |
| 全部配对实频 RMSE | 29.142 Hz |
| 全部配对实频中位绝对误差 | 16.524 Hz |
| 全部配对虚频 RMSE | 41.906 Hz |
| 全部配对六通道 RMSE | 0.28698 |
| 高置信度配对数 | 9 |
| 高置信度实频 RMSE | 4.482 Hz |
| 高置信度六通道 RMSE | 0.01354 |

全配对统计包含若干低置信度模式，不能把 29.142 Hz 解释为所有物理模已经
高精度复现。高置信度集合更能反映当前模型对可识别模式的性能。

目标模仍保持良好一致：

| 来源 | 复特征频率 (Hz) |
|---|---:|
| COMSOL | 1479.181830 + 4.276055i |
| MATLAB | 1478.730811 + 4.272546i |

## 文件

- `comsol_all_eigenmodes.csv`：60 个 COMSOL 复频率和六通道基准；
- `comsol_pml_participation.csv`：逐模 PML 能量占比；
- `output_all_modes/all_comsol_mode_classification.csv`：60 模完整分类；
- `output_all_modes/all_eigenmode_comparison.csv`：31 个物理模逐模误差；
- `output_all_modes/all_eigenmode_summary.csv`：统计摘要。

## 当前限制

低置信度配对的主要误差来自：默认内部刚性壁面尚未加入完整热黏表面算子；
开放端算子目前以目标 \(|m|=1,n=0\) 圆管模态线性化；密集近简并模仅用复频率
和六通道进行配对，尚未加入全场子空间 MAC。这些限制不会影响 PML 模分类，
但会影响低 Q 模的虚部和部分非目标模的通道精度。
