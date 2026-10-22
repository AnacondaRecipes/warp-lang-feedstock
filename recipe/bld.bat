@echo on

@REM CPU variants must not pick up a system CUDA install via build_lib.py's auto-detection,
@REM so pass --no-cuda explicitly. --use-dynamic-cuda is an error in combination with --no-cuda.
if "%CUDA_COMPILER_VERSION%" == "None" (
    set "ARGS=--no-cuda"
) else (
    @REM Append, so flags set by the cuda-nvcc activation scripts are preserved.
    set "NVCC_APPEND_FLAGS=%NVCC_APPEND_FLAGS% --use-local-env"
    @REM LIBRARY_PREFIX is the host prefix's Library directory.
    set "LIBMATHDX_HOME=%LIBRARY_PREFIX%"
    set "ARGS=--cuda-path=%LIBRARY_PREFIX% --use-dynamic-cuda"
)

@REM libmathdx is not available for Windows on Arm
@REM See: https://github.com/NVIDIA/warp/blob/v1.18.0/docs/user_guide/installation.rst#experimental-windows-on-arm-builds
if "%target_platform%" == "win-arm64" (
    set LIBMATHDX_HOME=
    set "ARGS=%ARGS% --no-use-libmathdx"
)

@REM Force packman to use system python
set PM_PYTHON_EXT=%PYTHON%

%PYTHON% build_lib.py %ARGS% -j%CPU_COUNT%
if errorlevel 1 exit 1

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation --no-cache-dir
if errorlevel 1 exit 1
