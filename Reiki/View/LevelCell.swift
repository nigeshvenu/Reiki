//
//  LevelCell.swift
//  Reiki
//
//  Created by NewAgeSMB on 17/11/22.
//

import UIKit

class LevelCell: UITableViewCell {

    @IBOutlet var sourceLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var pointLbl: UILabel!
    @IBOutlet var badgeLbl: UILabel!
    @IBOutlet weak var badgeCriteriaLbl: UILabel!
    
    
    
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
