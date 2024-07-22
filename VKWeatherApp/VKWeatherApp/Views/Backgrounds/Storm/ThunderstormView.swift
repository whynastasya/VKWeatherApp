//
//  ThunderstormView.swift
//  VKWeatherApp
//
//  Created by nastasya on 22.07.2024.
//

import UIKit

final class ThunderstormView: UIView {
    private var stormView: StormView
    private var cloudsView: CloudsView
    private var lightningImageView = UIImageView()
    private var animator: UIViewPropertyAnimator?
    private var animating = false

    init(stormType: StormViewModel.Contents, direction: CGFloat = 0, strength: Int, cloudThickness: CloudViewModel.Thickness, topTint: UIColor, bottomTint: UIColor) {
        self.stormView = StormView(contents: stormType, direction: direction, strength: strength)
        self.cloudsView = CloudsView(thickness: cloudThickness, topTint: topTint, bottomTint: bottomTint)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupCloudsView()
        setupStormView()
        setupLightningImageView()
        setupAnimator()
        animateLightning()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCloudsView() {
        addSubview(cloudsView)
        cloudsView.frame = self.bounds
    }

    private func setupStormView() {
        addSubview(stormView)
        stormView.frame = self.bounds
    }

    private func setupLightningImageView() {
        lightningImageView = UIImageView(image: UIImage(named: "lightning1"))
        lightningImageView.contentMode = .scaleAspectFit
        lightningImageView.frame = self.bounds
        lightningImageView.alpha = 0
        self.insertSubview(lightningImageView, belowSubview: cloudsView)
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

    private func animateLightning() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.2, animations: {
                self.lightningImageView.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
                    self.lightningImageView.alpha = 0
                })
            })
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if animating {
            animator?.stopAnimation(true)
            setupAnimator()
        }
        cloudsView.frame = self.bounds
        stormView.frame = self.bounds
        lightningImageView.frame = self.bounds
    }
}
