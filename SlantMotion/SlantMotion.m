m = 0.1077;
k = 0.3;
g = 9.8;
theta = 33.94;
v0 = 10.34;
vx0 = v0 * cos(theta);
vy0 = v0 * sin(theta);
z0 = [vx0, vy0];
x0 = 0;
y0 = 0.5;
h = 1.63;
f = @(t,z) [-k * z(1) * sqrt(z(1)^2 + z(2)^2) / m;-k * z(2) * sqrt(z(1)^2 + z(2)^2)/m - g];
[T,Z] = ode45(f, [0,1.3], z0);
vx = Z(:,1);
vy = Z(:,2);

x = x0;
y = y0;
min = h;
min_index = 1;
for i = 1:length(T)-1
    tempx = x(i) + vx(i) * (T(i+1) - T(i));
    tempy = y(i) + vy(i) * (T(i+1) - T(i));
    x = [x;tempx];
    y = [y;tempy];
    if min > abs(h - tempy)
        if tempx < -7
            min = abs(h - tempy);
            min_index = i;
        end
    end
end
x(min_index)
plot(x,y);
hold on
plot(x(min_index), y(min_index), '-o');
