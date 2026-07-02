import QtQuick
import QtQuick.Effects

import qs.config

Item {
    id: root

    property bool edgeLeft: false
    property bool edgeRight: false

    default property alias component: innerContainer.children

    readonly property int shadowHeight: Math.ceil(shadow.shadowVerticalOffset)
    readonly property int shadowWidth: Math.ceil(shadow.shadowHorizontalOffset)

    property real lightAngle: Config.theme.gradientDegree
    readonly property real lightAngleRad: (this.lightAngle * Math.PI) / 180
    readonly property real absSin: Math.abs(Math.sin(this.lightAngleRad))
    readonly property real absCos: Math.abs(Math.cos(this.lightAngleRad))

    readonly property bool hideLeft: Config.bar.margins === 0 && this.edgeLeft
    readonly property bool hideRight: Config.bar.margins === 0 && this.edgeRight
    readonly property bool hideTop: Config.bar.margins === 0 && Config.bar.onTop
    readonly property bool hideBottom: Config.bar.margins === 0 && !Config.bar.onTop

    readonly property int computedTopLeftRadius: (this.hideTop || this.hideLeft) ? 0 : Config.bar.radius
    readonly property int computedTopRightRadius: (this.hideTop || this.hideRight) ? 0 : Config.bar.radius
    readonly property int computedBottomLeftRadius: (this.hideBottom || this.hideLeft) ? 0 : Config.bar.radius
    readonly property int computedBottomRightRadius: (this.hideBottom || this.hideRight) ? 0 : Config.bar.radius

    Rectangle {
        id: shapeMask
        visible: true

        anchors {
            fill: parent
            leftMargin: root.hideLeft ? -Config.bar.borderWidth : 0
            topMargin: root.hideTop ? -Config.bar.borderWidth : 0
            rightMargin: root.hideRight ? -Config.bar.borderWidth : 0
            bottomMargin: root.hideBottom ? -Config.bar.borderWidth : 0
        }

        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius

        color: "black"
    }

    ShaderEffectSource {
        id: maskTexture
        sourceItem: shapeMask
        hideSource: true
        live: true
    }

    Item {
        id: borderContainer
        visible: false
        width: shapeMask.width
        height: shapeMask.height

        Rectangle {
            id: borderRectangle
            anchors.centerIn: parent

            width: parent.width * root.absCos + parent.height * root.absSin
            height: parent.width * root.absSin + parent.height * root.absCos
            rotation: root.lightAngle

            gradient: Gradient {
                GradientStop { position: 0.3; color: Config.theme.primaryContainer }
                GradientStop { position: 0.9; color: Config.theme.primaryContainerFg }
            }
        }
    }

    MultiEffect {
        id: maskedBorder
        visible: false
        anchors.fill: shapeMask
        source: borderContainer
        maskSource: maskTexture
        maskEnabled: true
    }

    MultiEffect {
        id: shadow
        anchors.fill: shapeMask
        source: maskedBorder

        shadowEnabled: true
        shadowBlur: 0.6
        shadowColor: Config.theme.shadow

        shadowHorizontalOffset: -Math.cos(root.lightAngleRad) * Config.theme.shadowLength
        shadowVerticalOffset: Math.sin(root.lightAngleRad) * Config.theme.shadowLength
    }

    Rectangle {
        id: innerContainer
        anchors {
            fill: shapeMask
            margins: Config.bar.borderWidth
        }

        topLeftRadius: root.computedTopLeftRadius
        topRightRadius: root.computedTopRightRadius
        bottomLeftRadius: root.computedBottomLeftRadius
        bottomRightRadius: root.computedBottomRightRadius

        color: Config.theme.surface
    }
}
