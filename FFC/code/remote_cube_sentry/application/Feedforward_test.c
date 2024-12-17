//
// Created by Lumos on 2024/11/6.
//

#include "Feedforward_test.h"
#include "bsp_dwt.h"

extern UART_HandleTypeDef huart6;

pid_t pid;
fp32 time = 0, last_time = 0;
fp32 torque_set = 0.2;

DM_Motor Motor;
Feedforward_t feedforward;
fp32 c[3] = {1.1, 0.45, 0};

void FeedForward_Init()
{
    DM_enable();
    pid_init(&pid, 30, 20, 9, 0, 0);
    pid.n = 673.871313792833;
}

feedback_data data;
char frame_head = 'h';
char frame_tail = 'j';
_Noreturn void FeedForwardControll_task(void const * argument)
{
    vTaskDelay(INIT_TIME);

    TickType_t last_wake_time = xTaskGetTickCount();

    FeedForward_Init();
    Feedforward_Init(&feedforward, 30, c, 1, 3, 3);

    DWT_Init(168);

    last_time = DWT_GetTimeline_ms();
    while(1)
    {
        time = DWT_GetTimeline_ms();
        if(time - last_time > 1000)
        {
            torque_set = -torque_set;
            last_time = time;
        }
//        torque_set = 0.2 * arm_sin_f32(0.001 * time + 3);

        MIT_CtrlMotor(&hcan1, 0x03, 0, 0, 0, 0, torque_set);

        data.torque_feedback = Motor.torque * 1000;
        data.torque_set = torque_set * 1000;

        HAL_UART_Transmit(&huart6, (uint8_t *)&frame_head, sizeof(frame_head), 0xff);
        HAL_UART_Transmit(&huart6, (uint8_t *)&data, sizeof(data), 0xff);
        HAL_UART_Transmit(&huart6, (uint8_t *)&frame_tail, sizeof(frame_tail), 0xff);

        vTaskDelayUntil(&last_wake_time, CHASSIS_PERIOD);
    }
}
