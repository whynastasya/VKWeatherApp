//
//  ViewController.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import UIKit

final class WeatherViewController: UIViewController {

    private var timeOfDay: TimeOfDay = .night
    private var weatherType: WeatherType = .heavyRain
    private var weatherTypePicker = WeatherTypePicker(weathers: WeatherType.allCases)
    private var weatherView = UIView()
    private var backgroundViewForStatusBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectWeatherType()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBackgroundForWeatherType()
    }
    
    private func setupContentView() {
        setupWeatherView()
        setupWeatherTypePicker()
        setupNavigationBar()
        setupBackgroundViewForStatusBar()
        setupConstraints()
    }
    
    private func setupWeatherTypePicker() {
        weatherTypePicker.weatherTypePickerDelegate = self
        weatherTypePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherTypePicker)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("NavigationBarTitle", comment: "Weather")
        navigationController?.navigationBar.prefersLargeTitles = true
        updateNavigationBarButtonColor()
    }

    private func updateNavigationBarButtonColor() {
        let color: UIColor
        if traitCollection.userInterfaceStyle == .dark {
            color = .white
        } else {
            color = .black
        }
        
        let timeOfDayButton = UIBarButtonItem(image: UIImage(systemName: "clock")?.withTintColor(color, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(showTimeOfDayAlert))
        navigationItem.rightBarButtonItem = timeOfDayButton
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateNavigationBarButtonColor()
        }
    }

    
    private func setupWeatherView() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(weatherView, belowSubview: weatherTypePicker)
        setupBackgroundForWeatherType()
    }
    
    private func setupBackgroundViewForStatusBar() {
        backgroundViewForStatusBar.backgroundColor = Colors.weatherTypePicker
        backgroundViewForStatusBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundViewForStatusBar)
    }
    
    private func selectWeatherType() {
        let randomWeatherType = WeatherType.allCases.randomElement() ?? .sunny
        
        if let index = WeatherType.allCases.firstIndex(of: randomWeatherType) {
            let indexPath = IndexPath(item: index, section: 0)
            weatherTypePicker.collectionView(weatherTypePicker, didSelectItemAt: indexPath)
            weatherTypePicker.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func setupViewForWeatherType() -> UIView {
        switch weatherType {
            case .sunny:
                switch timeOfDay {
                    case .day:
                        return SunView(progress: 0.5)
                    case .evening:
                        return SunView(progress: 0.98)
                    case .night:
                        return StarsView(frame: view.bounds)
                }
            case .cloudy:
                var colors = (Colors.lightCloud, Colors.lightCloud)
                var cloudsView = CloudsView(thickness: .regular, topTint: colors.0, bottomTint: colors.1)
                switch timeOfDay {
                    case .day:
                        colors = (Colors.lightCloud, Colors.lightCloud)
                    case .evening:
                        colors = (Colors.sunsetCloud, Colors.lightCloud)
                    case .night:
                        colors = (Colors.lightCloud.withAlphaComponent(0.1), Colors.lightCloud.withAlphaComponent(0.1))
                        cloudsView.addSubview(StarsView(frame: view.bounds))
                }
                return cloudsView
            case .mostlySunny:
                var mostlySunnyView = UIView()
                var colors = (Colors.lightCloud, Colors.lightCloud)
                switch timeOfDay {
                    case .day:
                        mostlySunnyView = SunView(progress: 0.5)
                        colors = (Colors.lightCloud, Colors.lightCloud)
                    case .evening:
                        mostlySunnyView = SunView(progress: 0.98)
                        colors = (Colors.sunsetCloud, Colors.lightCloud)
                    case .night:
                        colors = (Colors.lightCloud, Colors.lightCloud)
                        mostlySunnyView = StarsView(frame: view.bounds)
                }
                mostlySunnyView.addSubview(CloudsView(thickness: .thin, topTint: colors.0, bottomTint: colors.1))
                return mostlySunnyView
            case .rain:
                return RainView(strength: 80)
            case .heavyRain:
                return RainView(strength: 200)
            case .thunderstorm:
                return ThunderstormView(stormType: .rain,strength: 200, cloudThickness: .thick, topTint: Colors.darkCloudEnd, bottomTint: Colors.darkCloudEnd)
            case .overcast:
                return CloudsView(thickness: .regular, topTint: Colors.darkCloudStart, bottomTint: Colors.darkCloudEnd)
            case .snow:
                return RainView(stormType: .snow, strength: 300)
        }
    }
    
    private func setupBackgroundForWeatherType() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = weatherView.bounds
        gradientLayer.colors = getGradientColorsForCurrentWeather()
            
        if  timeOfDay == .evening, [.sunny, .mostlySunny, .cloudy, .snow].contains(weatherType) {
            gradientLayer.locations = [0.0, 0.5, 0.8, 0.99, 1.0]
        }
        
        if let sublayers = weatherView.layer.sublayers {
            for layer in sublayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        weatherView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func getGradientColorsForCurrentWeather() -> [CGColor] {
        switch timeOfDay {
            case .day:
                return Colors.daytimeGradient(fitting: weatherType)
            case .evening:
                return Colors.eveningGradient(fitting: weatherType)
            case .night:
                return Colors.nightGradient(fitting: weatherType)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherTypePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherTypePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTypePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTypePicker.heightAnchor.constraint(equalToConstant: 50),
            
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backgroundViewForStatusBar.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundViewForStatusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundViewForStatusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundViewForStatusBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc private func showTimeOfDayAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Select Time of Day", comment: "Select Time of Day"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let textColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        
        let titleAttrString = NSAttributedString(string: NSLocalizedString("Select Time of Day", comment: "Select Time of Day"), attributes: [
            .foregroundColor: textColor
        ])
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        
        let dayAction = UIAlertAction(title: NSLocalizedString("Day", comment: "Day"), style: .default) { _ in
            self.timeOfDay = .day
            self.setupBackgroundForWeatherType()
        }
        let eveningAction = UIAlertAction(title: NSLocalizedString("Evening", comment: "Evening"), style: .default) { _ in
            self.timeOfDay = .evening
            self.setupBackgroundForWeatherType()
        }
        let nightAction = UIAlertAction(title: NSLocalizedString("Night", comment: "Night"), style: .default) { _ in
            self.timeOfDay = .night
            self.setupBackgroundForWeatherType()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        
        dayAction.setValue(textColor, forKey: "titleTextColor")
        eveningAction.setValue(textColor, forKey: "titleTextColor")
        nightAction.setValue(textColor, forKey: "titleTextColor")
        cancelAction.setValue(textColor, forKey: "titleTextColor")
        
        alertController.addAction(dayAction)
        alertController.addAction(eveningAction)
        alertController.addAction(nightAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherViewController: WeatherTypePickerDelegate {
    func didSelectWeatherType(_ weatherType: WeatherType) {
        self.weatherType = weatherType
        weatherView.removeFromSuperview()
        weatherView = setupViewForWeatherType()
        setupWeatherView()
        setupConstraints()
    }
}
