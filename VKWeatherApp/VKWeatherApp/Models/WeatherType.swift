//
//  WeatherType.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import Foundation

enum WeatherType: CaseIterable {
    case sunny
    case mostlySunny
    case cloudy
    case rain
    case heavyRain
    case thunderstorm
    case overcast
    case snow
    
    var localizedName: String {
        switch self {
            case .sunny:
                NSLocalizedString("Sunny", comment: "Weather")
            case .mostlySunny:
                NSLocalizedString("Mostly_Sunny", comment: "Weather")
            case .cloudy:
                NSLocalizedString("Cloudy", comment: "Weather")
            case .rain:
                NSLocalizedString("Rain", comment: "Weather")
            case .heavyRain:
                NSLocalizedString("Heavy_Rain", comment: "Weather")
            case .thunderstorm:
                NSLocalizedString("Thunderstorm", comment: "Weather")
            case .overcast:
                NSLocalizedString("Overcast", comment: "Weather")
            case .snow:
                NSLocalizedString("Snow", comment: "Weather")
        }
    }
}


