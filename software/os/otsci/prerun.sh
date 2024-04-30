#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
        copy_previous
fi

# 00-run.sh must be +x or it's skipped
chmod +x 00-customizations/00-run.sh