/* KallistiOS ##version##

   banner.c
   Copyright (C) 2013 Lawrence Sebald
*/

#define QUOTE(x) #x

static const char banner[] = QUOTE(BANNER);
static const char license[] = QUOTE(LICENSE);
static const char authors[] = QUOTE(AUTHORS);

const char *kos_get_banner(void) {
    __asm__ __volatile__("nop" : : "r"(license), "r"(authors));
    return banner;
}

const char *kos_get_license(void) {
    return license;
}

const char *kos_get_authors(void) {
    return authors;
}
