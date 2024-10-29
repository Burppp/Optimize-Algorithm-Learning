clear
f = @(x)x.*sin(x).*cos(2*x)-2*x.*sin(3*x)+3*x.*sin(4*x);
N = 20;             %初始种群个数
d = 1;              %可行解维度
ger = 100;          %最大迭代次数
limit = [0,50];     %位置限制
vlimit = [-10,10];  %速度限制
w = 0.8;            %惯性权重
c1 = 0.5;           %自我学习因子
c2 = 0.5;           %群体学习因子
figure(1);
ezplot(f,[0,0.01,limit(2)]);

x = limit(1) + (limit(2) - limit(1)).*rand(N,d);
v = rand(N,d);      
xm = x;             %个体历史最佳位置
ym = zeros(1,d);    %种群历史最佳位置
fxm = ones(N,1)*inf;%个体历史最佳适应度
fym = inf;          %种群历史最佳适应度
hold on
plot(xm,f(xm),'ro');
title('初始状态图')
figure(2)

iter = 1;
record = zeros(ger,1);
while iter <= ger
    fx = f(x);
    for i=1:N
        if fx(i) < fxm(i)
            fxm(i) = fx(i);
            xm(i,:)=x(i,:);
        end
    end
    if min(fxm) < fym
        [fym,min_index] = min(fxm);
        ym = xm(min_index,:);
    end
    v = v*w+c1*rand*(xm-x)+c2*rand*(repmat(ym,N,1)-x);
    v(v>vlimit(2)) = vlimit(2);
    v(v<vlimit(1)) = vlimit(1);
    x = x+v;
    x(x>limit(2)) = limit(2);
    x(x<limit(1)) = limit(1);
    record(iter) = fym;
    x0 = 0:0.01:limit(2);
    subplot(1,2,1);
    plot(x0,f(x0),'b-',x,f(x),'ro');
    title('状态位置变化')
    subplot(1,2,2);
    plot(record);
    title('最优适应度进化过程')
    pause(0.01);
    iter = iter + 1;
end

disp(['最大值:',num2str(fym)]);
disp(['变量取值：',num2str(ym)]);
