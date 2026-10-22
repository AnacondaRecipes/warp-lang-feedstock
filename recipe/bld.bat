@echo on

if not "%CUDA_COMPILER_VERSION%" == "None" (
    set NVCC_APPEND_FLAGS=--use-local-env
    set LIBMATHDX_HOME=%PREFIX%/Library
    set "LIB=%CONDA_PREFIX%\Library\lib;%LIB%"
    set ARGS=--cuda-path=%CONDA_PREFIX%/Library
)

@REM libmathdx is not available for Windows on Arm
@REM See: https://github.com/NVIDIA/warp/blob/v1.18.0/docs/user_guide/installation.rst#experimental-windows-on-arm-builds
if "%target_platform%" == "win-arm64" (
    set LIBMATHDX_HOME=
    set ARGS=%ARGS% --no-use-libmathdx
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

set

%PYTHON% build_lib.py %ARGS% -j%CPU_COUNT% --use-dynamic-cuda
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
