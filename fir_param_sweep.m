%% 文件：fir_param_sweep.m
clear; close all; clc;

fs = 1000;
Wn = 0.2;                 % 截止 100 Hz

%% ===== ① 阶数：8 / 32 / 128 =====
Nset = [8 32 128];
figure('Name','阶数扫描'); hold on;

fprintf('阶数扫描（Hamming，截止 100 Hz）\n');
fprintf('%-6s %-12s %-10s\n', 'N', '过渡带(Hz)', '群延迟');

for N = Nset
    h = fir1(N, Wn);
    [H, f] = freqz(h, 1, 4096, fs);
    HdB = 20*log10(abs(H) + eps);
    plot(f, HdB, 'LineWidth', 1.1);

    bw = trans_bw(HdB, f, -0.5, -40);
    fprintf('%-6d %-12.0f %-10d\n', N, bw, N/2);
end

xlim([0 300]); ylim([-100 5]); xline(100, 'k:');
xlabel('频率 (Hz)'); ylabel('|H| (dB)');
legend({'N=8','N=32','N=128'}, 'Location', 'southwest');
title('阶数：越高越陡，但延迟越大'); grid on;

%% ===== ② 窗：矩形 / Hann / Hamming / Blackman =====
N = 64;
wins  = {@rectwin, @hann, @hamming, @blackman};
names = {'矩形','Hann','Hamming','Blackman'};

figure('Name','窗扫描'); hold on;
fprintf('\n窗扫描（64 阶，截止 100 Hz）\n');
fprintf('%-10s %-12s %-10s\n', '窗', '过渡带(Hz)', '最高旁瓣(dB)');

for k = 1:numel(wins)
    h = fir1(N, Wn, wins{k}(N+1));
    [H, f] = freqz(h, 1, 4096, fs);
    HdB = 20*log10(abs(H) + eps);
    plot(f, HdB, 'LineWidth', 1.1);

    bw = trans_bw(HdB, f, -0.5, -40);
    idxStop = f > 250;                  % 远离过渡带才是纯旁瓣
    sl = max(HdB(idxStop));
    fprintf('%-10s %-12.0f %-10.0f\n', names{k}, bw, sl);
end

xlim([0 300]); ylim([-120 5]);
xlabel('频率 (Hz)'); ylabel('|H| (dB)');
legend(names, 'Location', 'southwest');
title('窗：旁瓣越低，过渡带越宽'); grid on;

%% ===== 工具函数：量过渡带 =====
function bw = trans_bw(HdB, f, p1, p2)
% 从幅频降到 p1 dB 起，到降到 p2 dB 止，中间的频率跨度
i1 = find(HdB <= p1, 1, 'first');
i2 = find(HdB <= p2, 1, 'first');
if isempty(i1) || isempty(i2)
    bw = NaN;
else
    bw = f(i2) - f(i1);
end
end