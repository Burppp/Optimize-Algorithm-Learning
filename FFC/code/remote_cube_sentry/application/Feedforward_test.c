//
// Created by Lumos on 2024/11/6.
//

#include "Feedforward_test.h"
#include "bsp_dwt.h"

fp32 K_f = 0.6;
fp32 J = 1.942946e-05;
pid_t pid;
uint16_t count = 0;
fp32 speed_set = 0;
fp32 command_last = 0;
fp32 command_dot = 0;
fp32 feedforward_out = 0;

DM_Motor Motor;
Feedforward_t feedforward;
fp32 c[3] = {1.1, 0.45, 0};

void FeedForward_Init()
{
    DM_enable();
    pid_init(&pid, 10, 3, 1.2, 1, 0);
}

_Noreturn void FeedForwardControll_task(void const * argument)
{
    vTaskDelay(INIT_TIME);

    TickType_t last_wake_time = xTaskGetTickCount();

    FeedForward_Init();
    Feedforward_Init(&feedforward, 30, c, 1, 3, 3);

    DWT_Init(168);
    while(1)
    {
        count ++;
        speed_set = 3 * sinf(0.1 * count + 8);
        pid_calc(&pid, Motor.velocity, speed_set);
        feedforward.Output = Feedforward_Calculate(&feedforward, speed_set);

        Speed_CtrlMotor(&hcan1, 0x201, pid.out + feedforward.Output);
//        Speed_CtrlMotor(&hcan1, 0x201, pid.out + feedforward.Output);

        vTaskDelayUntil(&last_wake_time, CHASSIS_PERIOD);
    }
}
