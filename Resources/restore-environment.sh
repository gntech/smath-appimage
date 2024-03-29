#!/bin/sh

echo "Restoring environment..."

# Restore the environment variables that were set by AppRun
export PATH="${SMATH_ORIG_PATH}"
export XDG_DATA_DIRS="${SMATH_ORIG_XDG_DATA_DIRS}"
export DYLD_LIBRARY_PATH="${SMATH_ORIG_DYLD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="${SMATH_ORIG_LD_LIBRARY_PATH}"
unset SMATH_ORIG_PATH SMATH_ORIG_XDG_DATA_DIRS SMATH_ORIG_DYLD_LIBRARY_PATH SMATH_ORIG_LD_LIBRARY_PATH

unset MONO_PATH MONO_CFG_DIR MONO_CONFIG
if [ -n "${SMATH_ORIG_MONO_PATH}" ]; then
	export MONO_PATH="${SMATH_ORIG_MONO_PATH}"
fi

if [ -n "${SMATH_ORIG_MONO_CFG_DIR}" ]; then
	export MONO_CFG_DIR="${SMATH_ORIG_MONO_CFG_DIR}"
fi

if [ -n "${SMATH_ORIG_MONO_CONFIG}" ]; then
	export MONO_CONFIG="${SMATH_ORIG_MONO_CONFIG}"
fi

unset SMATH_ORIG_MONO_PATH SMATH_ORIG_MONO_CFG_DIR SMATH_ORIG_MONO_CONFIG

# Run the given command
exec "$@"