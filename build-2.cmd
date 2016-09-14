@echo off
setlocal

call cl 2>&1 | find "x86" >nul
if not errorlevel 1 (
    echo x86-32 cl.exe detected.
    set _target=x86-32
    set _bootimage=boot.windows-x86.32.image
) else (
    call cl 2>&1 | find "x64" >nul
    if not errorlevel 1 (
        echo x86-64 cl.exe detected.
        set _target=x86-64
        set _bootimage=boot.windows-x86.64.image
    ) else goto nocl
)

echo Deleting staging images from temp/...
del temp\staging.*.image

echo Bootstrapping...
.\factor.com -i=%_bootimage%
if errorlevel 1 goto fail

echo Copying fresh factor.image to factor.image.fresh.
copy factor.image factor.image.fresh
if errorlevel 1 goto fail

echo Build phase 2 complete.
goto :EOF

:fail
echo Build failed.
goto :EOF

:nocl
echo Unable to detect cl.exe target platform.
echo Make sure you're running within the Visual Studio or Windows SDK environment.
goto :EOF
