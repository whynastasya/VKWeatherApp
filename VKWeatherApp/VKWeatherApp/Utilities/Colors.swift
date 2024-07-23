//
//  Colors.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

enum Colors {
    
    static let weatherTypePicker = UIColor.white.withAlphaComponent(0.4)
    static let lightCloud = UIColor.white
    static let darkCloudStart = UIColor.gray
    static let darkCloudEnd = UIColor.darkGray
    
    static func daytimeGradient(fitting weatherType: WeatherType) -> [CGColor] {
        switch weatherType {
            case .sunny, .mostlySunny, .snow, .cloudy:
                return [
                    UIColor(red: 0.5, green: 0.81, blue: 1.00, alpha: 1.0).cgColor,
                    UIColor(red: 0.00, green: 0.58, blue: 1.00, alpha: 1.0).cgColor
                ]
            case .rain, .heavyRain:
                return [
                    UIColor(red: 0.36, green: 0.54, blue: 0.72, alpha: 1.0).cgColor,
                    UIColor(red: 0.17, green: 0.24, blue: 0.38, alpha: 1.0).cgColor
                ]
            case .thunderstorm, .overcast:
                return [
                    UIColor(red: 0.23, green: 0.32, blue: 0.43, alpha: 1.0).cgColor,
                    UIColor(red: 0.12, green: 0.17, blue: 0.22, alpha: 1.0).cgColor
                ]
        }
    }
    
    static func eveningGradient(fitting weatherType: WeatherType) -> [CGColor] {
        switch weatherType {
            case .sunny, .mostlySunny, .cloudy, .snow:
                return [
                    UIColor(red: 0.50, green: 0.65, blue: 1.00, alpha: 1.0).cgColor,
                    UIColor(red: 0.50, green: 0.70, blue: 1.00, alpha: 1.0).cgColor,
                    UIColor(red: 1.00, green: 0.85, blue: 0.50, alpha: 1.0).cgColor, 
                    UIColor(red: 1.00, green: 0.50, blue: 0.50, alpha: 1.0).cgColor
                ]
            case .rain, .heavyRain:
                return [
                    UIColor(red: 0.36, green: 0.54, blue: 0.72, alpha: 1.0).cgColor,
                    UIColor(red: 0.17, green: 0.24, blue: 0.38, alpha: 1.0).cgColor
                ]
            case .thunderstorm, .overcast:
                return [
                    UIColor(red: 0.23, green: 0.32, blue: 0.43, alpha: 1.0).cgColor,
                    UIColor(red: 0.12, green: 0.17, blue: 0.22, alpha: 1.0).cgColor
                ]
        }
    }
}

