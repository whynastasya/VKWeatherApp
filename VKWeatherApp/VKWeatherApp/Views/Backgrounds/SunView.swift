//
//  SunView.swift
//  VKWeatherApp
//
//  Created by nastasya on 20.07.2024.
//

import UIKit

final class SunView: UIView {
    let progress: Double
    private var isShown = false
    
    private let haloLayer = CALayer()
    private let sunLayer = CALayer()
    private var flareLayers: [CALayer] = []

    init(progress: Double) {
        self.progress = progress
        super.init(frame: .zero)
        
        setupLayers()
        setupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShown {
            let sunX = (progress - 0.3) * 1.8
            let sunPositionX = (bounds.width - 75) * CGFloat(sunX)
            
            haloLayer.position = CGPoint(x: sunPositionX, y: 240)
            haloLayer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)

            sunLayer.position = CGPoint(x: sunPositionX, y: 240)
            sunLayer.bounds = CGRect(x: 0, y: 0, width: 250, height: 250)
            
            for (i, flareLayer) in flareLayers.enumerated() {
                flareLayer.position = CGPoint(x: sunPositionX, y: 200 + CGFloat(40 + (sin(Double(i) / 2) * 80)))
            }
        }
    }
    
    private func setupLayers() {
        haloLayer.contents = UIImage(named: "halo")?.cgImage
        haloLayer.contentsGravity = .resizeAspect
        haloLayer.opacity = Float(max(0, min(1, CGFloat(sin(progress * .pi) * 3 - 2))))
        haloLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        haloLayer.compositingFilter = "screenBlendMode"
        layer.addSublayer(haloLayer)
        
        sunLayer.contents = UIImage(named: "sun")?.cgImage
        sunLayer.contentsGravity = .resizeAspect
        sunLayer.opacity = 1.0
        sunLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
        sunLayer.compositingFilter = "screenBlendMode"
        layer.addSublayer(sunLayer)
        
        for i in 0..<3 {
            let flareLayer = CALayer()
            flareLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
            flareLayer.cornerRadius = CGFloat(8 + i * 5)
            flareLayer.frame = CGRect(x: 0, y: 0, width: 16 + CGFloat(i * 10), height: 16 + CGFloat(i * 10))
            flareLayer.opacity = Float(max(0, min(1, CGFloat(sin(progress * .pi) - 0.7))))
            flareLayer.transform = CATransform3DMakeTranslation(0, 40 + sin(Double(i) / 2) * 80, 0)
            flareLayers.append(flareLayer)
            layer.addSublayer(flareLayer)
        }
        
        self.isShown = true
        layoutSubviews()
    }
    
    private func setupAnimations() {
        let haloScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        haloScaleAnimation.toValue = 1.3
        haloScaleAnimation.duration = 7.0
        haloScaleAnimation.autoreverses = true
        haloScaleAnimation.repeatCount = .infinity
        haloScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        haloLayer.add(haloScaleAnimation, forKey: "haloScale")
        
        let sunRotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        sunRotationAnimation.toValue = CGFloat(20 * Double.pi / 180)
        sunRotationAnimation.duration = 8.0
        sunRotationAnimation.autoreverses = true
        sunRotationAnimation.repeatCount = .infinity
        sunRotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        sunLayer.add(sunRotationAnimation, forKey: "sunRotation")

        let flareMovementAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        flareMovementAnimation.toValue = -70
        flareMovementAnimation.duration = 30.0
        flareMovementAnimation.autoreverses = true
        flareMovementAnimation.repeatCount = .infinity
        flareMovementAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        for flareLayer in flareLayers {
            flareLayer.add(flareMovementAnimation, forKey: "flareMovement")
        }
    }
}
