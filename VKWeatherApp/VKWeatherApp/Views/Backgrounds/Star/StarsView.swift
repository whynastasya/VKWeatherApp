//
//  StarsView.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class StarsView: UIView {
    private var starField = StarField()
    private var starLayers = [CALayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStars() {
        for _ in 0..<100 {
            let star = starField.createStar(in: self.bounds.size)
            let starLayer = CALayer()
            starLayer.frame = CGRect(x: star.x, y: star.y, width: star.size, height: star.size)
            starLayer.backgroundColor = UIColor.white.cgColor
            starLayer.cornerRadius = star.size / 2
            starLayer.opacity = Float.random(in: 0.5...1)
            starLayers.append(starLayer)
            self.layer.addSublayer(starLayer)
            addFlickerAnimation(to: starLayer)
        }
    }
    
    private func addFlickerAnimation(to layer: CALayer) {
        let flickerAnimation = CABasicAnimation(keyPath: "opacity")
        flickerAnimation.fromValue = Double.random(in: 0.3...0.7)
        flickerAnimation.toValue = 1.0
        flickerAnimation.duration = Double.random(in: 0.5...1.5)
        flickerAnimation.autoreverses = true
        flickerAnimation.repeatCount = .infinity
        flickerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(flickerAnimation, forKey: "flickerAnimation")
    }
}
