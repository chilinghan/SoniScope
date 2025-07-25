/*
 * SPDX-FileCopyrightText: 2024-2025 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#pragma once

// *INDENT-OFF*

#include "board/esp_panel_board_conf_internal.h"

// Espressif
#ifndef BOARD_ESPRESSIF_ESP32_C3_LCDKIT
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_C3_LCDKIT
        #define BOARD_ESPRESSIF_ESP32_C3_LCDKIT CONFIG_BOARD_ESPRESSIF_ESP32_C3_LCDKIT
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_BOX
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX
        #define BOARD_ESPRESSIF_ESP32_S3_BOX CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_BOX_3
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_3
        #define BOARD_ESPRESSIF_ESP32_S3_BOX_3 CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_3
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_BOX_3_BETA
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_3_BETA
        #define BOARD_ESPRESSIF_ESP32_S3_BOX_3_BETA CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_3_BETA
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_BOX_LITE
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_LITE
        #define BOARD_ESPRESSIF_ESP32_S3_BOX_LITE CONFIG_BOARD_ESPRESSIF_ESP32_S3_BOX_LITE
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_EYE
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_EYE
        #define BOARD_ESPRESSIF_ESP32_S3_EYE CONFIG_BOARD_ESPRESSIF_ESP32_S3_EYE
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_KORVO_2
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_KORVO_2
        #define BOARD_ESPRESSIF_ESP32_S3_KORVO_2 CONFIG_BOARD_ESPRESSIF_ESP32_S3_KORVO_2
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD
        #define BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_V1_5
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_V1_5
        #define BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_V1_5 CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_V1_5
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2
        #define BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2 CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2_V1_5
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2_V1_5
        #define BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2_V1_5 CONFIG_BOARD_ESPRESSIF_ESP32_S3_LCD_EV_BOARD_2_V1_5
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_S3_USB_OTG
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_S3_USB_OTG
        #define BOARD_ESPRESSIF_ESP32_S3_USB_OTG CONFIG_BOARD_ESPRESSIF_ESP32_S3_USB_OTG
    #endif
#endif
#ifndef BOARD_ESPRESSIF_ESP32_P4_FUNCTION_EV_BOARD
    #ifdef CONFIG_BOARD_ESPRESSIF_ESP32_P4_FUNCTION_EV_BOARD
        #define BOARD_ESPRESSIF_ESP32_P4_FUNCTION_EV_BOARD CONFIG_BOARD_ESPRESSIF_ESP32_P4_FUNCTION_EV_BOARD
    #endif
#endif

// Elecrow
#ifndef BOARD_ELECROW_CROWPANEL_7_0
    #ifdef CONFIG_BOARD_ELECROW_CROWPANEL_7_0
        #define BOARD_ELECROW_CROWPANEL_7_0 CONFIG_BOARD_ELECROW_CROWPANEL_7_0
    #endif
#endif

// M5Stack
#ifndef BOARD_M5STACK_M5CORE2
    #ifdef CONFIG_BOARD_M5STACK_M5CORE2
        #define BOARD_M5STACK_M5CORE2 CONFIG_BOARD_M5STACK_M5CORE2
    #endif
#endif
#ifndef BOARD_M5STACK_M5DIAL
    #ifdef CONFIG_BOARD_M5STACK_M5DIAL
        #define BOARD_M5STACK_M5DIAL CONFIG_BOARD_M5STACK_M5DIAL
    #endif
#endif
#ifndef BOARD_M5STACK_M5CORES3
    #ifdef CONFIG_BOARD_M5STACK_M5CORES3
        #define BOARD_M5STACK_M5CORES3 CONFIG_BOARD_M5STACK_M5CORES3
    #endif
#endif

// Jingcai
#ifndef BOARD_JINGCAI_ESP32_4848S040C_I_Y_3
    #ifdef CONFIG_BOARD_JINGCAI_ESP32_4848S040C_I_Y_3
        #define BOARD_JINGCAI_ESP32_4848S040C_I_Y_3 CONFIG_BOARD_JINGCAI_ESP32_4848S040C_I_Y_3
    #endif
#endif
#ifndef BOARD_JINGCAI_JC8048W550C
    #ifdef CONFIG_BOARD_JINGCAI_JC8048W550C
        #define BOARD_JINGCAI_JC8048W550C CONFIG_BOARD_JINGCAI_JC8048W550C
    #endif
#endif

// Waveshare
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85 CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85_C
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85_C
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85_C CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_1_85_C
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_2_1
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_2_1
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_2_1 CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_2_1
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3 CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3_B
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3_B
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3_B CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_4_3_B
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5 CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5_B
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5_B
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5_B CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_5_B
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_7
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_7
        #define BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_7 CONFIG_BOARD_WAVESHARE_ESP32_S3_TOUCH_LCD_7
    #endif
#endif
#ifndef BOARD_WAVESHARE_ESP32_P4_NANO
    #ifdef CONFIG_BOARD_WAVESHARE_ESP32_P4_NANO
        #define BOARD_WAVESHARE_ESP32_P4_NANO CONFIG_BOARD_WAVESHARE_ESP32_P4_NANO
    #endif
#endif

// VIEWE
#ifndef BOARD_VIEWE_SMARTRING
    #ifdef CONFIG_BOARD_VIEWE_SMARTRING
        #define BOARD_VIEWE_SMARTRING CONFIG_BOARD_VIEWE_SMARTRING
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX24240013_MD50E
    #ifdef CONFIG_BOARD_VIEWE_UEDX24240013_MD50E
        #define BOARD_VIEWE_UEDX24240013_MD50E CONFIG_BOARD_VIEWE_UEDX24240013_MD50E
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX46460015_MD50ET
    #ifdef CONFIG_BOARD_VIEWE_UEDX46460015_MD50ET
        #define BOARD_VIEWE_UEDX46460015_MD50ET CONFIG_BOARD_VIEWE_UEDX46460015_MD50ET
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48480021_MD80E
    #ifdef CONFIG_BOARD_VIEWE_UEDX48480021_MD80E
        #define BOARD_VIEWE_UEDX48480021_MD80E CONFIG_BOARD_VIEWE_UEDX48480021_MD80E
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48480021_MD80E_V2
    #ifdef CONFIG_BOARD_VIEWE_UEDX48480021_MD80E_V2
        #define BOARD_VIEWE_UEDX48480021_MD80E_V2 CONFIG_BOARD_VIEWE_UEDX48480021_MD80E_V2
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48480021_MD80ET
    #ifdef CONFIG_BOARD_VIEWE_UEDX48480021_MD80ET
        #define BOARD_VIEWE_UEDX48480021_MD80ET CONFIG_BOARD_VIEWE_UEDX48480021_MD80ET
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48480028_MD80ET
    #ifdef CONFIG_BOARD_VIEWE_UEDX48480028_MD80ET
        #define BOARD_VIEWE_UEDX48480028_MD80ET CONFIG_BOARD_VIEWE_UEDX48480028_MD80ET
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX24320024E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX24320024E_WB_A
        #define BOARD_VIEWE_UEDX24320024E_WB_A CONFIG_BOARD_VIEWE_UEDX24320024E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX24320028E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX24320028E_WB_A
        #define BOARD_VIEWE_UEDX24320028E_WB_A CONFIG_BOARD_VIEWE_UEDX24320028E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX24320035E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX24320035E_WB_A
        #define BOARD_VIEWE_UEDX24320035E_WB_A CONFIG_BOARD_VIEWE_UEDX24320035E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX32480035E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX32480035E_WB_A
        #define BOARD_VIEWE_UEDX32480035E_WB_A CONFIG_BOARD_VIEWE_UEDX32480035E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48270043E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX48270043E_WB_A
        #define BOARD_VIEWE_UEDX48270043E_WB_A CONFIG_BOARD_VIEWE_UEDX48270043E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX48480040E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX48480040E_WB_A
        #define BOARD_VIEWE_UEDX48480040E_WB_A CONFIG_BOARD_VIEWE_UEDX48480040E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX80480043E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX80480043E_WB_A
        #define BOARD_VIEWE_UEDX80480043E_WB_A CONFIG_BOARD_VIEWE_UEDX80480043E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX80480050E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX80480050E_WB_A
        #define BOARD_VIEWE_UEDX80480050E_WB_A CONFIG_BOARD_VIEWE_UEDX80480050E_WB_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX80480050E_WB_A_2
    #ifdef CONFIG_BOARD_VIEWE_UEDX80480050E_WB_A_2
        #define BOARD_VIEWE_UEDX80480050E_WB_A_2 CONFIG_BOARD_VIEWE_UEDX80480050E_WB_A_2
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX80480050E_AC_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX80480050E_AC_A
        #define BOARD_VIEWE_UEDX80480050E_AC_A CONFIG_BOARD_VIEWE_UEDX80480050E_AC_A
    #endif
#endif

#ifndef BOARD_VIEWE_UEDX80480070E_WB_A
    #ifdef CONFIG_BOARD_VIEWE_UEDX80480070E_WB_A
        #define BOARD_VIEWE_UEDX80480070E_WB_A CONFIG_BOARD_VIEWE_UEDX80480070E_WB_A
    #endif
#endif

// *INDENT-ON*
