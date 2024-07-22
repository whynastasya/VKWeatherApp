//
//  Storm.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class StormViewModel {
    
    enum Contents: CaseIterable {
        case still, rain, snow
    }

    var drops = [StormDrop]()
    var lastUpdate = Date()
    var image: UIImage

    init(type: Contents, direction: CGFloat, strength: Int) {
        switch type {
        case .snow:
            guard let snowParticleImage = UIImage(named: "snowParticle") else { image = UIImage(); return }
            image = snowParticleImage
        default:
            guard let rainParticleImage = UIImage(named: "rainParticle") else { image = UIImage(); return  }
            image = rainParticleImage
        }

        (0..<strength).forEach { _ in
            drops.append(StormDrop(type: type, direction: direction + CGFloat.pi / 2))
        }
    }

    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince(lastUpdate)
        let divisor = size.height / size.width
        
        if delta > 10 {
            lastUpdate = date
            return
        }

        drops.forEach { drop in
            let radians = drop.direction

            drop.x += cos(radians) * drop.speed * delta * divisor
            drop.y += sin(radians) * drop.speed * delta

            if drop.x < -0.2 {
                drop.x += 1.4
            }

            if drop.y > 1.2 {
                drop.x = Double.random(in: -0.2...1.2)
                drop.y -= 1.4
            }
        }

        lastUpdate = date
    }
}
