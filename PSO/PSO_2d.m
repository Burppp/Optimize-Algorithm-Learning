clear
f = @(x,y) 20+x.^2+y.^2-10*cos(2*pi.*x)-10*cos(2*pi.*y);

x0 = [-5.12:0.05:5.12];
y0 = x0;
[X,Y] = meshgrid(x0,y0);
Z = f(X,Y);
figure(1);
mesh(X,Y,Z);
colormap(parula(25));

N = 50;                 %初始种群个数
d = 2;                  %可行解维度
ger = 100;              %最大迭代次数
limit = [-5.12,5.12];   %位置限制
vlimit = [-5,5];        %速度限制
w = 0.8;                %惯性权重
c1 = 0.5;               %自我学习因子
c2 = 0.5;               %群体学习因子

x = limit(1)+(limit(2)-limit(1)).*rand(N,d);

v = rand(N,d);      
xm = x;             %个体历史最佳位置
ym = zeros(1,d);    %种群历史最佳位置
fxm = ones(N,1)*inf;%个体历史最佳适应度
fym = inf;          %种群历史最佳适应度
record = zeros(ger,1);
hold on

scatter3(x(:,1),x(:,2),f(x(:,1),x(:,2)),'r*');
figure(2);

iter = 1;
while iter <= ger
    fx = f(x(:,1),x(:,2));
    for i=1:N
        if fx(i) < fxm(i)
            fxm(i) = fx(i);
            xm(i,:) = x(i,:);
        end
    end
    if min(fxm) < fym
        [fym,nmin] = min(fxm);
        ym = xm(nmin,:);
    end
    v = v*w + c1*rand*(xm - x) + c2*rand*(repmat(ym,N,1) - x);
    v(v > vlimit(2)) = vlimit(2);
    v(v < vlimit(1)) = vlimit(1);
    x = x + v;
    x(x > limit(2)) = limit(2);
    x(x < limit(1)) = limit(1);
    record(iter) = fym;
    subplot(1,2,1);
    mesh(X,Y,Z);
    hold on
    scatter3(x(:,1),x(:,2),f(x(:,1),x(:,2)),'-ro');
    title(['状态位置变化','-迭代次数：',num2str(iter)]);
    subplot(1,2,2);
    plot(record);
    title('最有适应度进化过程');
    pause(0.01);
    iter = iter + 1;
end

figure(4);
mesh(X,Y,Z);
hold on
scatter3(x(:,1),x(:,2),f(x(:,1),x(:,2)),'-ro');
title('最终状态位置')
disp(['最优值：',num2str(fym)]);
disp(['变量取值：',num2str(ym)]);
