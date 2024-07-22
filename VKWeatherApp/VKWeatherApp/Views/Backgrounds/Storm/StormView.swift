//
//  StormView.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class StormView: UIView {
    private var storm: StormViewModel
    private var animator: UIViewPropertyAnimator?
    private var isAnimating = false

    init(contents: StormViewModel.Contents, direction: CGFloat, strength: Int) {
        self.storm = StormViewModel(type: contents, direction: direction, strength: strength)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupAnimator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 10, curve: .linear) { [weak self] in
            self?.setNeedsDisplay()
        }
        animator?.addCompletion { [weak self] _ in
            self?.setupAnimator()
        }
        animator?.startAnimation()
        isAnimating = true
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        storm.update(date: Date(), size: self.bounds.size)

        for drop in storm.drops {
            let xPos = CGFloat(drop.x) * rect.width
            let yPos = CGFloat(drop.y) * rect.height

            context.saveGState()
            context.translateBy(x: xPos, y: yPos)
            context.rotate(by: CGFloat(drop.rotation))
            context.scaleBy(x: CGFloat(drop.xScale), y: CGFloat(drop.yScale))
            context.setAlpha(CGFloat(drop.opacity))
            
            if let cgImage = storm.image.cgImage {
                context.draw(cgImage, in: CGRect(origin: .zero, size: storm.image.size))
            } else {
                context.setFillColor(UIColor.red.cgColor) // Отладочный цвет
                context.fill(CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
            }
            
            context.restoreGState()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isAnimating {
            animator?.stopAnimation(true)
            setupAnimator()
        }
    }
}
