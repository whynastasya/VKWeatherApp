//
//  WeatherTextCollectionViewCell.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import UIKit

final class WeatherTypeCell: UICollectionViewCell {
    
    static let identifier = "WeatherTextCollectionViewCell"
    private var weatherTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: WeatherType, isSelected: Bool) {
        weatherTitleLabel.text = weather.localizedName.lowercased()
        weatherTitleLabel.textColor = isSelected ? .black : .darkGray
    }
    
    private func setupContentView() {
        setupWeatherTitleLabel()
        setupConstraints()
    }
    
    private func setupWeatherTitleLabel() {
        weatherTitleLabel.font = Fonts.weatherTypePicker
        weatherTitleLabel.textAlignment  = .center
        weatherTitleLabel.text = "Солнечно"
        weatherTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weatherTitleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
