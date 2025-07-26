SET(SOURCES ui_Home.c
    ui_Complete.c
    ui_Connected.c
    ui_Recording.c
    ui_Healthy.c
    ui_Abnormal.c
    ui.c
    ui_comp_hook.c
    ui_helpers.c
    ui_img_r_png.c
    ui_img_checkmark_circle_png.c
    ui_img_623366413.c
    ui_img_image_png.c
    ui_img_812009816.c
    ui_img_2079530671.c
    ui_img_lungs_png.c
    ui_img_exclamationmark_circle_png.c
    fonts/ui_font_SFpro.c)

add_library(ui ${SOURCES})
