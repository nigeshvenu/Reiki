//
//  ImageGradientView.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 18/02/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit

class HeaderGradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        self.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}
