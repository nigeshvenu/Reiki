//
//  GoldCoinCell.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/10/22.
//

import UIKit

class GoldCoinCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var coinLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
