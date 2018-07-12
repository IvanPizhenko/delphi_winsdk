{******************************************************************************
Translation of VersionHelpers.h to Deplhi.
(C:\Program Files (x86)\Windows Kits\10\Include\10.0.17134.0\um)
Copyright (c) Microsoft Corp.  All rights reserved.

Translation Copyright (c) 2018 Ivan Pizhenko. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
******************************************************************************}

unit VersionHelper;

interface

uses Windows;

function IsWindowsVersionOrGreater(
  wMajorVersion: WORD;
  wMinorVersion: WORD;
  wServicePackMajor: WORD): Boolean;

function IsWindowsXPOrGreater: Boolean;
function IsWindowsXPSP1OrGreater: Boolean;
function IsWindowsXPSP2OrGreater: Boolean;
function IsWindowsXPSP3OrGreater: Boolean;
function IsWindowsVistaOrGreater: Boolean;
function IsWindowsVistaSP1OrGreater: Boolean;
function IsWindowsVistaSP2OrGreater: Boolean;
function IsWindows7OrGreater: Boolean;
function IsWindows7SP1OrGreater: Boolean;
function IsWindows8OrGreater: Boolean;
function IsWindows8Point1OrGreater: Boolean;
function IsWindowsThresholdOrGreater: Boolean;
function IsWindows10OrGreater: Boolean;

function IsWindowsServer: Boolean;

implementation

const
  VER_EQUAL                       = 1;
  VER_GREATER                     = 2;
  VER_GREATER_EQUAL               = 3;
  VER_LESS                        = 4;
  VER_LESS_EQUAL                  = 5;
  VER_AND                         = 6;
  VER_OR                          = 7;

const
  VER_CONDITION_MASK              = 7;
  VER_NUM_BITS_PER_CONDITION_MASK = 3;

const
  VER_MINORVERSION                = $0000001;
  VER_MAJORVERSION                = $0000002;
  VER_BUILDNUMBER                 = $0000004;
  VER_PLATFORMID                  = $0000008;
  VER_SERVICEPACKMINOR            = $0000010;
  VER_SERVICEPACKMAJOR            = $0000020;
  VER_SUITENAME                   = $0000040;
  VER_PRODUCT_TYPE                = $0000080;

const
  VER_NT_WORKSTATION              = $0000001;
  VER_NT_DOMAIN_CONTROLLER        = $0000002;
  VER_NT_SERVER                   = $0000003;

const
  VER_PLATFORM_WIN32s             = 0;
  VER_PLATFORM_WIN32_WINDOWS      = 1;
  VER_PLATFORM_WIN32_NT           = 2;


function VerSetConditionMask(
  ConditionMask: ULONGLONG;
  TypeMask: DWORD;
  Condition: BYTE): ULONGLONG; stdcall;
  external Windows.kernel32 name 'VerSetConditionMask';


function IsWindowsVersionOrGreater(
  wMajorVersion: WORD;
  wMinorVersion: WORD;
  wServicePackMajor: WORD): Boolean;
var
  osvi: OSVERSIONINFOEXW;
  ConditionMask: DWORDLONG;
begin
  FillChar(osvi, SizeOf(osvi), 0);
  osvi.dwOSVersionInfoSize := SizeOf(osvi);
  osvi.dwMajorVersion := wMajorVersion;
  osvi.dwMinorVersion := wMinorVersion;
  osvi.wServicePackMajor := wServicePackMajor;

  ConditionMask := VerSetConditionMask(
    VerSetConditionMask(
      VerSetConditionMask(0, VER_MAJORVERSION, VER_GREATER_EQUAL),
        VER_MINORVERSION, VER_GREATER_EQUAL),
    VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL);


  Result := VerifyVersionInfoW(POSVersionInfo(@osvi)^,
    VER_MAJORVERSION or VER_MINORVERSION or VER_SERVICEPACKMAJOR,
    ConditionMask);
end;

function IsWindowsXPOrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(5, 1, 0);
end;

function IsWindowsXPSP1OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(5, 1, 1);
end;

function IsWindowsXPSP2OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(5, 1, 2);
end;

function IsWindowsXPSP3OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(5, 1, 3);
end;

function IsWindowsVistaOrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 0, 0);
end;

function IsWindowsVistaSP1OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 0, 1);
end;

function IsWindowsVistaSP2OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 0, 2);
end;

function IsWindows7OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 1, 0);
end;

function IsWindows7SP1OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 1, 1);
end;

function IsWindows8OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 2, 0);
end;

function IsWindows8Point1OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(6, 3, 0);
end;

function IsWindowsThresholdOrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(10, 0, 0);
end;

function IsWindows10OrGreater: Boolean;
begin
  Result := IsWindowsVersionOrGreater(10, 0, 0);
end;

function IsWindowsServer: Boolean;
var
  osvi: OSVERSIONINFOEXW;
  ConditionMask: DWORDLONG;
begin
  FillChar(osvi, SizeOf(osvi), 0);
  osvi.wProductType := VER_NT_WORKSTATION;
  ConditionMask := VerSetConditionMask(0, VER_PRODUCT_TYPE, VER_EQUAL);
  Result := not VerifyVersionInfoW(POSVersionInfo(@osvi)^, VER_PRODUCT_TYPE,
    ConditionMask);
end;

end.
