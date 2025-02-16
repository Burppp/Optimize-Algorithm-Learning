function coeff = leastSquaresFit(n, x, y, m)
    % 最小二乘法多项式拟合（函数部分不变）
    if n ~= length(x) || n ~= length(y)
        error('样本点数与x或y的长度不一致');
    end
    if m < 0 || round(m) ~= m
        error('拟合阶数必须为非负整数');
    end
    if n < m+1
        warning('样本点数不足，可能无法得到唯一解');
    end
    A = x(:).^(0:m);  
    coeff = A \ y(:);
end

