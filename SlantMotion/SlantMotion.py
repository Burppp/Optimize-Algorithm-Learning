import math

# 定义参数
m_feibiao = 107.7 / 1000 # 飞镖质量
m_fashezuo = 367.7 / 1000 # 发射座质量
m_dong = 300 / 1000 # 动滑轮总质量

G = 80 * 10**9 # 弹簧剪切模量，Pa，锰钢80 GPa
D = 30 / 1000 # 弹簧直径
d = 3 / 1000 # 弹簧线径
L = 340 / 1000 # 弹簧自然长度
A = 450 / 1000 # 飞镖加速行程
L1= 540 / 1000 # 弹簧预紧时弹簧长度
Lx1= L1 - L # 弹簧预紧时拉伸长度
L2 = L1 + A/4 # 弹簧蓄满时弹簧长度
Lx2 = L2 - L # 弹簧蓄满时拉伸长度

angle = math.radians(33.94) # 发射角，弧度
h_chushi = 0.5 # 发射初始高度，米
g = 9.81 # 重力加速度，m/s^2
efficiency = 0.9 # 系统能量效率
u = 0.1 # 摩擦系数

# 1. 计算弹簧劲度系数 k
n = L / d # 弹簧圈数
k = (G * d**4) / (8 * D**3 * n) # 劲度系数 (N/m)
print(f"弹簧劲度系数 k: {k:.2f} N/m")

# 2. 计算弹簧在加速行程中释放的有效能量
E_tanhuang = (0.5*k*Lx2**2) - (0.5*k*Lx1**2)
print(f"一根弹簧的势能: {E_tanhuang:.2f} J")
E_tanhuang4 = 4*E_tanhuang
print(f"四根弹簧的势能: {E_tanhuang4:.2f} J")
E_tanhuang_eff = E_tanhuang4 * efficiency # 考虑能量效率
print(f"实际四根弹簧的势能（算系统效率）: {E_tanhuang_eff:.2f} J")

# 3. 发射计算总质量
m_total = m_feibiao + m_fashezuo

# 4. 动能定理计算初速度
v = math.sqrt((E_tanhuang_eff-u*(A/4+A)) / (0.5*m_total+m_dong/16))
print(f"飞镖与发射座脱离瞬间速度: {v:.2f} m/s")

# 5. 分解速度分量
v_x = v * math.cos(angle)
v_y = v * math.sin(angle)

# 6. 计算飞行时间和水平距离
t_total = (v_y + math.sqrt(v_y**2 + 2 * g * h_chushi)) / g # 总飞行时间
x_total = v_x * t_total # 水平飞行距离
print(f"飞镖的水平飞行距离: {x_total:.2f} m")
