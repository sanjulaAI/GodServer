#Requires -Version 5.1
<#
    GOD SERVER - All-in-one Windows Toolbox
    ----------------------------------------
    Single-file WinForms GUI: app installer, tweaks, drivers, utilities,
    live dashboard, and a separated high-risk "Advanced" tier.

    Author   : Sanjula
    Version  : 1.0.0
    Backups  : %LOCALAPPDATA%\GodServer\backup.json
    Revert   : Toggle any Tweak off to restore its original value.

    NOTE: Update $Global:RepoBase below to your actual GitHub repo once created.
          Advanced (high-risk) tools are fetched from batch/ in that repo at
          run time, keeping this main file focused on the GUI + safe tools.
#>

[CmdletBinding()]
param(
    [switch]$NoElevate
)

$ErrorActionPreference = 'Stop'
$Global:RepoBase   = 'https://raw.githubusercontent.com/sanjulaAI/GodServer/main'
$Global:AppVersion = '1.0.0'

#region Self-Elevation (only relevant when run from a saved .ps1 file)
if (-not $NoElevate -and $PSCommandPath) {
    $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList @(
            '-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"",'-NoElevate'
        ) | Out-Null
        exit
    }
}
#endregion

#region Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
#endregion

#region Custom Controls (rounded buttons, sidebar nav, cards, toggle switches)
if (-not ([System.Management.Automation.PSTypeName]'GodServerUI.Card').Type) {
Add-Type -ReferencedAssemblies 'System.Windows.Forms','System.Drawing' -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace GodServerUI
{
    public static class Shapes
    {
        public static GraphicsPath RoundedRect(Rectangle bounds, int radius)
        {
            int d = radius * 2;
            GraphicsPath path = new GraphicsPath();
            path.AddArc(bounds.X, bounds.Y, d, d, 180, 90);
            path.AddArc(bounds.Right - d, bounds.Y, d, d, 270, 90);
            path.AddArc(bounds.Right - d, bounds.Bottom - d, d, d, 0, 90);
            path.AddArc(bounds.X, bounds.Bottom - d, d, d, 90, 90);
            path.CloseFigure();
            return path;
        }
    }

    public class RoundedButton : Button
    {
        public int Radius = 8;
        public Color HoverColor = Color.FromArgb(230, 230, 235);
        public Color NormalColor = Color.White;
        public Color BorderColor = Color.FromArgb(225, 227, 232);
        private bool hovering = false;

        public RoundedButton()
        {
            SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint |
                      ControlStyles.OptimizedDoubleBuffer | ControlStyles.ResizeRedraw, true);
            FlatStyle = FlatStyle.Flat;
            FlatAppearance.BorderSize = 0;
            Cursor = Cursors.Hand;
        }

        protected override void OnMouseEnter(EventArgs e) { hovering = true; Invalidate(); base.OnMouseEnter(e); }
        protected override void OnMouseLeave(EventArgs e) { hovering = false; Invalidate(); base.OnMouseLeave(e); }

        protected override void OnPaint(PaintEventArgs pevent)
        {
            Graphics g = pevent.Graphics;
            g.SmoothingMode = SmoothingMode.AntiAlias;
            Rectangle rect = new Rectangle(0, 0, Width - 1, Height - 1);
            using (GraphicsPath path = Shapes.RoundedRect(rect, Radius))
            {
                Color fill = hovering ? HoverColor : NormalColor;
                using (SolidBrush b = new SolidBrush(fill)) g.FillPath(b, path);
                using (Pen p = new Pen(BorderColor, 1)) g.DrawPath(p, path);
            }
            TextRenderer.DrawText(g, Text, Font, rect, ForeColor,
                TextFormatFlags.HorizontalCenter | TextFormatFlags.VerticalCenter);
        }
    }

    public class NavButton : Button
    {
        public bool Selected = false;
        public Color AccentColor = Color.FromArgb(212, 162, 39);
        public Color SelectedBack = Color.FromArgb(22, 33, 58);
        public Color NormalBack = Color.FromArgb(11, 17, 32);
        public Color HoverBack = Color.FromArgb(18, 27, 48);
        private bool hovering = false;

        public NavButton()
        {
            SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint |
                      ControlStyles.OptimizedDoubleBuffer, true);
            FlatStyle = FlatStyle.Flat;
            FlatAppearance.BorderSize = 0;
            TextAlign = ContentAlignment.MiddleLeft;
            Cursor = Cursors.Hand;
        }

        protected override void OnMouseEnter(EventArgs e) { hovering = true; Invalidate(); base.OnMouseEnter(e); }
        protected override void OnMouseLeave(EventArgs e) { hovering = false; Invalidate(); base.OnMouseLeave(e); }

        protected override void OnPaint(PaintEventArgs pevent)
        {
            Graphics g = pevent.Graphics;
            Color back = Selected ? SelectedBack : (hovering ? HoverBack : NormalBack);
            using (SolidBrush b = new SolidBrush(back)) g.FillRectangle(b, ClientRectangle);
            if (Selected)
            {
                using (SolidBrush ab = new SolidBrush(AccentColor))
                    g.FillRectangle(ab, new Rectangle(0, 0, 4, Height));
            }
            Rectangle textRect = new Rectangle(28, 0, Width - 28, Height);
            TextRenderer.DrawText(g, Text, Font, textRect, ForeColor,
                TextFormatFlags.Left | TextFormatFlags.VerticalCenter);
        }
    }

    public class Card : Panel
    {
        public int Radius = 10;
        public Color BorderColor = Color.FromArgb(228, 231, 236);

        public Card()
        {
            SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint |
                      ControlStyles.OptimizedDoubleBuffer | ControlStyles.ResizeRedraw, true);
            BackColor = Color.White;
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;
            Rectangle rect = new Rectangle(0, 0, Width - 1, Height - 1);
            using (GraphicsPath path = Shapes.RoundedRect(rect, Radius))
            using (Pen p = new Pen(BorderColor, 1))
                e.Graphics.DrawPath(p, path);
        }
    }

    public class ToggleSwitch : CheckBox
    {
        public Color OnColor = Color.FromArgb(212, 162, 39);
        public Color OffColor = Color.FromArgb(202, 205, 211);

        public ToggleSwitch()
        {
            SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint |
                      ControlStyles.OptimizedDoubleBuffer, true);
            MinimumSize = new Size(46, 24);
            Size = new Size(46, 24);
            Cursor = Cursors.Hand;
        }

        protected override void OnPaint(PaintEventArgs pevent)
        {
            Graphics g = pevent.Graphics;
            g.SmoothingMode = SmoothingMode.AntiAlias;
            Color bg = Parent != null ? Parent.BackColor : Color.White;
            g.Clear(bg);
            Rectangle rect = new Rectangle(0, 1, 44, 22);
            using (GraphicsPath path = Shapes.RoundedRect(rect, 11))
            {
                using (SolidBrush b = new SolidBrush(Checked ? OnColor : OffColor)) g.FillPath(b, path);
            }
            int knobX = Checked ? 24 : 2;
            g.FillEllipse(Brushes.White, knobX, 3, 18, 18);
        }
    }
}
'@
}
#endregion

#region Theme
$T = @{
    White        = [System.Drawing.Color]::FromArgb(255,255,255)
    OffWhite     = [System.Drawing.Color]::FromArgb(247,248,250)
    Sidebar      = [System.Drawing.Color]::FromArgb(11,17,32)
    SidebarHover = [System.Drawing.Color]::FromArgb(18,27,48)
    SidebarSel   = [System.Drawing.Color]::FromArgb(22,33,58)
    Gold         = [System.Drawing.Color]::FromArgb(212,162,39)
    GoldDark     = [System.Drawing.Color]::FromArgb(178,134,26)
    TextDark     = [System.Drawing.Color]::FromArgb(26,26,46)
    TextMuted    = [System.Drawing.Color]::FromArgb(120,126,138)
    TextLight    = [System.Drawing.Color]::FromArgb(232,233,237)
    Border       = [System.Drawing.Color]::FromArgb(228,231,236)
    Success      = [System.Drawing.Color]::FromArgb(39,174,96)
    Warning      = [System.Drawing.Color]::FromArgb(230,160,20)
    Danger       = [System.Drawing.Color]::FromArgb(192,57,43)
}
$FontLogo    = New-Object System.Drawing.Font('Segoe UI', 15, [System.Drawing.FontStyle]::Bold)
$FontTitle   = New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)
$FontHeading = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold)
$FontBody    = New-Object System.Drawing.Font('Segoe UI', 9.5)
$FontBodyB   = New-Object System.Drawing.Font('Segoe UI', 9.5, [System.Drawing.FontStyle]::Bold)
$FontSmall   = New-Object System.Drawing.Font('Segoe UI', 8.5)
$FontNav     = New-Object System.Drawing.Font('Segoe UI', 10)
$FontStat    = New-Object System.Drawing.Font('Segoe UI', 22, [System.Drawing.FontStyle]::Bold)
$FontMono    = New-Object System.Drawing.Font('Consolas', 9)
#endregion

#region Backup / Revert store
$BackupDir  = Join-Path $env:LOCALAPPDATA 'GodServer'
$BackupFile = Join-Path $BackupDir 'backup.json'
if (-not (Test-Path $BackupDir)) { New-Item -Path $BackupDir -ItemType Directory -Force | Out-Null }

function ConvertTo-HashtableShallow($obj) {
    $ht = @{}
    if ($null -eq $obj) { return $ht }
    foreach ($p in $obj.PSObject.Properties) { $ht[$p.Name] = $p.Value }
    return $ht
}
function Get-BackupStore {
    if (Test-Path $BackupFile) {
        try { return ConvertTo-HashtableShallow (Get-Content $BackupFile -Raw | ConvertFrom-Json) }
        catch { return @{} }
    }
    return @{}
}
function Save-BackupStore($store) {
    ($store | ConvertTo-Json -Depth 8) | Set-Content -Path $BackupFile -Encoding UTF8
}
function Backup-RegValue {
    param([string]$Path, [string]$Name)
    $existed = $false; $val = $null
    if (Test-Path $Path) {
        $item = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
        if ($null -ne $item -and ($item.PSObject.Properties.Name -contains $Name)) { $existed = $true; $val = $item.$Name }
    }
    return @{ Path = $Path; Name = $Name; Existed = $existed; Value = $val }
}
function Set-RegValueSafe {
    param([string]$Path, [string]$Name, $Value, [string]$Type = 'DWord')
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    if ($Name -eq '(Default)') {
        Set-Item -Path $Path -Value $Value -Force
    } else {
        New-ItemProperty -Path $Path -Name $Name -PropertyType $Type -Value $Value -Force | Out-Null
    }
}
function Restore-RegValue {
    param($Entry)
    if ($Entry.Existed) {
        if (Test-Path $Entry.Path) {
            if ($Entry.Name -eq '(Default)') { Set-Item -Path $Entry.Path -Value $Entry.Value -Force -ErrorAction SilentlyContinue }
            else { Set-ItemProperty -Path $Entry.Path -Name $Entry.Name -Value $Entry.Value -Force -ErrorAction SilentlyContinue }
        }
    } else {
        if (Test-Path $Entry.Path) { Remove-ItemProperty -Path $Entry.Path -Name $Entry.Name -Force -ErrorAction SilentlyContinue }
    }
}
function Restart-ExplorerProcess {
    Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
    if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }
}
#endregion

#region Dialog helpers
function Show-InfoDialog {
    param([string]$Title, [string]$Message, [switch]$Wide)
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text = $Title
    $dlg.StartPosition = 'CenterScreen'
    $dlg.FormBorderStyle = 'FixedDialog'
    $dlg.MaximizeBox = $false; $dlg.MinimizeBox = $false
    $dlg.BackColor = $T.White
    $dlg.Width = if ($Wide) { 540 } else { 430 }
    $dlg.Height = 340
    $dlg.Font = $FontBody

    $bar = New-Object System.Windows.Forms.Panel
    $bar.Dock = 'Top'; $bar.Height = 6; $bar.BackColor = $T.Gold
    $dlg.Controls.Add($bar)

    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.ReadOnly = $true
    $tb.ScrollBars = 'Vertical'
    $tb.BorderStyle = 'None'
    $tb.Font = $FontMono
    $tb.ForeColor = $T.TextDark
    $tb.BackColor = $T.White
    $tb.Text = $Message
    $tb.Location = New-Object System.Drawing.Point(20, 26)
    $tb.Size = New-Object System.Drawing.Size(($dlg.Width - 56), ($dlg.Height - 100))
    $dlg.Controls.Add($tb)

    $btn = New-Object GodServerUI.RoundedButton
    $btn.Text = 'OK'
    $btn.NormalColor = $T.Gold; $btn.HoverColor = $T.GoldDark
    $btn.ForeColor = $T.White
    $btn.Font = $FontBodyB
    $btn.Size = New-Object System.Drawing.Size(96, 34)
    $btn.Location = New-Object System.Drawing.Point(($dlg.Width - 128), ($dlg.Height - 74))
    $btn.Add_Click({ $dlg.Close() })
    $dlg.Controls.Add($btn)
    $dlg.AcceptButton = $btn
    $dlg.ShowDialog() | Out-Null
}

function Show-ConfirmDialog {
    param([string]$Title, [string]$Message, [string]$AccentKey = 'Warning')
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text = $Title
    $dlg.StartPosition = 'CenterScreen'
    $dlg.FormBorderStyle = 'FixedDialog'
    $dlg.MaximizeBox = $false; $dlg.MinimizeBox = $false
    $dlg.BackColor = $T.White
    $dlg.Width = 480; $dlg.Height = 340
    $dlg.Font = $FontBody

    $bar = New-Object System.Windows.Forms.Panel
    $bar.Dock = 'Top'; $bar.Height = 6; $bar.BackColor = $T[$AccentKey]
    $dlg.Controls.Add($bar)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $Message
    $lbl.Location = New-Object System.Drawing.Point(20, 26)
    $lbl.Size = New-Object System.Drawing.Size(440, 210)
    $lbl.Font = $FontBody
    $lbl.ForeColor = $T.TextDark
    $dlg.Controls.Add($lbl)

    $dlg | Add-Member -NotePropertyName Result -NotePropertyValue $false -Force

    $btnYes = New-Object GodServerUI.RoundedButton
    $btnYes.Text = 'Yes, Continue'
    $btnYes.NormalColor = $T[$AccentKey]; $btnYes.ForeColor = $T.White
    $btnYes.Font = $FontBodyB
    $btnYes.Size = New-Object System.Drawing.Size(150, 36)
    $btnYes.Location = New-Object System.Drawing.Point(200, 260)
    $btnYes.Add_Click({ $dlg.Result = $true; $dlg.Close() })
    $dlg.Controls.Add($btnYes)

    $btnNo = New-Object GodServerUI.RoundedButton
    $btnNo.Text = 'Cancel'
    $btnNo.NormalColor = $T.OffWhite; $btnNo.ForeColor = $T.TextDark
    $btnNo.Font = $FontBody
    $btnNo.Size = New-Object System.Drawing.Size(100, 36)
    $btnNo.Location = New-Object System.Drawing.Point(360, 260)
    $btnNo.Add_Click({ $dlg.Result = $false; $dlg.Close() })
    $dlg.Controls.Add($btnNo)

    $dlg.ShowDialog() | Out-Null
    return $dlg.Result
}
#endregion

#region Tweak definitions (declarative - generic apply/revert engine)
$ClassicMenuKey = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'

$Tweaks = @(
    @{ Key='Telemetry';  Name='Disable Telemetry';        Desc='Stop Windows from collecting diagnostic data'
       Regs=@(@{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection';Name='AllowTelemetry';OnValue=0;Type='DWord'})
       PostApply={ Get-Service DiagTrack -EA SilentlyContinue | Stop-Service -Force -EA SilentlyContinue; Get-Service DiagTrack -EA SilentlyContinue | Set-Service -StartupType Disabled -EA SilentlyContinue }
       PostRevert={ Get-Service DiagTrack -EA SilentlyContinue | Set-Service -StartupType Manual -EA SilentlyContinue }
       RestartExplorer=$false },

    @{ Key='Cortana';    Name='Disable Cortana';          Desc='Turn off the Cortana assistant'
       Regs=@(@{Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search';Name='AllowCortana';OnValue=0;Type='DWord'})
       RestartExplorer=$false },

    @{ Key='ShowExt';    Name='Show File Extensions';     Desc='Always show file extensions in Explorer'
       Regs=@(@{Path='HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced';Name='HideFileExt';OnValue=0;Type='DWord'})
       RestartExplorer=$true },

    @{ Key='DisableBing'; Name='Disable Bing in Start Menu'; Desc='Stop web search results cluttering the Start Menu'
       Regs=@(
          @{Path='HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer';Name='DisableSearchBoxSuggestions';OnValue=1;Type='DWord'},
          @{Path='HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search';Name='BingSearchEnabled';OnValue=0;Type='DWord'},
          @{Path='HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search';Name='CortanaConsent';OnValue=0;Type='DWord'}
       )
       RestartExplorer=$false },

    @{ Key='ClassicMenu'; Name='Classic Right-Click Menu'; Desc='Restore the Windows 10 style context menu (Win11 only)'
       TestFn  = { Test-Path $ClassicMenuKey }.GetNewClosure()
       ApplyFn = { New-Item -Path "$ClassicMenuKey\InprocServer32" -Force | Out-Null; Set-Item -Path "$ClassicMenuKey\InprocServer32" -Value '' -Force; Restart-ExplorerProcess }.GetNewClosure()
       RevertFn= { Remove-Item -Path $ClassicMenuKey -Recurse -Force -ErrorAction SilentlyContinue; Restart-ExplorerProcess }.GetNewClosure()
       RestartExplorer=$false },

    @{ Key='DarkMode';   Name='Dark Mode';                Desc='Enable system-wide dark theme'
       Regs=@(
          @{Path='HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize';Name='AppsUseLightTheme';OnValue=0;Type='DWord'},
          @{Path='HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize';Name='SystemUsesLightTheme';OnValue=0;Type='DWord'}
       )
       RestartExplorer=$false },

    @{ Key='StickyKeys'; Name='Disable Sticky Keys Prompt'; Desc='Stop the accessibility popup when Shift is pressed 5x'
       Regs=@(
          @{Path='HKCU:\Control Panel\Accessibility\StickyKeys';Name='Flags';OnValue='506';Type='String'},
          @{Path='HKCU:\Control Panel\Accessibility\Keyboard Response';Name='Flags';OnValue='122';Type='String'},
          @{Path='HKCU:\Control Panel\Accessibility\ToggleKeys';Name='Flags';OnValue='58';Type='String'}
       )
       RestartExplorer=$false }
)

function Test-TweakEnabled($tweak) {
    if ($tweak.TestFn) { return (& $tweak.TestFn) }
    foreach ($r in $tweak.Regs) {
        $cur = $null
        if (Test-Path $r.Path) {
            $ip = Get-ItemProperty -Path $r.Path -Name $r.Name -ErrorAction SilentlyContinue
            if ($null -ne $ip) { $cur = $ip.($r.Name) }
        }
        if ("$cur" -ne "$($r.OnValue)") { return $false }
    }
    return $true
}
function Invoke-ApplyTweak($tweak) {
    if ($tweak.ApplyFn) { & $tweak.ApplyFn; return }
    $store = Get-BackupStore
    $entries = @()
    foreach ($r in $tweak.Regs) {
        $entries += Backup-RegValue $r.Path $r.Name
        Set-RegValueSafe $r.Path $r.Name $r.OnValue $r.Type
    }
    $store[$tweak.Key] = $entries
    Save-BackupStore $store
    if ($tweak.PostApply) { & $tweak.PostApply }
    if ($tweak.RestartExplorer) { Restart-ExplorerProcess }
}
function Invoke-RevertTweak($tweak) {
    if ($tweak.RevertFn) { & $tweak.RevertFn; return }
    $store = Get-BackupStore
    if ($store.ContainsKey($tweak.Key)) {
        foreach ($e in $store[$tweak.Key]) { Restore-RegValue $e }
        $store.Remove($tweak.Key)
        Save-BackupStore $store
    }
    if ($tweak.PostRevert) { & $tweak.PostRevert }
    if ($tweak.RestartExplorer) { Restart-ExplorerProcess }
}

$DebloatApps = @(
    'Microsoft.BingNews','Microsoft.BingWeather','Microsoft.GetHelp','Microsoft.Getstarted',
    'Microsoft.MicrosoftSolitaireCollection','Microsoft.People','Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps','Microsoft.Xbox.TCUI','Microsoft.XboxApp','Microsoft.XboxGameOverlay',
    'Microsoft.XboxGamingOverlay','Microsoft.XboxIdentityProvider','Microsoft.YourPhone',
    'Microsoft.ZuneMusic','Microsoft.ZuneVideo','king.com.CandyCrushSaga','Clipchamp.Clipchamp'
)
function Invoke-Debloat {
    $msg = "This removes $($DebloatApps.Count) built-in apps for the current user:`n" +
           "Bing News/Weather, Solitaire, Xbox apps, Your Phone, Candy Crush, Clipchamp and more.`n`nProceed?"
    if (-not (Show-ConfirmDialog -Title 'Confirm: Remove Bloatware' -Message $msg -AccentKey 'Warning')) { return }
    foreach ($app in $DebloatApps) {
        Get-AppxPackage -Name $app -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    Show-InfoDialog -Title 'Debloat Complete' -Message "Removed $($DebloatApps.Count) built-in apps (where present)."
}
#endregion

#region Utility functions
function Show-SystemInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $cs = Get-CimInstance Win32_ComputerSystem
    $msg = "Computer:  $env:COMPUTERNAME`nUser:      $env:USERNAME`nOS:        $($os.Caption)`nBuild:     $($os.BuildNumber)`nCPU:       $($cpu.Name)`nRAM:       $([math]::Round($cs.TotalPhysicalMemory/1GB,2)) GB"
    Show-InfoDialog -Title 'System Info' -Message $msg
}
function Invoke-CleanTemp {
    $paths = @("$env:TEMP\*","$env:WINDIR\Temp\*","$env:WINDIR\Prefetch\*")
    $freed = 0
    foreach ($p in $paths) {
        try {
            $size = (Get-ChildItem $p -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
            if ($size) { $freed += $size }
            Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        } catch {}
    }
    Show-InfoDialog -Title 'Cleanup Complete' -Message "Temp files cleaned.`nApprox $([math]::Round($freed/1MB,2)) MB freed."
}
function Invoke-FlushDns {
    ipconfig /flushdns | Out-Null
    Show-InfoDialog -Title 'Network' -Message 'DNS cache flushed successfully.'
}
function Show-WifiPasswords {
    $profiles = (netsh wlan show profiles) | Select-String ':(.+)$' | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
    if (-not $profiles) { Show-InfoDialog -Title 'WiFi Passwords' -Message 'No saved WiFi profiles found.'; return }
    $out = ''
    foreach ($name in $profiles) {
        $info = netsh wlan show profile name="$name" key=clear
        $line = $info | Select-String 'Key Content'
        if ($line) { $pw = ($line -split ':',2)[1].Trim(); $out += "$name`r`n  Password: $pw`r`n`r`n" }
        else { $out += "$name`r`n  (no password / open network)`r`n`r`n" }
    }
    Show-InfoDialog -Title 'Saved WiFi Passwords' -Message $out -Wide
}
function Export-InstalledPrograms {
    $paths = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
               'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
               'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $out = "$env:USERPROFILE\Desktop\GodServer_InstalledPrograms.txt"
    $progs = foreach ($p in $paths) {
        Get-ItemProperty $p -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -and -not $_.SystemComponent } |
            Select-Object DisplayName, DisplayVersion, Publisher
    }
    $progs = $progs | Sort-Object DisplayName -Unique
    $progs | Format-Table -AutoSize | Out-String | Set-Content $out
    Show-InfoDialog -Title 'Installed Programs' -Message "Exported $($progs.Count) programs to Desktop:`n$out"
    Start-Process notepad.exe $out
}
function Show-ProductKey {
    try {
        $key = (Get-CimInstance SoftwareLicensingService -ErrorAction Stop).OA3xOriginalProductKey
        $os = Get-CimInstance Win32_OperatingSystem
        $msg = "Windows Edition: $($os.Caption)`nVersion: $($os.Version)`n`n"
        if ($key) { $msg += "OEM Product Key (firmware):`n$key" }
        else { $msg += "No OEM key found in firmware.`nNormal if activated via digital license." }
        Show-InfoDialog -Title 'Windows Product Key' -Message $msg
    } catch {
        Show-InfoDialog -Title 'Error' -Message "Error reading product key:`n$($_.Exception.Message)"
    }
}
function Invoke-ResetNetwork {
    ipconfig /flushdns | Out-Null
    ipconfig /release | Out-Null
    ipconfig /renew | Out-Null
    netsh winsock reset | Out-Null
    netsh int ip reset | Out-Null
    netsh interface ipv4 reset | Out-Null
    netsh interface ipv6 reset | Out-Null
    Show-InfoDialog -Title 'Network Reset' -Message "Network adapters reset successfully.`n`nA restart is recommended for changes to take full effect."
}
#endregion

#region Dashboard data functions
function Get-CpuPercent {
    try { [math]::Round((Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'").PercentProcessorTime,0) }
    catch { 0 }
}
function Get-RamPercent {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $used = $os.TotalVisibleMemorySize - $os.FreePhysicalMemory
        [math]::Round(($used / $os.TotalVisibleMemorySize) * 100, 0)
    } catch { 0 }
}
function Get-DiskPercent {
    try {
        $d = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        if ($d) { [math]::Round((($d.Size - $d.FreeSpace) / $d.Size) * 100, 0) } else { 0 }
    } catch { 0 }
}
function Get-LocalIp {
    try { (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notlike '169.*' } | Select-Object -First 1).IPAddress }
    catch { $null }
}
function Get-GatewayIp {
    try { (Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Select-Object -First 1).NextHop }
    catch { $null }
}
function Get-DnsServers {
    try { ((Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.ServerAddresses } | Select-Object -First 1).ServerAddresses -join ', ') }
    catch { $null }
}
function Get-PublicIpAddress {
    try { (Invoke-RestMethod -Uri 'https://api.ipify.org' -TimeoutSec 4) } catch { 'Unavailable' }
}
#endregion

#region App catalog
$AppCatalog = [ordered]@{
    'Browsers' = @(
        @{Name='Brave Browser';Id='Brave.Brave'},
        @{Name='Google Chrome';Id='Google.Chrome'},
        @{Name='Mozilla Firefox';Id='Mozilla.Firefox'}
    )
    'Development' = @(
        @{Name='Visual Studio Code';Id='Microsoft.VisualStudioCode'},
        @{Name='Git';Id='Git.Git'},
        @{Name='Node.js LTS';Id='OpenJS.NodeJS.LTS'},
        @{Name='Python 3';Id='Python.Python.3.12'},
        @{Name='GitHub Desktop';Id='GitHub.GitHubDesktop'}
    )
    'Utilities' = @(
        @{Name='7-Zip';Id='7zip.7zip'},
        @{Name='Notepad++';Id='Notepad++.Notepad++'},
        @{Name='PowerToys';Id='Microsoft.PowerToys'},
        @{Name='Everything Search';Id='voidtools.Everything'},
        @{Name='ShareX';Id='ShareX.ShareX'}
    )
    'Media' = @(
        @{Name='VLC Media Player';Id='VideoLAN.VLC'},
        @{Name='Spotify';Id='Spotify.Spotify'},
        @{Name='OBS Studio';Id='OBSProject.OBSStudio'}
    )
    'Communication' = @(
        @{Name='Discord';Id='Discord.Discord'},
        @{Name='Telegram';Id='Telegram.TelegramDesktop'},
        @{Name='Zoom';Id='Zoom.Zoom'}
    )
    'Gaming' = @(
        @{Name='Steam';Id='Valve.Steam'},
        @{Name='Epic Games Launcher';Id='EpicGames.EpicGamesLauncher'},
        @{Name='MSI Afterburner';Id='Guru3D.Afterburner'}
    )
}
#endregion

#region Advanced (high-risk) tools - fetched from repo batch/ at run time
$AdvancedTools = @(
    @{ Name='Permanent Debloater'; Risk='!';   RiskKey='Warning'; File='permanent-debloater.bat'
       Warning="This permanently removes 25+ built-in apps (Cortana, Xbox, Skype, Maps, etc.) for ALL users, including provisioned packages - they will NOT return after Windows updates.`n`nProceed?" },
    @{ Name='EXM Premium Tweaks'; Risk='!!';  RiskKey='Danger';  File='exm-premium-tweaks.bat'
       Warning="HIGH RISK.`nDisables UAC, changes BCD boot config, disables Hyper-V/virtualization and System Restore, applies deep registry tweaks.`n`nLargely irreversible without manual cleanup. Create a System Restore point first.`n`nProceed?" },
    @{ Name='GodMode Ultimate'; Risk='!!';    RiskKey='Danger';  File='godmode.bat'
       Warning="HIGH RISK.`nRemoves Edge, OneDrive, Defender, Store and more. Disables 100+ services. Kills background processes. Hard to reverse.`n`nProceed?" },
    @{ Name='Nuclear Process Killer'; Risk='!!'; RiskKey='Danger'; File='nuclear-process-killer.bat'
       Warning="HIGH RISK.`nPermanently disables Windows Update AND Windows Defender, kills 100+ processes, disables 80+ services.`n`nOnly proceed if you run third-party antivirus.`n`nProceed?" },
    @{ Name='Auto BIOS Tweaks'; Risk='!!!';   RiskKey='Danger';  File='auto-bios.bat'
       Warning="EXTREME RISK - FIRMWARE MODIFICATION.`nRequires SCEWIN_64.exe. Disables Secure Boot, TPM, and other BIOS settings directly.`n`nCan cause boot failure or require a CMOS reset to recover. Gigabyte boards reportedly have issues.`n`nOnly proceed if you know exactly what you're doing." }
)
function Invoke-AdvancedTool($tool) {
    if (-not (Show-ConfirmDialog -Title "Confirm: $($tool.Name)" -Message $tool.Warning -AccentKey $tool.RiskKey)) { return }
    if (-not (Show-ConfirmDialog -Title 'Final Confirmation' -Message "Last chance to cancel.`n`nRun '$($tool.Name)' now?" -AccentKey 'Danger')) { return }
    $tmp = Join-Path $env:TEMP $tool.File
    try {
        Invoke-WebRequest -Uri "$Global:RepoBase/batch/$($tool.File)?v=$(Get-Random)" -OutFile $tmp -UseBasicParsing
        Start-Process cmd.exe -ArgumentList "/c `"$tmp`"" -Verb RunAs -Wait
        Show-InfoDialog -Title 'Done' -Message "$($tool.Name) finished running."
    } catch {
        Show-InfoDialog -Title 'Error' -Message "Failed to run $($tool.Name):`n$($_.Exception.Message)"
    } finally {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
}
#endregion

#region GUI construction
$script:Panels     = @{}
$script:NavButtons = @{}

function New-SectionHeader($parent, $title, $subtitle) {
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = $title
    $lblTitle.Font = $FontTitle
    $lblTitle.ForeColor = $T.TextDark
    $lblTitle.AutoSize = $true
    $lblTitle.Location = New-Object System.Drawing.Point(0, 0)
    $parent.Controls.Add($lblTitle)

    $lblSub = New-Object System.Windows.Forms.Label
    $lblSub.Text = $subtitle
    $lblSub.Font = $FontBody
    $lblSub.ForeColor = $T.TextMuted
    $lblSub.AutoSize = $true
    $lblSub.Location = New-Object System.Drawing.Point(2, 34)
    $parent.Controls.Add($lblSub)
}

function New-StatCard($parent, $x, $y, $w, $h, $label) {
    $card = New-Object GodServerUI.Card
    $card.Size = New-Object System.Drawing.Size($w, $h)
    $card.Location = New-Object System.Drawing.Point($x, $y)
    $card.BackColor = $T.White

    $lblVal = New-Object System.Windows.Forms.Label
    $lblVal.Text = '--%'
    $lblVal.Font = $FontStat
    $lblVal.ForeColor = $T.TextDark
    $lblVal.AutoSize = $true
    $lblVal.Location = New-Object System.Drawing.Point(18, 14)
    $card.Controls.Add($lblVal)

    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = $label
    $lblName.Font = $FontSmall
    $lblName.ForeColor = $T.TextMuted
    $lblName.AutoSize = $true
    $lblName.Location = New-Object System.Drawing.Point(18, 58)
    $card.Controls.Add($lblName)

    $track = New-Object System.Windows.Forms.Panel
    $track.BackColor = $T.OffWhite
    $track.Size = New-Object System.Drawing.Size(($w - 36), 6)
    $track.Location = New-Object System.Drawing.Point(18, 82)
    $card.Controls.Add($track)

    $fill = New-Object System.Windows.Forms.Panel
    $fill.BackColor = $T.Success
    $fill.Size = New-Object System.Drawing.Size(0, 6)
    $fill.Location = New-Object System.Drawing.Point(0, 0)
    $track.Controls.Add($fill)

    $parent.Controls.Add($card)
    return @{ Card=$card; ValueLabel=$lblVal; Track=$track; Fill=$fill }
}
function Update-StatCard($stat, $percent) {
    $p = [math]::Max(0, [math]::Min(100, $percent))
    $stat.ValueLabel.Text = "$p%"
    $color = if ($p -ge 85) { $T.Danger } elseif ($p -ge 60) { $T.Warning } else { $T.Success }
    $stat.Fill.BackColor = $color
    $w = [int]($stat.Track.Width * ($p / 100))
    $stat.Fill.Size = New-Object System.Drawing.Size([math]::Max(2,$w), 6)
}

function Build-DashboardPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White
    $panel.Padding = New-Object System.Windows.Forms.Padding(36,30,36,20)
    $panel.AutoScroll = $true

    $header = New-Object System.Windows.Forms.Panel
    $header.Size = New-Object System.Drawing.Size(900,60)
    $header.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($header)
    New-SectionHeader $header 'Dashboard' 'Live system overview'

    $cpuStat  = New-StatCard $panel 36  110 220 110 'CPU USAGE'
    $ramStat  = New-StatCard $panel 268 110 220 110 'RAM USAGE'
    $diskStat = New-StatCard $panel 500 110 220 110 'DISK USAGE (C:)'

    $netCard = New-Object GodServerUI.Card
    $netCard.Size = New-Object System.Drawing.Size(684, 190)
    $netCard.Location = New-Object System.Drawing.Point(36, 240)
    $panel.Controls.Add($netCard)

    $netTitle = New-Object System.Windows.Forms.Label
    $netTitle.Text = 'Network'
    $netTitle.Font = $FontHeading
    $netTitle.ForeColor = $T.TextDark
    $netTitle.AutoSize = $true
    $netTitle.Location = New-Object System.Drawing.Point(18,14)
    $netCard.Controls.Add($netTitle)

    $netInfoLbl = New-Object System.Windows.Forms.Label
    $netInfoLbl.Font = $FontBody
    $netInfoLbl.ForeColor = $T.TextDark
    $netInfoLbl.AutoSize = $true
    $netInfoLbl.Location = New-Object System.Drawing.Point(18,50)
    $netInfoLbl.Text = "Local IP:  loading...`nGateway:   loading...`nDNS:       loading...`nPublic IP: loading..."
    $netCard.Controls.Add($netInfoLbl)

    $pingBtn = New-Object GodServerUI.RoundedButton
    $pingBtn.Text = 'Ping 8.8.8.8'
    $pingBtn.NormalColor = $T.Gold; $pingBtn.HoverColor = $T.GoldDark
    $pingBtn.ForeColor = $T.White; $pingBtn.Font = $FontBodyB
    $pingBtn.Size = New-Object System.Drawing.Size(130,34)
    $pingBtn.Location = New-Object System.Drawing.Point(18,140)
    $netCard.Controls.Add($pingBtn)

    $pingResult = New-Object System.Windows.Forms.Label
    $pingResult.Font = $FontBody
    $pingResult.ForeColor = $T.TextMuted
    $pingResult.AutoSize = $true
    $pingResult.Location = New-Object System.Drawing.Point(160,148)
    $netCard.Controls.Add($pingResult)

    $pingBtn.Add_Click({
        $pingResult.Text = 'Pinging...'
        $pingResult.Refresh()
        try {
            $r = Test-Connection -ComputerName '8.8.8.8' -Count 4 -ErrorAction Stop
            $avg = [math]::Round(($r | Measure-Object ResponseTime -Average).Average,0)
            $pingResult.Text = "Avg latency: $avg ms  (4/4 replies)"
        } catch {
            $pingResult.Text = 'Ping failed / no reply'
        }
    })

    $refreshNet = {
        $ip = Get-LocalIp; $gw = Get-GatewayIp; $dns = Get-DnsServers; $pub = Get-PublicIpAddress
        $netInfoLbl.Text = "Local IP:  $ip`nGateway:   $gw`nDNS:       $dns`nPublic IP: $pub"
    }

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 2000
    $timer.Add_Tick({
        Update-StatCard $cpuStat (Get-CpuPercent)
        Update-StatCard $ramStat (Get-RamPercent)
        Update-StatCard $diskStat (Get-DiskPercent)
    })
    $timer.Start()

    $panel.Add_HandleCreated({ & $refreshNet })

    return $panel
}

function Build-AppsPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White

    $top = New-Object System.Windows.Forms.Panel
    $top.Size = New-Object System.Drawing.Size(900,70)
    $top.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($top)
    New-SectionHeader $top 'Install Apps' 'Powered by winget - select what you need'

    $scroll = New-Object System.Windows.Forms.Panel
    $scroll.Location = New-Object System.Drawing.Point(36,110)
    $scroll.Size = New-Object System.Drawing.Size(900,420)
    $scroll.AutoScroll = $true
    $panel.Controls.Add($scroll)

    $checkboxes = New-Object System.Collections.Generic.List[System.Windows.Forms.CheckBox]
    $y = 0
    foreach ($cat in $AppCatalog.Keys) {
        $catCard = New-Object GodServerUI.Card
        $items = $AppCatalog[$cat]
        $rows = [math]::Ceiling($items.Count / 3.0)
        $cardH = 44 + ($rows * 32) + 10
        $catCard.Size = New-Object System.Drawing.Size(860, $cardH)
        $catCard.Location = New-Object System.Drawing.Point(0, $y)
        $scroll.Controls.Add($catCard)

        $catLbl = New-Object System.Windows.Forms.Label
        $catLbl.Text = $cat
        $catLbl.Font = $FontHeading
        $catLbl.ForeColor = $T.TextDark
        $catLbl.AutoSize = $true
        $catLbl.Location = New-Object System.Drawing.Point(16,10)
        $catCard.Controls.Add($catLbl)

        $cx = 16; $cy = 44; $col = 0
        foreach ($app in $items) {
            $cb = New-Object System.Windows.Forms.CheckBox
            $cb.Text = $app.Name
            $cb.Tag = $app.Id
            $cb.Font = $FontBody
            $cb.ForeColor = $T.TextDark
            $cb.AutoSize = $true
            $cb.Location = New-Object System.Drawing.Point($cx, $cy)
            $catCard.Controls.Add($cb)
            $checkboxes.Add($cb)
            $col++
            if ($col -ge 3) { $col = 0; $cx = 16; $cy += 32 } else { $cx += 280 }
        }
        $y += $cardH + 14
    }

    $bottom = New-Object System.Windows.Forms.Panel
    $bottom.Location = New-Object System.Drawing.Point(36,540)
    $bottom.Size = New-Object System.Drawing.Size(900,150)
    $panel.Controls.Add($bottom)

    $installBtn = New-Object GodServerUI.RoundedButton
    $installBtn.Text = 'Install Selected'
    $installBtn.NormalColor = $T.Gold; $installBtn.HoverColor = $T.GoldDark
    $installBtn.ForeColor = $T.White; $installBtn.Font = $FontBodyB
    $installBtn.Size = New-Object System.Drawing.Size(160,38)
    $installBtn.Location = New-Object System.Drawing.Point(0,0)
    $bottom.Controls.Add($installBtn)

    $log = New-Object System.Windows.Forms.TextBox
    $log.Multiline = $true
    $log.ReadOnly = $true
    $log.ScrollBars = 'Vertical'
    $log.Font = $FontMono
    $log.BackColor = $T.OffWhite
    $log.ForeColor = $T.TextDark
    $log.Size = New-Object System.Drawing.Size(900,100)
    $log.Location = New-Object System.Drawing.Point(0,46)
    $bottom.Controls.Add($log)

    $script:__installJob = $null
    $jobTimer = New-Object System.Windows.Forms.Timer
    $jobTimer.Interval = 800
    $jobTimer.Add_Tick({
        if ($script:__installJob) {
            $out = Receive-Job -Job $script:__installJob -ErrorAction SilentlyContinue
            if ($out) { $log.AppendText(($out -join "`r`n") + "`r`n") }
            if ($script:__installJob.State -ne 'Running') {
                $log.AppendText("`r`n--- Done ---`r`n")
                Remove-Job -Job $script:__installJob -Force -ErrorAction SilentlyContinue
                $script:__installJob = $null
                $installBtn.Enabled = $true
                $installBtn.Text = 'Install Selected'
            }
        }
    })
    $jobTimer.Start()

    $installBtn.Add_Click({
        $selected = $checkboxes | Where-Object { $_.Checked } | ForEach-Object { $_.Tag }
        if (-not $selected -or $selected.Count -eq 0) {
            Show-InfoDialog -Title 'Install Apps' -Message 'Select at least one app first.'
            return
        }
        $log.Clear()
        $log.AppendText("Installing $($selected.Count) app(s) via winget...`r`n`r`n")
        $installBtn.Enabled = $false
        $installBtn.Text = 'Installing...'
        $script:__installJob = Start-Job -ScriptBlock {
            param($ids)
            foreach ($id in $ids) {
                Write-Output "==> $id"
                winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements 2>&1
            }
        } -ArgumentList (,$selected)
    })

    return $panel
}

function Build-TweaksPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White

    $top = New-Object System.Windows.Forms.Panel
    $top.Size = New-Object System.Drawing.Size(900,70)
    $top.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($top)
    New-SectionHeader $top 'System Tweaks' 'Safe, reversible - toggle on/off anytime'

    $scroll = New-Object System.Windows.Forms.Panel
    $scroll.Location = New-Object System.Drawing.Point(36,110)
    $scroll.Size = New-Object System.Drawing.Size(860,560)
    $scroll.AutoScroll = $true
    $panel.Controls.Add($scroll)

    $y = 0
    foreach ($tweak in $Tweaks) {
        $row = New-Object GodServerUI.Card
        $row.Size = New-Object System.Drawing.Size(830,64)
        $row.Location = New-Object System.Drawing.Point(0,$y)
        $scroll.Controls.Add($row)

        $nameLbl = New-Object System.Windows.Forms.Label
        $nameLbl.Text = $tweak.Name
        $nameLbl.Font = $FontBodyB
        $nameLbl.ForeColor = $T.TextDark
        $nameLbl.AutoSize = $true
        $nameLbl.Location = New-Object System.Drawing.Point(18,10)
        $row.Controls.Add($nameLbl)

        $descLbl = New-Object System.Windows.Forms.Label
        $descLbl.Text = $tweak.Desc
        $descLbl.Font = $FontSmall
        $descLbl.ForeColor = $T.TextMuted
        $descLbl.AutoSize = $true
        $descLbl.Location = New-Object System.Drawing.Point(18,34)
        $row.Controls.Add($descLbl)

        $toggle = New-Object GodServerUI.ToggleSwitch
        $toggle.Location = New-Object System.Drawing.Point(766,20)
        $toggle.Checked = Test-TweakEnabled $tweak
        $row.Controls.Add($toggle)

        $toggle.Add_Click({
            param($s,$e)
            $tw = $s.Tag
            if ($s.Checked) { Invoke-ApplyTweak $tw } else { Invoke-RevertTweak $tw }
            $s.Invalidate()
        })
        $toggle.Tag = $tweak

        $y += 76
    }

    # Debloat as a one-shot action (not cleanly revertible)
    $debloatRow = New-Object GodServerUI.Card
    $debloatRow.Size = New-Object System.Drawing.Size(830,64)
    $debloatRow.Location = New-Object System.Drawing.Point(0,$y)
    $scroll.Controls.Add($debloatRow)

    $dNameLbl = New-Object System.Windows.Forms.Label
    $dNameLbl.Text = 'Remove Bloatware Apps'
    $dNameLbl.Font = $FontBodyB
    $dNameLbl.ForeColor = $T.TextDark
    $dNameLbl.AutoSize = $true
    $dNameLbl.Location = New-Object System.Drawing.Point(18,10)
    $debloatRow.Controls.Add($dNameLbl)

    $dDescLbl = New-Object System.Windows.Forms.Label
    $dDescLbl.Text = 'Removes Candy Crush, Xbox bloat, etc. (one-time, not reversible)'
    $dDescLbl.Font = $FontSmall
    $dDescLbl.ForeColor = $T.TextMuted
    $dDescLbl.AutoSize = $true
    $dDescLbl.Location = New-Object System.Drawing.Point(18,34)
    $debloatRow.Controls.Add($dDescLbl)

    $dBtn = New-Object GodServerUI.RoundedButton
    $dBtn.Text = 'Run'
    $dBtn.NormalColor = $T.OffWhite; $dBtn.HoverColor = $T.Border
    $dBtn.ForeColor = $T.TextDark; $dBtn.Font = $FontBodyB
    $dBtn.Size = New-Object System.Drawing.Size(80,34)
    $dBtn.Location = New-Object System.Drawing.Point(732,15)
    $dBtn.Add_Click({ Invoke-Debloat })
    $debloatRow.Controls.Add($dBtn)

    return $panel
}

function Build-DriversPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White

    $top = New-Object System.Windows.Forms.Panel
    $top.Size = New-Object System.Drawing.Size(900,70)
    $top.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($top)
    New-SectionHeader $top 'Drivers' 'View installed drivers and check for updates'

    $btnRefresh = New-Object GodServerUI.RoundedButton
    $btnRefresh.Text = 'Refresh Driver List'
    $btnRefresh.NormalColor = $T.Gold; $btnRefresh.HoverColor = $T.GoldDark
    $btnRefresh.ForeColor = $T.White; $btnRefresh.Font = $FontBodyB
    $btnRefresh.Size = New-Object System.Drawing.Size(160,36)
    $btnRefresh.Location = New-Object System.Drawing.Point(36,108)
    $panel.Controls.Add($btnRefresh)

    $btnWU = New-Object GodServerUI.RoundedButton
    $btnWU.Text = 'Open Windows Update'
    $btnWU.NormalColor = $T.OffWhite; $btnWU.HoverColor = $T.Border
    $btnWU.ForeColor = $T.TextDark; $btnWU.Font = $FontBody
    $btnWU.Size = New-Object System.Drawing.Size(170,36)
    $btnWU.Location = New-Object System.Drawing.Point(206,108)
    $btnWU.Add_Click({ Start-Process 'ms-settings:windowsupdate-optionalupdates' })
    $panel.Controls.Add($btnWU)

    $grid = New-Object System.Windows.Forms.DataGridView
    $grid.Location = New-Object System.Drawing.Point(36,156)
    $grid.Size = New-Object System.Drawing.Size(900,470)
    $grid.BackgroundColor = $T.White
    $grid.BorderStyle = 'None'
    $grid.ReadOnly = $true
    $grid.AllowUserToAddRows = $false
    $grid.AutoSizeColumnsMode = 'Fill'
    $grid.RowHeadersVisible = $false
    $grid.Columns.Add('Device','Device Name') | Out-Null
    $grid.Columns.Add('Manufacturer','Manufacturer') | Out-Null
    $grid.Columns.Add('Version','Driver Version') | Out-Null
    $panel.Controls.Add($grid)

    $btnRefresh.Add_Click({
        $grid.Rows.Clear()
        Get-CimInstance Win32_PnPSignedDriver -ErrorAction SilentlyContinue |
            Where-Object { $_.DeviceName } | Sort-Object DeviceName |
            ForEach-Object { $grid.Rows.Add($_.DeviceName, $_.Manufacturer, $_.DriverVersion) | Out-Null }
    })

    return $panel
}

function Build-UtilitiesPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White

    $top = New-Object System.Windows.Forms.Panel
    $top.Size = New-Object System.Drawing.Size(900,70)
    $top.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($top)
    New-SectionHeader $top 'Utilities' 'One-click system tools'

    $tools = @(
        @{ Name='System Info';          Action={ Show-SystemInfo } },
        @{ Name='Clean Temp Files';     Action={ Invoke-CleanTemp } },
        @{ Name='Flush DNS';            Action={ Invoke-FlushDns } },
        @{ Name='Show WiFi Passwords';  Action={ Show-WifiPasswords } },
        @{ Name='List Installed Apps';  Action={ Export-InstalledPrograms } },
        @{ Name='Show Product Key';     Action={ Show-ProductKey } },
        @{ Name='Reset Network';        Action={ Invoke-ResetNetwork } },
        @{ Name='Restart Explorer';     Action={ Restart-ExplorerProcess } }
    )

    $cx = 36; $cy = 110; $col = 0
    foreach ($tool in $tools) {
        $btn = New-Object GodServerUI.RoundedButton
        $btn.Text = $tool.Name
        $btn.NormalColor = $T.OffWhite; $btn.HoverColor = $T.Border
        $btn.ForeColor = $T.TextDark; $btn.Font = $FontBodyB
        $btn.Size = New-Object System.Drawing.Size(280,64)
        $btn.Location = New-Object System.Drawing.Point($cx,$cy)
        $btn.Tag = $tool.Action
        $btn.Add_Click({ param($s,$e) & $s.Tag })
        $panel.Controls.Add($btn)
        $col++
        if ($col -ge 3) { $col = 0; $cx = 36; $cy += 78 } else { $cx += 296 }
    }

    return $panel
}

function Build-AdvancedPanel {
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.BackColor = $T.White

    $top = New-Object System.Windows.Forms.Panel
    $top.Size = New-Object System.Drawing.Size(900,70)
    $top.Location = New-Object System.Drawing.Point(36,30)
    $panel.Controls.Add($top)
    New-SectionHeader $top 'Advanced Tools' 'Deep system changes - read every warning before running'

    $y = 110
    foreach ($tool in $AdvancedTools) {
        $row = New-Object GodServerUI.Card
        $row.Size = New-Object System.Drawing.Size(900,68)
        $row.Location = New-Object System.Drawing.Point(36,$y)
        $row.BorderColor = $T[$tool.RiskKey]
        $panel.Controls.Add($row)

        $badge = New-Object System.Windows.Forms.Label
        $badge.Text = $tool.Risk
        $badge.Font = $FontBodyB
        $badge.ForeColor = $T.White
        $badge.BackColor = $T[$tool.RiskKey]
        $badge.TextAlign = 'MiddleCenter'
        $badge.Size = New-Object System.Drawing.Size(44,28)
        $badge.Location = New-Object System.Drawing.Point(16,20)
        $row.Controls.Add($badge)

        $nameLbl = New-Object System.Windows.Forms.Label
        $nameLbl.Text = $tool.Name
        $nameLbl.Font = $FontBodyB
        $nameLbl.ForeColor = $T.TextDark
        $nameLbl.AutoSize = $true
        $nameLbl.Location = New-Object System.Drawing.Point(74,20)
        $row.Controls.Add($nameLbl)

        $runBtn = New-Object GodServerUI.RoundedButton
        $runBtn.Text = 'Run'
        $runBtn.NormalColor = $T[$tool.RiskKey]; $runBtn.ForeColor = $T.White
        $runBtn.Font = $FontBodyB
        $runBtn.Size = New-Object System.Drawing.Size(90,36)
        $runBtn.Location = New-Object System.Drawing.Point(790,16)
        $runBtn.Tag = $tool
        $runBtn.Add_Click({ param($s,$e) Invoke-AdvancedTool $s.Tag })
        $row.Controls.Add($runBtn)

        $y += 80
    }

    return $panel
}

function Show-Section($key) {
    foreach ($k in $script:Panels.Keys) { $script:Panels[$k].Visible = ($k -eq $key) }
    foreach ($k in $script:NavButtons.Keys) {
        $script:NavButtons[$k].Selected = ($k -eq $key)
        $script:NavButtons[$k].Invalidate()
    }
}

function Build-MainForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'GOD SERVER'
    $form.FormBorderStyle = 'None'
    $form.Size = New-Object System.Drawing.Size(1280,800)
    $form.StartPosition = 'CenterScreen'
    $form.BackColor = $T.White
    $form.Font = $FontBody

    # Title bar
    $titleBar = New-Object System.Windows.Forms.Panel
    $titleBar.Dock = 'Top'
    $titleBar.Height = 42
    $titleBar.BackColor = $T.Sidebar
    $form.Controls.Add($titleBar)

    $titleLbl = New-Object System.Windows.Forms.Label
    $titleLbl.Text = 'GOD SERVER'
    $titleLbl.Font = $FontLogo
    $titleLbl.ForeColor = $T.Gold
    $titleLbl.AutoSize = $true
    $titleLbl.Location = New-Object System.Drawing.Point(20,8)
    $titleBar.Controls.Add($titleLbl)

    $verLbl = New-Object System.Windows.Forms.Label
    $verLbl.Text = "v$Global:AppVersion"
    $verLbl.Font = $FontSmall
    $verLbl.ForeColor = $T.TextMuted
    $verLbl.AutoSize = $true
    $verLbl.Location = New-Object System.Drawing.Point(150,15)
    $titleBar.Controls.Add($verLbl)

    $btnClose = New-Object System.Windows.Forms.Label
    $btnClose.Text = [char]0x2715
    $btnClose.Font = $FontBodyB
    $btnClose.ForeColor = $T.TextLight
    $btnClose.Size = New-Object System.Drawing.Size(42,42)
    $btnClose.TextAlign = 'MiddleCenter'
    $btnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnClose.Location = New-Object System.Drawing.Point(1238,0)
    $btnClose.Add_Click({ $form.Close() })
    $btnClose.Add_MouseEnter({ $btnClose.BackColor = $T.Danger })
    $btnClose.Add_MouseLeave({ $btnClose.BackColor = $T.Sidebar })
    $titleBar.Controls.Add($btnClose)

    $btnMin = New-Object System.Windows.Forms.Label
    $btnMin.Text = [char]0x2212
    $btnMin.Font = $FontBodyB
    $btnMin.ForeColor = $T.TextLight
    $btnMin.Size = New-Object System.Drawing.Size(42,42)
    $btnMin.TextAlign = 'MiddleCenter'
    $btnMin.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnMin.Location = New-Object System.Drawing.Point(1196,0)
    $btnMin.Add_Click({ $form.WindowState = 'Minimized' })
    $btnMin.Add_MouseEnter({ $btnMin.BackColor = $T.SidebarHover })
    $btnMin.Add_MouseLeave({ $btnMin.BackColor = $T.Sidebar })
    $titleBar.Controls.Add($btnMin)

    # Drag-to-move via title bar
    $script:__dragging = $false
    $script:__dragOff  = New-Object System.Drawing.Point(0,0)
    $titleBar.Add_MouseDown({ param($s,$e) $script:__dragging = $true; $script:__dragOff = New-Object System.Drawing.Point($e.X,$e.Y) })
    $titleBar.Add_MouseMove({
        param($s,$e)
        if ($script:__dragging) {
            $p = $form.PointToScreen((New-Object System.Drawing.Point($e.X,$e.Y)))
            $form.Location = New-Object System.Drawing.Point(($p.X - $script:__dragOff.X), ($p.Y - $script:__dragOff.Y))
        }
    })
    $titleBar.Add_MouseUp({ $script:__dragging = $false })

    # Body container
    $body = New-Object System.Windows.Forms.Panel
    $body.Dock = 'Fill'
    $form.Controls.Add($body)
    $body.BringToFront()

    # Sidebar
    $sidebar = New-Object System.Windows.Forms.Panel
    $sidebar.Dock = 'Left'
    $sidebar.Width = 230
    $sidebar.BackColor = $T.Sidebar
    $body.Controls.Add($sidebar)

    $logoSub = New-Object System.Windows.Forms.Label
    $logoSub.Text = 'WINDOWS TOOLBOX'
    $logoSub.Font = $FontSmall
    $logoSub.ForeColor = $T.TextMuted
    $logoSub.AutoSize = $true
    $logoSub.Location = New-Object System.Drawing.Point(28,20)
    $sidebar.Controls.Add($logoSub)

    $navItems = @(
        @{ Key='Dashboard'; Label='  Dashboard' },
        @{ Key='Apps';      Label='  Install Apps' },
        @{ Key='Tweaks';    Label='  Tweaks' },
        @{ Key='Drivers';   Label='  Drivers' },
        @{ Key='Utilities'; Label='  Utilities' },
        @{ Key='Advanced';  Label='  Advanced' }
    )
    $ny = 60
    foreach ($item in $navItems) {
        $nav = New-Object GodServerUI.NavButton
        $nav.Text = $item.Label
        $nav.Font = $FontNav
        $nav.ForeColor = $T.TextLight
        $nav.Size = New-Object System.Drawing.Size(230,48)
        $nav.Location = New-Object System.Drawing.Point(0,$ny)
        $nav.Tag = $item.Key
        $nav.Add_Click({ param($s,$e) Show-Section $s.Tag })
        $sidebar.Controls.Add($nav)
        $script:NavButtons[$item.Key] = $nav
        $ny += 48
    }

    $footLbl = New-Object System.Windows.Forms.Label
    $footLbl.Text = "Administrator`nGOD SERVER v$Global:AppVersion"
    $footLbl.Font = $FontSmall
    $footLbl.ForeColor = $T.TextMuted
    $footLbl.AutoSize = $true
    $footLbl.Location = New-Object System.Drawing.Point(28,714)
    $sidebar.Controls.Add($footLbl)

    # Content area
    $content = New-Object System.Windows.Forms.Panel
    $content.Dock = 'Fill'
    $content.BackColor = $T.White
    $body.Controls.Add($content)

    $script:Panels['Dashboard'] = Build-DashboardPanel
    $script:Panels['Apps']      = Build-AppsPanel
    $script:Panels['Tweaks']    = Build-TweaksPanel
    $script:Panels['Drivers']   = Build-DriversPanel
    $script:Panels['Utilities'] = Build-UtilitiesPanel
    $script:Panels['Advanced']  = Build-AdvancedPanel

    foreach ($k in $script:Panels.Keys) {
        $script:Panels[$k].Visible = $false
        $content.Controls.Add($script:Panels[$k])
    }

    Show-Section 'Dashboard'

    return $form
}
#endregion

$mainForm = Build-MainForm
[System.Windows.Forms.Application]::Run($mainForm)
