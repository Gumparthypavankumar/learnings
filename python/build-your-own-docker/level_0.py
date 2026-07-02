"""
    Exercise:
        ** Fork and Exec
        The System call support by OS to spawn processes. Fork and Exec go hand-in-hand.

    fork(): A system call that creates a complete copy of executing program into a new process.
        1. The new process is called child process and has a new PID the process that calls fork() is called parent process.
    exec(): This is a family of system calls that replace the current process with a new one.
        1. When child process calls exec(), all data in original program is lost, and is replaced with running copy of a new program

    Handling:
        1. The parent must invoke, wait() / compatible system call, in order to collect child's exit status and allow the system
         to release the resources associated with the child. If a wait is not performed, then the terminated child remains in "defunct" (AKA "zombie") state
"""
import logging
import os
import sys
import traceback

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(process)d - %(levelname)s - %(message)s')

log = logging.getLogger(name="Fork&Exec")


def main():
    try:
        log.info(f"Parent Process ID: {os.getpid()}")
        fork_pid = os.fork()
        if fork_pid == 0: # 0 indicates child process
            try:
                os.execv("/bin/echo", ["echo", "Hello Docker!"])
            except Exception:
                traceback.print_exc()
                os._exit(1)
        else:
            wait_pid, status = os.waitpid(fork_pid, 0)
            log.debug(f"Child PID: {wait_pid} Status: {status}")
    except Exception:
        traceback.print_exc()
        sys.exit(1) # Executes cleanup process, logging buffers

if __name__ == '__main__':
    main()
