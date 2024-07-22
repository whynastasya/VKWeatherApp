//
//  StarField.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import Foundation

final class StarField {
    var stars = [Star]()
    
    func createStar(in size: CGSize) -> Star {
        let star = Star(
            x: Double.random(in: 0...Double(size.width)),
            y: Double.random(in: 0...Double(size.height)),
            size: Double.random(in: 1...3),
            flickerInterval: Double.random(in: 0...1)
        )
        stars.append(star)
        return star
    }
    
    func update(date: Date) {
        let timeInterval = date.timeIntervalSince1970
        for star in stars {
            if star.flickerInterval == 0 {
                let flashLevel = sin(Double(stars.firstIndex(where: { $0 === star }) ?? 0) + timeInterval * 4)
                star.size = 0.5 + abs(flashLevel) / 1.5
            } else {
                var flashLevel = sin(Double(stars.firstIndex(where: { $0 === star }) ?? 0) + timeInterval)
                flashLevel *= star.flickerInterval
                flashLevel -= star.flickerInterval - 1
                star.size = max(flashLevel, 0)
            }
        }
    }
}
