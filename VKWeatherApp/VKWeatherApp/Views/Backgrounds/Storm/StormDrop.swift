//
//  StormDrop.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import Foundation

final class StormDrop {
    var x: CGFloat
    var y: CGFloat
    var xScale: CGFloat
    var yScale: CGFloat
    var speed: CGFloat
    var opacity: CGFloat

    var direction: CGFloat
    var rotation: CGFloat
    var rotationSpeed: CGFloat

    init(type: StormViewModel.Contents, direction: CGFloat) {
        if type == .snow {
            self.direction = direction + CGFloat.random(in: -15...15).toRadians()
        } else {
            self.direction = direction
        }

        x = CGFloat.random(in: -0.2...1.2)
        y = CGFloat.random(in: -0.2...1.2)

        switch type {
        case .snow:
            xScale = CGFloat.random(in: 0.125...1)
            yScale = xScale * CGFloat.random(in: 0.5...1)
            speed = CGFloat.random(in: 0.2...0.6)
            opacity = CGFloat.random(in: 0.2...1)
            rotation = CGFloat.random(in: 0...360).toRadians()
            rotationSpeed = CGFloat.random(in: -360...360).toRadians()
        default:
            xScale = CGFloat.random(in: 0.4...1)
            yScale = xScale
            speed = CGFloat.random(in: 1...2)
            opacity = CGFloat.random(in: 0.05...0.3)
            rotation = 0
            rotationSpeed = 0
        }
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180
    }
}
