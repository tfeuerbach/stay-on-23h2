# Stay on Windows 11 23H2

This script prevents your Windows 11 machine from updating beyond version 23H2 by setting official Windows Update policies in the registry.

## Why
Microsoft is removing support for Windows Mixed Reality (WMR) in versions after 23H2.
I use an HP Reverb G2 headset, and the update to 24H2 effectively bricks it.
To keep using my VR hardware, I need to stay on 23H2 — this script enforces that.

## How It Works
- Sets `TargetReleaseVersion` to `1`
- Sets `TargetReleaseVersionInfo` to `"23H2"`
- This tells Windows Update to stay on version 23H2 and ignore newer feature updates

## How to Use
1. Download the `stay-on-23h2.ps1` file from this repository
2. Open **PowerShell as Administrator**
3. Navigate to the directory containing the script
4. Run the script with:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\stay-on-23h2.ps1
  ```
5. If you're not already elevated, the script will prompt you for administrator access
6. The script will:
  - Check if you're already locked to 23H2
  - If so, ask whether to **remove** the lock
  - If not, it will apply the 23H2 hold

## Behavior If Already Set
If your system is already configured to stay on 23H2, the script will detect it.
You’ll be asked if you want to remove the setting and allow updates to future Windows versions.
- Type `yes` to remove the 23H2 hold and allow updates.
- Type `no` to leave things as they are — no changes will be made.

## Notes
- No reboot is required
- You can remove or change the setting later by editing the registry:
 - `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\TargetReleaseVersion`
 - `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\TargetReleaseVersionInfo`

## Warning
This script only prevents **feature updates** (like 24H2). It does **not** block security updates or monthly cumulative patches.

## License
This project is open source and provided as-is with no warranty or guarantee.
