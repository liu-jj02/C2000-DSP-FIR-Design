# C2000-DSP-FIR-Design

DSP 学习计划 W6：FIR 滤波器的设计与选型。

## 文件

| 文件 | 说明 |
|---|---|
| `fir_structure_demo.m` | FIR 结构（延迟线 + 乘累加）、线性相位与群延迟 |
| `window_design_demo.m` | 手工用 sinc × 窗"发明" fir1，误差 < 1e-15 |
| `designfilt_demo.m` | 按指标设计（80/120 Hz、0.5 dB、60 dB），自动定阶 |
| `fir_param_sweep.m` | 阶数（8/32/128）与窗（矩形/Hann/Hamming/Blackman）扫描 |

## 关键结论

1. **FIR 结构**：`y[n] = Σ h[k]·x[n-k]`，N 阶 = N+1 个抽头
2. **线性相位**：h 对称 → 群延迟恒为 N/2 个样本，波形只延迟、不变形
3. **窗函数法**：理想 sinc × 窗 = `fir1`；直接截断会带来 Gibbs 振铃（旁瓣 −13 dB）
4. **designfilt 更省**：同一指标下 60 阶 vs 窗函数法约 138 阶
5. **参数取舍**：过渡带 ∝ 1/N；窗越好旁瓣越低，但过渡带越宽

## 实测

| 项目 | 结果 |
|---|---|
| designfilt 自动阶数 | 60（61 抽头） |
| 通带范围 | −0.25 ~ +0.24 dB（要求 ±0.5） |
| 阻带最大 | −60.0 dB（要求 ≤ −60） |
| 群延迟 | 30 = 60/2 |
| 阶数扫描 | N=8: 257 Hz / N=32: 81 Hz / N=128: 20 Hz |
| 窗扫描（64 阶） | 矩形 17 Hz / Hann 42 Hz / Hamming 41 Hz / Blackman 54 Hz |

## 运行

MATLAB R2020a 及以上，直接运行任一脚本，无需其他依赖。
