//
//  CustomImageView.swift
//  iAautoauction
//
//  Created by NewAgeSMB on 27/01/21.
//  Copyright © 2021 NewAgeSMB. All rights reserved.
//

import UIKit
import AlamofireImage

class CustomImageView: UIImageView {
    
    func ImageViewLoading(index:String = "",mediaUrl: String,placeHolderImage:UIImage?) {
        guard let url = URL(string: mediaUrl) else {
            self.image = placeHolderImage
            return
        }
        let activityIndicator = self.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
        
        self.af.setImage(
            withURL: url,
            placeholderImage: placeHolderImage,
            filter: nil,
            completion: { response in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
        )
    
    }

    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        self.addConstraints([centerX, centerY])
        return activityIndicator
    }

}
