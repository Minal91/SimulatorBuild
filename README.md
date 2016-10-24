# SimulatorBuild
Create simulator build application for Facebook approval etc

## Time to say "Goodbye World"
Please note that plugins are not supported by Xcode 8. See [#475](https://github.com/alcatraz/Alcatraz/issues/475) for more information.

## Install
1.Put SimulatorBuild.xcplugin file at location ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins

(NOTE: If path doesn't exist then please install [Alcatraz](https://github.com/alcatraz/Alcatraz) first)

2.Restart Xcode

## Uninstall
Remove SimulatorBuild.xcplugin file at location ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/.

OR

Run `rm -r ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/SimulatorBuild.xcplugin` in Terminal.

## Usage
Xcode window option contains an menu item entitled as "Simulator Build" for creation of Simulator Build.

![Screenshot](https://github.com/Minal91/SimulatorBuild/blob/master/CreateSimulatorBuild.gif)

## Test
Run `xcrun simctl install booted <app-path>` to install build into booted simulator in Terminal.

(NOTE:For more xcrun simctl [subcommands](http://dduan.net/post/2015/02/build-and-run-ios-apps-in-commmand-line/))
