# MacLangSwitcherForVNC

This application designed to solve MacOS Catalina issue with changing locale, when you are working throught Screen Sharing app on another one Mac.

### Short history

In previous versions of MacOS (the last was High Sierra) keyboard in ScreenSharing worked different way. When you switched language inside remote Mac you could type that selected language. For example your local Mac has EN keyboard layout selected, you connected to remote Mac that has RU layout selected and when you type, Russian language will be typed.

Since Catalina they changed that behavior and now you will type EN letters even if remote Mac has RU layout currently. And it becomes even worse, since you can't change your local layout without settings focus to some local application or minimizing ScreenSharing app.

And this is where this small app helps you.

## How does it work

This application just switches your layout event when you are working with ScreenSharing app.

## How to setup
### Compile and start

1. Setup XCode to compile this application.
1. Open xcodeproj file in the application.
1. Build application.
1. Open Products folder and copy .app file into /Applications folder. 
1. Open System Preferences -> Security & Privacy -> Accesibility and drag app file there.
1. Start application.

### Switch off default hotkey

Switch off default layout switch by going to System Preferences -> Keyboard -> Shortcuts -> Input Sources and unchecking CMD+Space combination.

## Known issues

Current limitation is that hokey is hardcoded to CMD+SPACE and can not be changed. 

I would appreciate if somebody make the ability to change that in the interface.

