//
//  RainView.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class RainView: UIView {
    private var stormView: StormView
    private var animator: UIViewPropertyAnimator?
    private var animating = false

    init(stormType: StormViewModel.Contents = .rain, direction: CGFloat = 0, strength: Int) {
        self.stormView = StormView(contents: stormType, direction: direction, strength: strength)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupStormView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStormView() {
        addSubview(stormView)
        stormView.frame = self.bounds
    }
    
    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 10, curve: .linear) { [weak self] in
            self?.setNeedsDisplay()
        }
        animator?.addCompletion { [weak self] _ in
            self?.setupAnimator()
        }
        animator?.startAnimation()
        animating = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if animating {
            animator?.stopAnimation(true)
            setupAnimator()
        }
        stormView.frame = self.bounds
    }
}
