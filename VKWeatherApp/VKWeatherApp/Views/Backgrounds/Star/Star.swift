//
//  Star.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

final class Star {
    var x: Double
    var y: Double
    var size: Double
    var flickerInterval: Double
    
    init(x: Double, y: Double, size: Double, flickerInterval: Double) {
        self.x = x
        self.y = y
        self.size = size
        self.flickerInterval = flickerInterval
    }
}
