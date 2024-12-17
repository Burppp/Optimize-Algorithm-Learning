//
// Created by Lumos on 2024/11/6.
//

#include "Feedforward_test.h"
#include "bsp_dwt.h"

extern UART_HandleTypeDef huart6;

pid_t angle_pid, speed_pid;
fp32 time = 0, last_time = 0;
fp32 speed_set = 3, speed_input = 8;
fp32 torque_input = 1.0, angle_input = 3;

DM_Motor Motor;
Feedforward_t feedforward;
fp32 c[3] = {1.1, 0.45, 0};

void FeedForward_Init()
{
    DM_enable(0x03);
    pid_init(&speed_pid, 10, 1, 0.0234350466118701, 23.4350466118702, 0);
    pid_init(&angle_pid, 5, 1, 11.1774502263381, 150.869122727664, 0.195434061899349);
}

feedback_data data;
char frame_head = 'h';
char frame_tail = 'j';
_Noreturn void FeedForwardControll_task(void const * argument)
{
    vTaskDelay(INIT_TIME);

    TickType_t last_wake_time = xTaskGetTickCount();

    FeedForward_Init();

    DWT_Init(168);

    last_time = DWT_GetTimeline_ms();
    while(1)
    {
        time = DWT_GetTimeline_ms();
        if(time - last_time > 5000)
        {
            angle_input = -angle_input;
            last_time = time;
        }

        speed_input = pid_calc(&angle_pid, Motor.position, angle_input);
        torque_input = pid_calc(&speed_pid, Motor.velocity, speed_input);

        MIT_CtrlMotor(&hcan1, 0x03, 0, 0, 0, 0, torque_input);

        data.speed_feedback = Motor.velocity * 1000;
        data.speed_set = speed_input * 1000;

        HAL_UART_Transmit(&huart6, (uint8_t *)&frame_head, sizeof(frame_head), 0xff);
        HAL_UART_Transmit(&huart6, (uint8_t *)&data, sizeof(data), 0xff);
        HAL_UART_Transmit(&huart6, (uint8_t *)&frame_tail, sizeof(frame_tail), 0xff);

        vTaskDelayUntil(&last_wake_time, CHASSIS_PERIOD);
    }
}
