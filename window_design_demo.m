%% 文件：window_design_demo.m
% 目标：手工"发明" fir1 —— 理想低通 × 窗

clear; close all; clc;

fs = 1000;
fc = 100;                  % 截止 100 Hz
N  = 32;                   % 阶数 → 33 个抽头
Wn = 2*fc/fs;              % 归一化截止 = 0.2

%% ① 理想低通（取很多点，近似"砖墙"，只用于对照）
n_big = -2000:2000;
h_ideal_big = Wn * sinc(Wn * n_big);

%% ② 截断到 33 个点（关于 0 对称）
n = -N/2 : N/2;
h_ideal = Wn * sinc(Wn * n);

%% ③ 乘两种窗
h_rect = h_ideal .* rectwin(N+1)';
h_ham  = h_ideal .* hamming(N+1)';

%% ④ 和 fir1 对比（关键一步）
h_fir1 = fir1(N, Wn);
fprintf('手工(Hamming) vs fir1 最大差：%.2e\n', max(abs(h_ham - h_fir1)));

%% ⑤ 三张频谱
[H0, f] = freqz(h_ideal_big, 1, 2048, fs);
[H1, ~] = freqz(h_rect,      1, 2048, fs);
[H2, ~] = freqz(h_ham,       1, 2048, fs);

figure;
subplot(3,1,1); plot(f, 20*log10(abs(H0)), 'LineWidth', 1.2); ylim([-100 5]);
title('① 理想低通（无限长 sinc）'); ylabel('dB'); grid on;
subplot(3,1,2); plot(f, 20*log10(abs(H1)), 'LineWidth', 1.2); ylim([-100 5]);
title('② 截断 = 乘矩形窗：旁瓣约 −13 dB'); ylabel('dB'); grid on;
subplot(3,1,3); plot(f, 20*log10(abs(H2)), 'LineWidth', 1.2); ylim([-100 5]);
title('③ 乘 Hamming 窗：旁瓣约 −53 dB，过渡带变宽'); ylabel('dB'); xlabel('频率 (Hz)'); grid on;