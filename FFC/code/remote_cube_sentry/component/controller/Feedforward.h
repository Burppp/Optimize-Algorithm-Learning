//
// Created by Lumos on 2024/11/6.
//

#ifndef REMOTE_CUBE_SENTRY_FEEDFORWARD_H
#define REMOTE_CUBE_SENTRY_FEEDFORWARD_H

#include "main.h"
#include "OLS.h"

typedef __packed struct
{
    float c[3]; // G(s) = 1/(c2s^2 + c1s + c0)

    float Ref;
    float Last_Ref;

    float DeadBand;

    uint32_t DWT_CNT;
    float dt;

    float LPF_RC; // RC = 1/omegac

    float Ref_dot;
    float Ref_ddot;
    float Last_Ref_dot;

    uint16_t Ref_dot_OLS_Order;
    Ordinary_Least_Squares_t Ref_dot_OLS;
    uint16_t Ref_ddot_OLS_Order;
    Ordinary_Least_Squares_t Ref_ddot_OLS;

    float Output;
    float MaxOut;

} Feedforward_t;

void Feedforward_Init(
        Feedforward_t *ffc,
        float max_out,
        float *c,
        float lpf_rc,
        uint16_t ref_dot_ols_order,
        uint16_t ref_ddot_ols_order);

float Feedforward_Calculate(Feedforward_t *ffc, float ref);



#endif //REMOTE_CUBE_SENTRY_FEEDFORWARD_H