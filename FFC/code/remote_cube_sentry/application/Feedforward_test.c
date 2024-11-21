//
// Created by Lumos on 2024/11/6.
//

#include "Feedforward_test.h"
#include "bsp_dwt.h"

pid_t pid;
uint16_t count = 0;
fp32 speed_set = 0;
fp32 pos_set = 0;
fp32 gap = 0;
fp32 time = 0, last_time = 0;
fp32 real_time = 0;

DM_Motor Motor;
Feedforward_t feedforward;
fp32 c[3] = {1.1, 0.45, 0};

void FeedForward_Init()
{
    DM_enable();
    pid_init(&pid, 30, 20, 9, 0, 0);
    pid.n = 673.871313792833;
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
//        feedforward.Output = Feedforward_Calculate(&feedforward, speed_set);

        time = DWT_GetTimeline_ms();
        real_time = time / 1000;
//        if(time - last_time > 1000)// || gap > 12.5
//        {
//            last_time = time;
//            pos_set = Motor.position + 1.0f;
//        }
//        if(gap > 12.5)
//        {
//            pos_set = Motor.position;
//        }

        speed_set = pid_calc(&pid, Motor.position, pos_set);
        Speed_CtrlMotor(&hcan1, 0x201, speed_set);
        gap = pos_set - Motor.position;
        vTaskDelayUntil(&last_wake_time, CHASSIS_PERIOD);
    }
}
