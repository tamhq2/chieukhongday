if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Vui lòng chạy PowerShell với quyền quản trị. Đang khởi động lại với quyền admin..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

#hoquyettam
$devMode = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock
if (-not $devMode.DeveloperModeEnabled) {
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name DeveloperModeEnabled -Value 1
    Write-Host "Chế độ nhà phát triển đã được bật."
} else {
    Write-Host "Chế độ nhà phát triển đã được bật trước đó."
}

#hoquyettam
$msiUrl = "https://www.spacedesk.net/downloadidd64"  
$msixUrl = "https://dl.dropbox.com/scl/fi/zb5wlqqkn9nat6a0cqr3x/datronicsoft.spacedesk_0.0.34.0_neutral_-_aa4z72nd5cmx4.Msixbundle?rlkey=kqzc7lx45khc3wguy8fwmqm7w&st=3n6s9msv&dl=1"


$tempPath = $env:TEMP
$msiPath = Join-Path -Path $tempPath -ChildPath "downloaded.msi"
$msixPath = Join-Path -Path $tempPath -ChildPath "downloaded.msappx"

#hoquyettam
function server {
    param (
        [string]$url,
        [string]$downloadPath
    )


    try {
        Invoke-WebRequest -Uri $url -OutFile $downloadPath -ErrorAction Stop
        Write-Host "Tải xuống thành công.Đang cài............"
    } catch {
        Write-Host "Tải xuống thất bại: $_"
        return
    }

   
    try {
        Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$downloadPath`" /quiet /norestart" -Wait
        Write-Host "Cài đặt SERVER thành công."
    } catch {
        Write-Host "Cài đặt SERVER thất bại: $_"
    }
}

#hoquyettam
function client {
    param (
        [string]$url,
        [string]$downloadPath
    )

   
    try {
        Invoke-WebRequest -Uri $url -OutFile $downloadPath -ErrorAction Stop
        Write-Host "Tải xuống thành công. Đang cài............"
    } catch {
        Write-Host "Tải xuống thất bại: $_"
        return
    }

 
    try {
        Add-AppxPackage -Path $downloadPath -ErrorAction Stop
        Write-Host "Cài đặt client viewer thành công."
    } catch {
        Write-Host "Cài đặt client viewer thất bại: $_"
    }
}

#hoquyettam
while ($true) {
    Clear-Host
    Write-Host "==== Cài Đặt By HOQUYETTAM ===="
    ""
    ""
    ""
    ""
    Write-Host "1. Tải và cài đặt file SERVER"
    Write-Host "2. Tải và cài đặt file CLIENT for WIN10 (not win 7 as homepage)"
    Write-Host "3. Thoát"
    ""
    ""
    $choice = Read-Host "Chọn một tùy chọn (1-3)"

    switch ($choice) {
        1 {
            server -url $msiUrl -downloadPath $msiPath
        }
        2 {
            client -url $msixUrl -downloadPath $msixPath
        }
        3 {
            Write-Host "Thoát chương trình."
            exit
        }
        default {
            Write-Host "Tùy chọn không hợp lệ. Vui lòng chọn lại."
        }
    }

   ""
   ""
    Read-Host "Nhấn Enter để tiếp tục..."
}