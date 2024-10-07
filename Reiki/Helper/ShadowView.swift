//
//  RoundShadowView.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 11/01/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    //private var shadowLayer: CAShapeLayer!
    //private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    let shadowLayer: CAShapeLayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 2
        return shadowLayer
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        shadowLayer.frame = bounds
        layer.insertSublayer(shadowLayer, at: 0)
        setPath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       shadowLayer.frame = bounds
       setPath()
    }
    
    func setPath(){
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }

}
