%% 文件：designfilt_demo.m
clear; close all; clc;

fs = 1000;

%% ① 按指标设计（不给阶数，让 MATLAB 自己定）
d = designfilt('lowpassfir', ...
    'PassbandFrequency', 80, ...
    'StopbandFrequency', 120, ...
    'PassbandRipple', 0.5, ...
    'StopbandAttenuation', 60, ...
    'SampleRate', fs);

b  = d.Coefficients;
fprintf('阶数：%d（%d 个抽头）\n', numel(b)-1, numel(b));

%% ② 求频响与群延迟
[H, f] = freqz(d, 2048, fs);
g      = grpdelay(d, f, fs);
HdB    = 20*log10(abs(H) + eps);

%% ③ 检查指标是否满足
idxPass = f <= 80;
idxStop = f >= 120;
fprintf('通带范围：%.2f ~ %.2f dB（要求 ±0.5）\n', min(HdB(idxPass)), max(HdB(idxPass)));
fprintf('阻带最大：%.1f dB（要求 ≤ -60）\n', max(HdB(idxStop)));

%% ④ 三联图
figure;
subplot(3,1,1);
plot(f, HdB, 'LineWidth', 1.3);
xline(80,'k:'); xline(120,'k:'); yline(-60,'r:');
ylim([-100 5]); ylabel('|H| (dB)'); title('幅频响应'); grid on;

subplot(3,1,2);
plot(f, unwrap(angle(H)), 'LineWidth', 1.3);
ylabel('相位 (rad)'); title('相频响应（一条直线 = 线性相位）'); grid on;

subplot(3,1,3);
plot(f, g, 'LineWidth', 1.3);
ylabel('群延迟 (samples)'); xlabel('频率 (Hz)');
title('群延迟（FIR 线性相位 → 水平线）'); grid on;