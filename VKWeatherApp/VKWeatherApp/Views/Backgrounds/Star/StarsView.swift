//
//  StarsView.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class StarsView: UIView {
    private var starField = StarField()
    private var meteorShower = MeteorShower()
    private var starLayers = [CALayer]()
    private var meteorLayers = [CALayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupStars()
        setupMeteors()
        startAnimation()
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
    
    private func setupMeteors() {
        while meteorLayers.count < meteorShower.meteors.count {
            let meteorLayer = CALayer()
            meteorLayer.backgroundColor = UIColor.white.cgColor
            meteorLayers.append(meteorLayer)
            self.layer.addSublayer(meteorLayer)
        }
    }
    
    private func addFlickerAnimation(to layer: CALayer) {
        let flickerAnimation = CABasicAnimation(keyPath: "opacity")
        flickerAnimation.fromValue = 0.5
        flickerAnimation.toValue = 1.0
        flickerAnimation.duration = Double.random(in: 1...2)
        flickerAnimation.autoreverses = true
        flickerAnimation.repeatCount = .infinity
        flickerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(flickerAnimation, forKey: "flickerAnimation")
    }
    
    private func startAnimation() {
        for (index, meteorLayer) in meteorLayers.enumerated() where index < meteorShower.meteors.count {
            animateMeteor(meteorLayer, meteor: meteorShower.meteors[index])
        }
    }
    
    private func animateMeteor(_ layer: CALayer, meteor: Meteor) {
        let path = UIBezierPath()
        let startX = meteor.isMovingRight ? CGFloat(meteor.x - meteor.length) : CGFloat(meteor.x)
        let endX = meteor.isMovingRight ? CGFloat(meteor.x) : CGFloat(meteor.x - meteor.length)
        let startY = CGFloat(meteor.y)
        let endY = CGFloat(meteor.y + meteor.length)

        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "meteorAnimation")

        layer.frame = CGRect(x: startX, y: startY, width: meteor.length, height: 2)
    }
}
