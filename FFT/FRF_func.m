function H = FRF_func(U, Y, Fs)
    % FRF_func 计算频率响应函数（FRF）
    % 输入参数：
    % U - 输入信号的FFT
    % Y - 输出信号的FFT
    % Fs - 采样频率
    % 输出参数：
    % H - 频率响应函数的复数值数组

    % 计算单边频谱的长度
    N = length(U);
    % 计算频率向量
    f = (0:N-1)*(Fs/N);
    % 计算频率响应函数（FRF）
    H = Y ./ U;
    % 只取一半的频率响应（单边频谱）
    H = H(1:N/2+1);
    % 相应的频率向量
    f = f(1:N/2+1);
end