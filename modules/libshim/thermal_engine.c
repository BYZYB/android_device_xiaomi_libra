#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <string.h>

typedef FILE* (*fopen_t)(const char *filename, const char *mode);
typedef int (*unlink_t)(const char *pathname);

static const char* translate_path(const char* path) {
    if (!strcmp(path, "/data/decrypt.txt"))
        path = "/data/thermal/decrypt.txt";

    return path;
}

FILE* fopen (const char *filename, const char *mode)
{
    static fopen_t o_fopen = NULL;
    if (o_fopen==NULL)
        o_fopen = (fopen_t) dlsym(RTLD_NEXT, "fopen");

    return o_fopen(translate_path(filename), mode);
}

int unlink(const char *pathname)
{
    static unlink_t o_unlink = NULL;
    if (o_unlink==NULL)
        o_unlink = (unlink_t) dlsym(RTLD_NEXT, "unlink");

    return o_unlink(translate_path(pathname));
}
