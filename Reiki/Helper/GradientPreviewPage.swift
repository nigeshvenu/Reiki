//
//  GradientPreviewPage.swift
//  Reiki
//
//  Created by Newage on 16/04/24.
//

import UIKit

class GradientPreviewPage: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor(red: 246/255, green: 242/255, blue: 243/255, alpha: 1.0).cgColor,
                                UIColor(red: 228/255, green: 65/255, blue: 152/255, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
