//
//  MeteorShower.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import Foundation

final class MeteorShower {
    var meteors = [Meteor]()
    
    func createMeteor(in size: CGSize) -> Meteor {
        let meteor: Meteor
        
        let randomBool = Bool.random()
        meteor = Meteor(
            x: randomBool ? 0 : Double(size.width),
            y: Double.random(in: 100...200),
            isMovingRight: randomBool
        )
        
        meteors.append(meteor)
        return meteor
    }
    
    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince1970
        
        for meteor in meteors {
            if meteor.isMovingRight {
                meteor.x += delta * meteor.speed
            } else {
                meteor.x -= delta * meteor.speed
            }

            meteor.speed -= delta * 900

            if meteor.speed < 0 {
                meteors.removeAll { $0 === meteor }
            } else if meteor.length < 100 {
                meteor.length += delta * 300
            }
        }
    }
}
