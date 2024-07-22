//
//  WeatherTextCollectionView.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import UIKit

final class WeatherTypePicker: UICollectionView {
    
    weak var weatherTypePickerDelegate: WeatherTypePickerDelegate?
    
    var weatherTypes = [WeatherType]()
    var selectedWeatherType: IndexPath?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
        backgroundColor = Colors.weatherTypePicker
    }
    
    convenience init(weathers: [WeatherType]) {
        let layout = BottomAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.init(frame: .zero, collectionViewLayout: layout)
        self.weatherTypes = weathers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        register(WeatherTypeCell.self, forCellWithReuseIdentifier: WeatherTypeCell.identifier)
        showsHorizontalScrollIndicator = false
    }
}

extension WeatherTypePicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherTypeCell.identifier,
            for: indexPath
        ) as? WeatherTypeCell
        let isSelected = indexPath == selectedWeatherType
        cell?.configure(with: weatherTypes[indexPath.item], isSelected: isSelected)
        return cell ?? UICollectionViewCell()
    }
}

extension WeatherTypePicker: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let weather = weatherTypes[indexPath.item]
        let font = Fonts.weatherTypePicker
        let size = weather.localizedName.size(withAttributes: [NSAttributedString.Key.font: font])
        return CGSize(width: size.width + 20, height: 50)
    }
}

extension WeatherTypePicker: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedWeatherType != indexPath {
            selectedWeatherType = indexPath
            
            let selectedWeatherType = WeatherType.allCases[selectedWeatherType?.item ?? indexPath.item]
            weatherTypePickerDelegate?.didSelectWeatherType(selectedWeatherType)
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
