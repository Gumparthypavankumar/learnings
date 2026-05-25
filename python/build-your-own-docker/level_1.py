"""
    Exercise: "Jail" a process so that it doesn't see the rest of the filesystem.
        ** Chroot
            1. Change root directory for a process and its children.
            2. Used to isolate a process and its children from rest of the system.

"""

import logging
import os
import time
import traceback
import uuid
import sys
import tarfile

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(process)d - %(levelname)s - %(message)s')

log = logging.getLogger(name="Chroot")

IMAGE_DIR = "./"
CONTAINER_DIR = "/workshop/containers"
IMAGE_NAME = "ubuntu"


def _get_image_path(image_name, image_suffix="tar"):
    return os.path.join(IMAGE_DIR, os.extsep.join([image_name, image_suffix]))

def create_container_root(image_name, container_id, *subdir_names):
    image_path = _get_image_path(image_name)
    container_root = os.path.join(CONTAINER_DIR, container_id, *subdir_names)

    log.info(f"{image_path}")
    assert os.path.exists(image_path), "unable to locate image %s" % image_name

    try:
        os.makedirs(container_root)
        with tarfile.open(image_path) as t:
            members = [m for m in t.getmembers() if m.type not in (tarfile.CHRTYPE, tarfile.BLKTYPE)]
            t.extractall(container_root, members=members)
    except OSError:
        log.exception("Failed to create container root.")
        raise

    return container_root

def main():
    container_id = str(uuid.uuid4())

    log.info(f"Parent process: {os.getpid()}")
    try:
        fork_id = os.fork()
        if fork_id == 0:
            try:
                new_root = create_container_root(IMAGE_NAME, container_id, "rootfs")
                os.chroot(new_root)
                os.chdir("/")
                os.execv("/bin/ls", ["/bin/ls", "-l", "/"])
            except Exception:
                os._exit(1)
        else:
            child_pid, status = os.waitpid(fork_id, 0)
            log.debug(f"Child PID: {child_pid} Status: {status}")
    except Exception:
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()