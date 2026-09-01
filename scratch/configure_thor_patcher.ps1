$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# 1. Update Configuration/config.ini
$configIniPath = "d:\SERVER_RO\LevitationRO\patcher\Configuration\config.ini"
$configIniContent = @"
[Config:Main]

RootURL='http://167.86.87.207/patch/'

RemoteConfigFile='main.ini'

TimeOut=0

StatusFile='server.dat'

DefaultGRF='custom.grf'

ClientEXE='ZenithRO.exe'
ClientParameter='-1sak1'

//When patcher unable to connect webserver,
//should the patcher allow player start the game anyways?
FinishOnConnectionFailure=false

[Config:Window]

Style='none'

//This allows the player drag the window by background
DragHandling=true

//Background can be either jpg or bmp, in later case
//the top-left pixel is chosen as transparent color.
Background='images/bg.bmp'

FadeOnDrag=true

[Config:BGM]
File=''

Loop=true

Volume=5

Directory=

[Config:Misc]
Title='ZenithRO Patcher'

HideProgressBarWhenFinish=true


[ProgressBar:bar1]
Width=342
Height=10

Left=23
Top=486

FrontImage=
BackImage=

Hook='ProgressChange'



[Label:Status]
AutoResize = false

Width=369
Height=

Left=15
Top=498
Alignment='center'

FontColor=$000000
FontName = ''
FontSize =

Text=''

Hook='StatusChange'

[NoticeBox:Box0]
Width=347
Height=250
Left=21
Top=217
URL='http://167.86.87.207/patch/notice.html'



[Button:Start]
Default='images/start1.png'
OnHover='images/start2.png'
OnDown='images/start3.png'

Left=383
Top=211

//Hook is used for default buttons,
//do not use this on custom buttons!
Hook='Start'

[Button:Exit]
Default='images/Exit1.png'
OnHover='images/Exit2.png'
OnDown='images/Exit3.png'

Left=383
Top=244

Hook='Exit'

[Button:Cancel]
Default='images/Exit1.png'
OnHover='images/Exit2.png'
OnDown='images/Exit3.png'

Left=383
Top=211
Hook='Cancel'
"@

[System.IO.File]::WriteAllText($configIniPath, $configIniContent, $utf8NoBom)
Write-Host "Updated Configuration/config.ini successfully!"

# 2. Update Web/main.ini
$mainIniPath = "d:\SERVER_RO\LevitationRO\patcher\Web\main.ini"
$mainIniContent = @"
//Thor Patcher remote config file for ZenithRO
[Main]
//Allow patching or not?
allow=true

//Should patcher ignore everything else and finish patch immediately?
Force_Start=false

//if not, what message should appear?
policy_msg=Server is under maintenance. Please try again later.

//file_url - patch files directory on web server
file_url=http://167.86.87.207/patch/data/

[Patch]
//Checksum hash for client & patcher (leave empty to disable)
ClientSum=
PatcherSum=

ClientPath=
PatcherPath=

// Patch list file
PatchList=plist.txt

[Stars]
clients=0

[Misc]
FragmentLimit=50
"@

[System.IO.File]::WriteAllText($mainIniPath, $mainIniContent, $utf8NoBom)
Write-Host "Updated Web/main.ini successfully!"

# 3. Update Web/plist.txt
$plistPath = "d:\SERVER_RO\LevitationRO\patcher\Web\plist.txt"
$plistContent = "// ZenithRO Patch List File`n// Format: <Patch_ID> <Patch_Filename.thor>`n// Example:`n// 1 custom_bgm.thor`n"
[System.IO.File]::WriteAllText($plistPath, $plistContent, $utf8NoBom)
Write-Host "Updated Web/plist.txt successfully!"

# 4. Update Web/notice.html
$noticePath = "d:\SERVER_RO\LevitationRO\patcher\Web\notice.html"
$noticeContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZenithRO News</title>
    <style>
        :root {
            --bg-color: #0b0c10;
            --card-bg: #1f2833;
            --border-color: #45a29e;
            --accent-gold: #f4c430;
            --accent-cyan: #66fcf1;
            --text-main: #c5c6c7;
            --text-muted: #8892b0;
            --status-online: #45a29e;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            user-select: none;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 12px;
            padding: 10px;
            overflow-x: hidden;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 4px;
            padding: 8px 12px;
            margin-bottom: 10px;
        }

        .title {
            font-weight: 700;
            font-size: 14px;
            color: var(--accent-gold);
            text-transform: uppercase;
        }

        .status {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            color: var(--accent-cyan);
            font-weight: 600;
        }

        .dot {
            width: 7px;
            height: 7px;
            background-color: var(--accent-cyan);
            border-radius: 50%;
            box-shadow: 0 0 5px var(--accent-cyan);
        }

        .news-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .news-item {
            background: var(--card-bg);
            border-left: 3px solid var(--accent-cyan);
            border-radius: 3px;
            padding: 8px 10px;
        }

        .news-item-title {
            font-size: 12px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 3px;
        }

        .news-item-desc {
            font-size: 11px;
            color: var(--text-main);
            line-height: 1.4;
        }

        .badge {
            display: inline-block;
            padding: 1px 5px;
            font-size: 9px;
            font-weight: 700;
            border-radius: 3px;
            margin-right: 5px;
            text-transform: uppercase;
        }

        .badge-update { background-color: #1f4068; color: #66fcf1; }
        .badge-notice { background-color: #4a3f18; color: #f4c430; }

        .footer {
            margin-top: 10px;
            text-align: center;
            font-size: 10px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>

    <div class="header">
        <div class="title">ZenithRO</div>
        <div class="status">
            <div class="dot"></div>
            <span>Server Online</span>
        </div>
    </div>

    <div class="news-list">
        <div class="news-item">
            <div class="news-item-title">
                <span class="badge badge-update">Update</span>Twilight Weapons & Reroll System
            </div>
            <div class="news-item-desc">
                Twilight Weapons, Valkyrie Kara reroll system, and refinement balance are live! Speak with Valkyrie Kara in Valhalla.
            </div>
        </div>

        <div class="news-item">
            <div class="news-item-title">
                <span class="badge badge-notice">Notice</span>Welcome to ZenithRO!
            </div>
            <div class="news-item-desc">
                Make sure your patcher stays updated for the latest items, maps, and server features.
            </div>
        </div>
    </div>

    <div class="footer">
        ZenithRO &copy; 2026
    </div>

</body>
</html>
"@

[System.IO.File]::WriteAllText($noticePath, $noticeContent, $utf8NoBom)
Write-Host "Updated Web/notice.html successfully!"
