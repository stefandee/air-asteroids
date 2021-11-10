# AIR Asteroids
AIR Asteroids is an fancy Asteroids clone, written in Actionscript 3 and using the Flixel framework. It currently targets Adobe AIR (previously browser/Flash).

It was a take-home assignment during an interview with a game development company back in 2011. You can read my experience here: https://www.pirongames.com/flxasteroids-with-source-code/

## License
https://opensource.org/licenses/MIT

## Setup&Install

The instructions are for FlashDevelop and Windows. If you haven't installed it, please do so from https://www.flashdevelop.org/

Get the Adobe AIR SDK from https://airsdk.harman.com/. Unpack it in a folder of your chosing. The supplied FlashDevelop project assumes this folder to be C:\Tools\air-sdk, but if you choose another location, then please go to Project>Properties>SDK tab and add it there.

Clone the Flixel framework from https://github.com/AdamAtomic/flixel. The supplied project assumes ..\flixel, but if you choose another location, then please go to Project>Properties>Classpaths and add the folder.

Go to Project>Build Project (F8 shortcut) and run with Project>Run Project

## Building a Release Version

In .\bat folder, there are a couple of scripts that will help you do that. Use CreateCertificate.bat to create a certificate, then use PackageApp.bat to create the AIR app. The resulting file will be placed in .\air folder.

## Limitations

The game assumes a fixed resolution of 640x480 and will not scale with its window. Feel free to submit a patch ;)

I haven't tested any mobile (Android/Apple) build.