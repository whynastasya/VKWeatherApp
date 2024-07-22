//
//  WeatherTypePickerDelegate.swift
//  VKWeatherApp
//
//  Created by nastasya on 20.07.2024.
//

protocol WeatherTypePickerDelegate: AnyObject {
    func didSelectWeatherType(_ weatherType: WeatherType)
}
