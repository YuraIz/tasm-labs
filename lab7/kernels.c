/********************************************************
 * функции, которые предстоит оптимизировать 
 ********************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "defs.h"

/***************
 * ВРАЩЕНИЕ
 ***************/

/******************************************************
 * Рзные версии функции вращения
 ******************************************************/

/* 
 * naive_rotate - наиваня, базовая версия функции вращения
 */
char naive_rotate_descr[] = "naive_rotate: Naive baseline implementation";
void naive_rotate(int dim, pixel *src, pixel *dst) 
{
    int i, j;

    for (i = 0; i < dim; i++)
	for (j = 0; j < dim; j++)
	    dst[RIDX(dim-1-j, i, dim)] = src[RIDX(i, j, dim)];
}

/* 
 * rotate - ваша текущая версия функции вращения
 * ВАЖНО: вы будете оцениваться по результатам работы этой функции
 */
char rotate_descr[] = "rotate: Current working version";
void rotate(int dim, pixel *src, pixel *dst) 
{
    naive_rotate(dim, src, dst);
}

/*********************************************************************
 * register_rotate_functions - регистрирует разные версии вращения 
 *     внутри драйвера для тестирования. 
 *     Вызовите add_rotate_function() для каждой тестируемой версии.
 *     При запуске драйвера, он выведет отчет о производительности 
 *     каждой зарегистрированной функции
 *********************************************************************/

void register_rotate_functions() 
{
    add_rotate_function(&naive_rotate, naive_rotate_descr);   
    add_rotate_function(&rotate, rotate_descr);   
    /* ... Можете зарегистрировать другие функции вращения */
}


/***************
 * СГЛАЖИВАНИЕ
 **************/

/***************************************************************
 * Разные typedef и вспомогательные функции для сглаживания
 * Этот код можно менять и дополнять
 **************************************************************/

/* Структура для вычисления среднего значения пиксилей */
typedef struct {
    int red;
    int green;
    int blue;
    int num;
} pixel_sum;

/* Вычисления min и max двух целочисленных */
static int min(int a, int b) { return (a < b ? a : b); }
static int max(int a, int b) { return (a > b ? a : b); }

/* 
 * initialize_pixel_sum - инициализация всех полей нулями
 */
static void initialize_pixel_sum(pixel_sum *sum) 
{
    sum->red = sum->green = sum->blue = 0;
    sum->num = 0;
    return;
}

/* 
 * accumulate_sum - складывает соответствующие поля пикселя
 * в структуру суммы
 */
static void accumulate_sum(pixel_sum *sum, pixel p) 
{
    sum->red += (int) p.red;
    sum->green += (int) p.green;
    sum->blue += (int) p.blue;
    sum->num++;
    return;
}

/* 
 * assign_sum_to_pixel - вычисляет среднее
 */
static void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum) 
{
    current_pixel->red = (unsigned short) (sum.red/sum.num);
    current_pixel->green = (unsigned short) (sum.green/sum.num);
    current_pixel->blue = (unsigned short) (sum.blue/sum.num);
    return;
}

/* 
 * avg - возвращает усрдененное значение пикселя в точке (i,j) 
 */
static pixel avg(int dim, int i, int j, pixel *src) 
{
    int ii, jj;
    pixel_sum sum;
    pixel current_pixel;

    initialize_pixel_sum(&sum);
    for(ii = max(i-1, 0); ii <= min(i+1, dim-1); ii++) 
	for(jj = max(j-1, 0); jj <= min(j+1, dim-1); jj++) 
	    accumulate_sum(&sum, src[RIDX(ii, jj, dim)]);

    assign_sum_to_pixel(&current_pixel, sum);
    return current_pixel;
}

/******************************************************
 * Рзные версии функции сглаживания
 ******************************************************/

/*
 * naive_smooth - наиваня, базовая версия функции сглаживания 
 */
char naive_smooth_descr[] = "naive_smooth: Naive baseline implementation";
void naive_smooth(int dim, pixel *src, pixel *dst) 
{
    int i, j;

    for (i = 0; i < dim; i++)
	for (j = 0; j < dim; j++)
	    dst[RIDX(i, j, dim)] = avg(dim, i, j, src);
}

/*
 * smooth - ваша текущая версия функции сглаживания
 * ВАЖНО: вы будете оцениваться по результатам работы этой функции
 */
char smooth_descr[] = "smooth: Current working version";
void smooth(int dim, pixel *src, pixel *dst) 
{
    naive_smooth(dim, src, dst);
}

/********************************************************************* 
 * register_smooth_functions - регистрирует разные версии сглаживания 
 *     внутри драйвера для тестирования. 
 *     Вызовите add_smooth_function() для каждой тестируемой версии.
 *     При запуске драйвера, он выведет отчет о производительности 
 *     каждой зарегистрированной функции
 *********************************************************************/

void register_smooth_functions() {
    add_smooth_function(&smooth, smooth_descr);
    add_smooth_function(&naive_smooth, naive_smooth_descr);
    /* ... Можете зарегистрировать другие функции сглаживания */
}

