% 示例：调用拟合函数并绘图
%x = [1, 2, 3, 4];          % 输入x值
%y = [1.1, 1.9, 3.2, 4.0];  % 输入y值
x = input;
y = output;
m = 2;                      % 拟合阶数（1为线性）
n = length(x);

% 步骤1：计算拟合系数
coeff = leastSquaresFit(n, x, y, m);

fprintf('拟合系数（阶数 %d）：\n', m);
for i = 0:m
    fprintf('a%d = %.4f\n', i, coeff(i+1)); % MATLAB索引从1开始
end

% 步骤2：计算拟合度 R²
A = x(:).^(0:m);           % 设计矩阵
y_fit = A * coeff;         % 拟合值
SS_res = sum((y(:) - y_fit).^2);  % 残差平方和
SS_tot = sum((y(:) - mean(y)).^2);% 总平方和
R_squared = 1 - SS_res / SS_tot;  % R²值

% 步骤3：生成平滑拟合曲线
x_vals = linspace(min(x), max(x), 100); % 生成密集x值
A_vals = x_vals(:).^(0:m);              % 构造拟合矩阵
y_vals = A_vals * coeff;                % 计算拟合曲线y值

% 步骤4：绘图
figure;
scatter(x, y, 80, 'b', 'filled', 'DisplayName', '样本点'); % 绘制样本点
hold on;
plot(x_vals, y_vals, 'r-', 'LineWidth', 2, 'DisplayName', '拟合曲线'); % 绘制拟合线
hold off;

% 图表美化
xlabel('x');
ylabel('y');
title(sprintf('最小二乘拟合 (阶数 %d), R² = %.4f', m, R_squared));
legend('Location', 'northwest');
grid on;
set(gca, 'FontSize', 12);