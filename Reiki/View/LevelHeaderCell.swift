//
//  LevelHeaderCell.swift
//  Reiki
//
//  Created by NewAgeSMB on 17/11/22.
//

import UIKit

class LevelHeaderCell: UITableViewCell {
    
    @IBOutlet var headerMainView: UIView!
    @IBOutlet var levelLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var levelImage: UIImageView!
    @IBOutlet var nextLvlLbl: UILabel!
    @IBOutlet var requiredPointsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
