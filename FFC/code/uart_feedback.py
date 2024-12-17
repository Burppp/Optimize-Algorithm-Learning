import serial
import struct
import csv
import os
from datetime import datetime

# 定义新的反馈数据结构体，取消了time字段
class FeedbackData:
    def __init__(self, _feedback, _set):
        self._feedback = _feedback
        self._set = _set

    def __str__(self):
        return (f"Feedback: {self._feedback}, "
                f"Set: {self._set}")

# 串口配置
ser = serial.Serial(
    port='COM13',  # 串口设备文件，根据实际情况修改
    baudrate=115200,    # 波特率，根据实际情况修改
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=1           # 读取超时时间
)

# 确保CSV文件存在
def ensure_csv_file(file_path):
    if not os.path.exists(file_path):
        with open(file_path, mode='w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['Timestamp', 'Value'])  # 写入表头

# 获取当前时间，精确到毫秒
def get_current_time_ms():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

# 读取串口数据并写入CSV
def read_feedback_data():
    try:
        # 读取数据直到遇到帧尾'j'
        frame = b''
        while True:
            char = ser.read(1)
            if not char:  # 如果没有读取到数据
                break
            frame += char
            if char == b'j':  # 帧尾
                break

        # print(f"Received frame = {frame}")

        # 在帧中向前查找帧头'h'
        start_index = frame.find(b'h')
        if start_index != -1 and frame[start_index + 1:].endswith(b'j'):
            # 提取数据部分
            data = frame[start_index + 1:-1]  # 去掉帧头和帧尾
            # print(f"len(data) = {len(data)}")
            if len(data) == 4:  # 现在数据部分应该有4个字节
                # 使用struct解包数据，'h'表示有符号的16位整数
                _feedback, _set = struct.unpack('<hh', data)
                _feedback = float(_feedback / 1000)
                _set = float(_set / 1000)
                feedback = FeedbackData(_feedback, _set)
                print(f"{get_current_time_ms()}: {feedback}")

                # 写入CSV文件
                with open('feedback.csv', mode='a', newline='') as file:
                    writer = csv.writer(file)
                    writer.writerow([get_current_time_ms(), _feedback])

                with open('set.csv', mode='a', newline='') as file:
                    writer = csv.writer(file)
                    writer.writerow([get_current_time_ms(), _set])
            else:
                print("Received incomplete data.")
        else:
            print("Invalid frame header or footer.")
    except serial.SerialException as e:
        print(f"Serial error: {e}")

# 确保CSV文件存在
ensure_csv_file('feedback.csv')
ensure_csv_file('set.csv')

# 主循环
try:
    while True:
        read_feedback_data()
except KeyboardInterrupt:
    print("Program terminated by user.")
finally:
    ser.close()  # 关闭串口