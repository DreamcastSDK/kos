#!/bin/sh
for file in \
"addons/libppp/" "ppp.o" "lcp.o" "pap.o" "ipcp.o" \
"addons/libkosext2fs/" "ext2fs.o" "bitops.o" "block.o" "inode.o" "superblock.o" "fs_ext2.o" "symlink.o" "directory.o" \
"common/exports/" "nmmgr.o" "kernel_exports.o" "exports.o" "library.o" \
"common/mm/" "malloc_debug.o" "cplusplus.o" \
"common/libc/c11/" "call_once.o" "cnd_broadcast.o" "cnd_destroy.o" "cnd_init.o" "cnd_signal.o" "cnd_timedwait.o" "cnd_wait.o" "mtx_destroy.o" "mtx_init.o" "mtx_lock.o" "mtx_timedlock.o" "mtx_trylock.o" "mtx_unlock.o" "thrd_create.o" "thrd_current.o" "thrd_detach.o" "thrd_equal.o" "thrd_exit.o" "thrd_join.o" "thrd_sleep.o" "thrd_yield.o" "tss_create.o" "tss_delete.o" "tss_get.o" "tss_set.o" "aligned_alloc.o" \
"common/libc/newlib/" "lock_common.o" "newlib_close.o" "newlib_env_lock.o" "newlib_environ.o" "newlib_execve.o" "newlib_exit.o" "newlib_fork.o" "newlib_fstat.o" "newlib_getpid.o" "newlib_gettimeofday.o" "newlib_isatty.o" "newlib_kill.o" "newlib_link.o" "newlib_lseek.o" "newlib_malloc.o" "newlib_open.o" "newlib_read.o" "newlib_sbrk.o" "newlib_stat.o" "newlib_times.o" "newlib_unlink.o" "newlib_wait.o" "newlib_write.o" "newlib_fcntl.o" "verify_newlib.o" \
"common/libc/pthreads/" "pthread_mutex.o" "pthread_cond.o" "pthread_thd_attr.o" "pthread_thd.o" "pthread_tls.o" \
"common/libc/koslib/" "abort.o" "byteorder.o" "memset2.o" "memset4.o" "memcpy2.o" "memcpy4.o" "assert.o" "dbglog.o" "malloc.o" "atexit.o" "opendir.o" "readdir.o" "closedir.o" "rewinddir.o" "scandir.o" "seekdir.o" "telldir.o" "usleep.o" "inet_addr.o" "realpath.o" "getcwd.o" "chdir.o" "mkdir.o" "creat.o" "sleep.o" "rmdir.o" "rename.o" "inet_pton.o" "inet_ntop.o" "inet_ntoa.o" "inet_aton.o" "poll.o" "select.o" "symlink.o" "readlink.o" "gethostbyname.o" "getaddrinfo.o" "dirfd.o" "nanosleep.o" \
"common/thread/" "sem.o" "cond.o" "mutex.o" "genwait.o" \
"common/fs/" "fs.o" "fs_romdisk.o" "fs_ramdisk.o" "fs_pty.o" \
"common/debug/" "dbgio.o" \
"dreamcast/kernel/" "banner.o" "cache.o" "entry.o" "irq.o" "init.o" "mm.o" "panic.o" "startup.o" \
"dreamcast/hardware/network/" "broadband_adapter.o" "lan_adapter.o" \
"dreamcast/hardware/" "hardware.o" \
"dreamcast/hardware/modem/" "mdata.o" "mintr.o" "modem.o" "chainbuf.o" \
"dreamcast/util/" "vmu_pkg.o" "screenshot.o" "fb_console.o" \
"dreamcast/math/" "fmath.o" "matrix.o" "matrix3d.o" \
"dreamcast/sound/" "snd_iface.o" "snd_sfxmgr.o" "snd_stream.o" "snd_stream_drv.o" "snd_mem.o"; \
do \
  total=`echo ${file} | grep -c "/"`; \
  if [ "${total}" != "0" ]; \
  then \
    curdir=${file}; \
  else \
    echo -n "${curdir}${file} "; \
  fi; \
done

