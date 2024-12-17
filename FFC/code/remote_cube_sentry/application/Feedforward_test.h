//
// Created by Lumos on 2024/11/6.
//

#ifndef REMOTE_CUBE_SENTRY_FEEDFORWARD_TEST_H
#define REMOTE_CUBE_SENTRY_FEEDFORWARD_TEST_H

#include "cmsis_os.h"
#include "bsp_can.h"
#include "PID.h"
#include "arm_math.h"
#include "user_lib.h"
#include "Feedforward.h"

#define INIT_TIME 150
#define CHASSIS_PERIOD 10

extern CAN_HandleTypeDef hcan1;

typedef struct
{
//    uint32_t time;
    int16_t torque_feedback;
    int16_t torque_set;
}feedback_data;

void FeedForwardControll_task(void const * argument);
void FeedForward_Init();

#endif //REMOTE_CUBE_SENTRY_FEEDFORWARD_TEST_H
