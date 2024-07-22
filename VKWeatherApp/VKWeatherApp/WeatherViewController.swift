//
//  ViewController.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import UIKit

final class WeatherViewController: UIViewController {

    private var timeOfDay: TimeOfDay = .day
    private var weatherType: WeatherType = .heavyRain
    private var weatherTypePicker = WeatherTypePicker(weathers: WeatherType.allCases)
    private var weatherView = UIView()
    private var backgroundViewForStatusBar = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
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
        selectWeatherType()
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
        
        let timeOfDayButton = UIBarButtonItem(image: UIImage(systemName: "clock"), style: .done, target: self, action: #selector(showTimeOfDayAlert))
        navigationItem.rightBarButtonItem = timeOfDayButton
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
            weatherTypePicker.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            weatherTypePicker.collectionView(weatherTypePicker, didSelectItemAt: indexPath)
        }
    }
    
    private func setupViewForWeatherType() -> UIView {
        switch weatherType {
            case .sunny:
                return SunView(progress: 0.5)
            case .cloudy:
                return CloudsView(thickness: .regular, topTint: .white, bottomTint: .white)
            case .mostlySunny:
                let sunView = SunView(progress: 0.5)
                sunView.addSubview(CloudsView(thickness: .thin, topTint: .white, bottomTint: .white))
                return sunView
            case .rain:
                return RainView(strength: 80)
            case .heavyRain:
                return RainView(strength: 200)
            case .thunderstorm:
                return ThunderstormView(stormType: .rain,strength: 200, cloudThickness: .thick, topTint: .darkGray, bottomTint: .darkGray)
            case .overcast:
                return CloudsView(thickness: .regular, topTint: .gray, bottomTint: .darkGray)
            case .snow:
                return RainView(stormType: .snow, strength: 300)
        }
    }
    
    private func setupBackgroundForWeatherType() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = weatherView.bounds
        gradientLayer.colors = getGradientColorsForCurrentWeather()
        
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
                return Colors.eveningGradint(fitting: weatherType)
            case .night:
                return [
                    UIColor(red: 0.25, green: 0.41, blue: 0.88, alpha: 1.0).cgColor,
                    UIColor(red: 0.11, green: 0.22, blue: 0.73, alpha: 1.0).cgColor
                ]
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
        let alertController = UIAlertController(title: NSLocalizedString("Select Time of Day", comment: "Select Time of Day"), message: nil, preferredStyle: .actionSheet)
        
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
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(weatherView, belowSubview: weatherTypePicker)
        setupBackgroundForWeatherType()
        setupConstraints()
    }
}
