//
//  GradientProgressBar.swift
//  Reiki
//
//  Created by Newage on 09/08/24.
//

import UIKit

class GradientProgressBar: UIView {

    private let progressBar: UIProgressView
    private let gradientLayer: CAGradientLayer

    init(trackColor: UIColor = .lightGray, height: CGFloat = 10, cornerRadius: CGFloat = 5) {
        self.progressBar = UIProgressView(progressViewStyle: .default)
        self.gradientLayer = CAGradientLayer()
        super.init(frame: .zero)
        
        setupProgressBar(trackColor: trackColor, height: height, cornerRadius: cornerRadius)
        setupGradientLayer(cornerRadius: cornerRadius)
    }

    required init?(coder: NSCoder) {
        self.progressBar = UIProgressView(progressViewStyle: .default)
        self.gradientLayer = CAGradientLayer()
        super.init(coder: coder)
        
        setupProgressBar(trackColor: .lightGray, height: 10, cornerRadius: 5)
        setupGradientLayer(cornerRadius: 5)
    }

    private func setupProgressBar(trackColor: UIColor, height: CGFloat, cornerRadius: CGFloat) {
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .clear  // Make it clear to apply a gradient
        progressBar.trackTintColor = trackColor
        progressBar.layer.cornerRadius = cornerRadius
        progressBar.clipsToBounds = true

        self.addSubview(progressBar)
        
        // Add constraints to position the progress bar
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    private func setupGradientLayer(cornerRadius: CGFloat) {
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 222/255, blue: 80/255, alpha: 1).cgColor,
            UIColor(red: 244/255, green: 188/255, blue: 45/255, alpha: 1).cgColor,
            UIColor(red: 233/255, green: 152/255, blue: 8/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = cornerRadius
        
        progressBar.layer.addSublayer(gradientLayer)
        progressBar.layer.masksToBounds = true
    }

    func updateProgress(to value: Float, animated: Bool = true, duration: TimeInterval = 0.25) {
        progressBar.setProgress(value, animated: animated)
        
        let newFrame = CGRect(x: 0, y: 0, width: progressBar.bounds.width * CGFloat(value), height: progressBar.bounds.height)
        
        if animated {
            UIView.animate(withDuration: duration) {
                self.gradientLayer.frame = newFrame
            }
        } else {
            self.gradientLayer.frame = newFrame
        }
    }
}



