% h = [0.1 0.2 0.4 0.2 0.1];      % 对称 —— 这是线性相位的标志
% x = [1 2 3 4 5];
% 
% y_conv = conv(x, h);
% y_filt = filter(h, 1, x);
% 
% fprintf('h = %s（%d 个抽头 = %d 阶）\n', mat2str(h), numel(h), numel(h)-1);
% fprintf('conv 长度 %d，filter 长度 %d\n', numel(y_conv), numel(y_filt));
% fprintf('filter == conv(1:Nx) ? %d\n', isequal(y_filt, y_conv(1:numel(x))));
% 
% [g, w] = grpdelay(h, 1, 512);
% fprintf('群延迟：均值 %.2f 个样本（理论 %.1f）\n', mean(g), (numel(h)-1)/2);
% 
% plot(w/pi, g, 'LineWidth', 1.5);
% xlabel('归一化频率 (×π rad/sample)'); ylabel('群延迟 (samples)');
% title('线性相位 FIR 的群延迟是常数'); grid on;

%% 文件：linear_phase_demo.m
h_sym  = [0.1 0.2 0.4 0.2 0.1];      % 对称（和 = 1）
h_asym = [0.1 0.3 0.4 0.1 0.1];      % 不对称（和也 = 1，只换了顺序）

[g1, w] = grpdelay(h_sym,  1, 512);
[g2, ~] = grpdelay(h_asym, 1, 512);

figure;
subplot(2,1,1);
plot(w/pi, g1, 'LineWidth', 1.5); hold on;
plot(w/pi, g2, '--', 'LineWidth', 1.5);   % ✅

legend('对称（线性相位）', '不对称（非线性相位）');
ylabel('群延迟 (samples)'); title('群延迟：不对称就弯'); grid on;

%% 方波通过两个滤波器
x  = [ones(1,20) -ones(1,20)];
y1 = filter(h_sym,  1, x);
y2 = filter(h_asym, 1, x);

subplot(2,1,2);
plot(x, 'k:', 'LineWidth', 1); hold on;
plot(y1, 'LineWidth', 1.5);
plot(y2, '--', 'LineWidth', 1.5);

legend('输入方波', '对称 FIR', '不对称 FIR');
title('看边沿：对称的左右对称，不对称的一边陡一边缓'); grid on;