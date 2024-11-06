//
// Created by Lumos on 2024/11/6.
//

#ifndef REMOTE_CUBE_SENTRY_OLS_H
#define REMOTE_CUBE_SENTRY_OLS_H

#include "stdint.h"
#include "main.h"
#include "cmsis_os.h"

typedef __packed struct
{
    uint16_t Order;
    uint32_t Count;

    float *x;
    float *y;

    float k;
    float b;

    float StandardDeviation;

    float t[4];
} Ordinary_Least_Squares_t;

void OLS_Init(Ordinary_Least_Squares_t *OLS, uint16_t order);
void OLS_Update(Ordinary_Least_Squares_t *OLS, float deltax, float y);
float OLS_Derivative(Ordinary_Least_Squares_t *OLS, float deltax, float y);

#endif //REMOTE_CUBE_SENTRY_OLS_H
