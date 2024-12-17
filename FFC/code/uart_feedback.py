import serial
import struct

# 定义新的反馈数据结构体，取消了time字段
class FeedbackData:
    def __init__(self, torque_feedback, torque_set):
        self.torque_feedback = torque_feedback
        self.torque_set = torque_set
        # self.checksum = checksum

    def __str__(self):
        return (f"Torque Feedback: {self.torque_feedback}, "
                f"Torque Set: {self.torque_set}")

# 串口配置
ser = serial.Serial(
    port='COM13',  # 串口设备文件，根据实际情况修改
    baudrate=115200,    # 波特率，根据实际情况修改
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=1           # 读取超时时间
)

# 读取串口数据
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

        # 打印完整的帧数据
        print(f"Received frame: {frame}")

        # 在帧中向前查找帧头'h'
        start_index = frame.find(b'h')
        if start_index != -1 and frame[start_index + 1:].endswith(b'j'):
            # 提取数据部分和校验位
            data = frame[start_index + 1:-1]  # 去掉帧头和帧尾
            # print(f"data = {data},len(data) = {len(data)}")
            if len(data) == 2:  # 现在数据部分只有2个字节
                # 使用struct解包数据
                torque_feedback, torque_set = struct.unpack('<BB', data)
                feedback = FeedbackData(torque_feedback, torque_set)
                print(feedback)
            else:
                print("Received incomplete data.")
        else:
            print("Invalid frame header or footer.")
    except serial.SerialException as e:
        print(f"Serial error: {e}")

# 主循环
try:
    while True:
        read_feedback_data()
except KeyboardInterrupt:
    print("Program terminated by user.")
finally:
    ser.close()  # 关闭串口