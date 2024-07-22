//
//  CloudsView.swift
//  VKWeatherApp
//
//  Created by nastasya on 19.07.2024.
//

import UIKit
import CoreImage

final class CloudsView: UIView {
    var isShown = false
    var cloudGroup: CloudGroup
    let topTint: UIColor
    let bottomTint: UIColor
    var resolvedImages: [UIImage] = []
    var cloudLayers: [CALayer] = []
    
    init(thickness: CloudViewModel.Thickness, topTint: UIColor, bottomTint: UIColor) {
        self.cloudGroup = CloudGroup(thickness: thickness)
        self.topTint = topTint
        self.bottomTint = bottomTint
        super.init(frame: .zero)
        self.backgroundColor = .clear
        preprocessImages()
        setupCloudLayers()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func preprocessImages() {
        resolvedImages = (0..<8).compactMap { i in
            guard let sourceImage = UIImage(named: "cloud\(i)") else { return nil }
            return tintedImage(sourceImage)
        }
    }

    
    func setupCloudLayers() {
        for _ in 0..<cloudGroup.clouds.count {
            let layer = CALayer()
            cloudLayers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        }, completion: { _ in
            self.isShown = true
            self.animateClouds()
        })
    }
    
    func animateClouds() {
        guard isShown else { return }
        
        cloudGroup.update(date: Date())
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for (index, cloud) in cloudGroup.clouds.enumerated() {
            let layer = cloudLayers[index]
            layer.opacity = Float(cloudGroup.opacity)
            layer.contents = resolvedImages[cloud.imageNumber].cgImage
            layer.frame = CGRect(
                x: cloud.position.x,
                y: cloud.position.y + 130,
                width: resolvedImages[cloud.imageNumber].size.width * cloud.scale,
                height: resolvedImages[cloud.imageNumber].size.height * cloud.scale
            )
        }
        
        CATransaction.commit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateClouds()
        }
    }
    
    func tintedImage(_ image: UIImage) -> UIImage? {
        let size = image.size
        let scale = image.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        image.draw(in: CGRect(origin: .zero, size: size))

        let colors = [topTint.cgColor, bottomTint.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0.0, 1.0])
        
        context.clip(to: CGRect(origin: .zero, size: size), mask: image.cgImage!)
        context.drawLinearGradient(gradient!,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: 0, y: size.height),
                                   options: [])
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return tintedImage
    }
}
