//
//  Meteor.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

final class Meteor {
    var x: Double
    var y: Double
    var isMovingRight: Bool
    var speed: Double
    var length: Double
    
    init(x: Double, y: Double, isMovingRight: Bool) {
        self.x = x
        self.y = y
        self.isMovingRight = isMovingRight
        self.speed = Double.random(in: 300...500)
        self.length = 0
    }
}
