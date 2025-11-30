@echo off
setlocal enabledelayedexpansion
title ZENVO AUTOMOTIVE TYCOON - ULTIMATE EDITION
color 0B

:: -----------------------------------------------------
:: INITIALIZATION
:: -----------------------------------------------------
:init
set "money=50000"
set "rebirths=0"
set "multiplier=1"
set "total_value=0"

:: Car Counts
set "c_ts1=0"
set "c_tsrs=0"
set "c_agil=0"
set "c_tur=0"

:: Car Income Rates (Per Turn)
set "i_ts1=15000"
set "i_tsrs=35000"
set "i_agil=80000"
set "i_tur=100000"

:: Car Costs
set "p_ts1=1200000"
set "p_tsrs=1800000"
set "p_agil=3000000"
set "p_tur=3500000"

:: Rebirth Cost
set "rebirth_req=10000000"

goto menu

:: -----------------------------------------------------
:: MAIN MENU
:: -----------------------------------------------------
:menu
cls
:: Calculate Income
set /a income=((c_ts1 * i_ts1) + (c_tsrs * i_tsrs) + (c_agil * i_agil) + (c_tur * i_tur)) * multiplier
set /a click_val=5000 * multiplier

echo ==============================================================================
echo.
echo      ZZZZZZZZ  EEEEEEEE  NN    NN  VV      VV   OOOOO  
echo           ZZ   EE        NNN   NN   VV    VV   OO   OO 
echo         ZZ     EEEEEE    NN NN NN    VV  VV    OO   OO 
echo       ZZ       EE        NN   NNN     VVVV     OO   OO 
echo      ZZZZZZZZ  EEEEEEEE  NN    NN      VV       OOOOO  
echo.
echo                   T Y C O O N   M A N A G E R
echo ==============================================================================
echo  [STATUS]
echo  Bank Balance : $%money%
echo  Prestige Lvl : %rebirths% (Multiplier: x%multiplier%)
echo  Daily Income : $%income% (Generated per action)
echo.
echo  [GARAGE INVENTORY]
echo  1. 2017 Zenvo TS1 GT ........: %c_ts1% Owned
echo  2. 2020 Zenvo TSR-S .........: %c_tsrs% Owned
echo  3. 2025 Zenvo Aurora Agil ...: %c_agil% Owned
echo  4. 2025 Zenvo Aurora Tur ....: %c_tur% Owned
echo ==============================================================================
echo  [ACTIONS]
echo  A. Secure Funding (Click for Cash: +$%click_val%)
echo  B. Buy Cars (Dealership)
echo  R. REBIRTH (Requires $10,000,000)
echo  S. Save Game
echo  L. Load Game
echo  X. Exit
echo ==============================================================================
set /p choice="Select Option: "

:: Passive Income Logic on every menu refresh
set /a money=money+income

if /i "%choice%"=="A" goto work
if /i "%choice%"=="B" goto shop
if /i "%choice%"=="R" goto rebirth_check
if /i "%choice%"=="S" goto save
if /i "%choice%"=="L" goto load
if /i "%choice%"=="X" exit
goto menu

:: -----------------------------------------------------
:: WORK MECHANIC
:: -----------------------------------------------------
:work
set /a money=money+click_val
echo.
echo  [+] You secured funding from investors!
echo  [+] earned $%click_val%
echo.
timeout /t 1 >nul
goto menu

:: -----------------------------------------------------
:: DEALERSHIP
:: -----------------------------------------------------
:shop
cls
echo ==============================================================================
echo                         ZENVO DEALERSHIP
echo ==============================================================================
echo  Your Money: $%money%
echo.
echo  1. 2017 Zenvo TS1 GT
echo     Cost: $%p_ts1% | Income: $%i_ts1%/turn
echo.
echo  2. 2020 Zenvo TSR-S (Active Aero Wing)
echo     Cost: $%p_tsrs% | Income: $%i_tsrs%/turn
echo.
echo  3. 2025 Zenvo Aurora Agil (Track Focused)
echo     Cost: $%p_agil% | Income: $%i_agil%/turn
echo.
echo  4. 2025 Zenvo Aurora Tur (Grand Tourer)
echo     Cost: $%p_tur% | Income: $%i_tur%/turn
echo.
echo  B. Back to Menu
echo ==============================================================================
set /p buy="Buy which model (1-4): "

if /i "%buy%"=="B" goto menu
if "%buy%"=="1" call :buy_car ts1 %p_ts1% "Zenvo TS1 GT"
if "%buy%"=="2" call :buy_car tsrs %p_tsrs% "Zenvo TSR-S"
if "%buy%"=="3" call :buy_car agil %p_agil% "Zenvo Aurora Agil"
if "%buy%"=="4" call :buy_car tur %p_tur% "Zenvo Aurora Tur"

goto shop

:buy_car
:: %1 is variable suffix, %2 is cost, %3 is Name
if %money% GEQ %2 (
    set /a money=money-%2
    set /a c_%1+=1
    echo.
    echo  [SUCCESS] Purchased %~3!
    echo  Production line expanded.
    timeout /t 2 >nul
) else (
    echo.
    echo  [ERROR] Insufficient Funds! You need $%2.
    timeout /t 2 >nul
)
goto :eof

:: -----------------------------------------------------
:: REBIRTH SYSTEM
:: -----------------------------------------------------
:rebirth_check
cls
echo ==============================================================================
echo                             PRESTIGE / REBIRTH
echo ==============================================================================
echo  Current Money: $%money%
echo  Required:      $%rebirth_req%
echo.
echo  Rebirthing will:
echo  1. RESET your Money to $50,000.
echo  2. DELETE all your cars.
echo  3. INCREASE your Income Multiplier by +1 permanently.
echo.
echo ==============================================================================
set /p re="Are you sure? (Y/N): "
if /i "%re%"=="N" goto menu

if %money% GEQ %rebirth_req% (
    set /a rebirths+=1
    set /a multiplier=rebirths+1
    
    :: Reset Economy
    set "money=50000"
    set "c_ts1=0"
    set "c_tsrs=0"
    set "c_agil=0"
    set "c_tur=0"
    
    :: Increase difficulty for next rebirth
    set /a rebirth_req=rebirth_req*2
    
    cls
    color 0E
    echo.
    echo  *******************************************
    echo          REBIRTH SUCCESSFUL!
    echo       Prestige Level is now: %rebirths%
    echo  *******************************************
    timeout /t 3 >nul
    color 0B
    goto menu
) else (
    echo.
    echo  [FAIL] You are not rich enough yet.
    timeout /t 2 >nul
    goto menu
)

:: -----------------------------------------------------
:: SAVE SYSTEM
:: -----------------------------------------------------
:save
(
echo %money%
echo %rebirths%
echo %multiplier%
echo %c_ts1%
echo %c_tsrs%
echo %c_agil%
echo %c_tur%
echo %rebirth_req%
) > zenvo_save.dat
echo.
echo  [GAME SAVED] Progress stored in zenvo_save.dat
timeout /t 2 >nul
goto menu

:: -----------------------------------------------------
:: LOAD SYSTEM
:: -----------------------------------------------------
:load
if not exist zenvo_save.dat (
    echo.
    echo  [ERROR] No save file found!
    timeout /t 2 >nul
    goto menu
)

< zenvo_save.dat (
set /p money=
set /p rebirths=
set /p multiplier=
set /p c_ts1=
set /p c_tsrs=
set /p c_agil=
set /p c_tur=
set /p rebirth_req=
)
echo.
echo  [GAME LOADED] Welcome back, CEO.
timeout /t 2 >nul
goto menu