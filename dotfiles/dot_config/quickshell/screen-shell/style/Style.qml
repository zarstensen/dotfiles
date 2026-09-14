// qmllint disable import
// qmllint disable unqualified
pragma Singleton

import QtQuick
import Quickshell
import qs.style

Singleton {

    // colours

    property color cBackground: Nord.snowStorm2
    property color cBackgroundMuted: Nord.snowStorm1

    property color cForeground: Nord.polarNight1

    property color cText: Nord.polarNight2
    property color cTextMuted: Nord.polarNight3

    property color cHover: Nord.snowStorm1

    property color cPoweroff: Nord.auroraRed
    property color cReboot: Nord.auroraOrange
    property color cLock: Nord.auroraPurple
    property color cSleep: Nord.auroraYellow
    property color cLogoff: Nord.frost4

    // fonts

    property string _fontFamily: "JetBrainsMonoNerdFontPropo"

    property font fHeader: ({
            family: _fontFamily,
            pixelSize: 24,
            weight: Font.Bold
        })

    property font fBody: ({
            family: _fontFamily,
            pixelSize: 15,
            weight: Font.Normal
        })

    property font fBodySm: ({
            family: _fontFamily,
            pixelSize: 11,
            weight: Font.Normal
        })

    property font fIcon: ({
            family: _fontFamily,
            pixelSize: 22,
            weight: Font.Normal
        })
    property font fIconSm: ({
            family: _fontFamily,
            pixelSize: 18,
            weight: Font.Normal
        })
    // animation

    property int aXFast: 100
    property int aFast: 200
    property int aMed: 400

    // misc. numeric constants
    property int nBarHeight: 45
    property int nWidgetSpacing: (nBarHeight - 12) / 2
    property int nRadius: 4
}
