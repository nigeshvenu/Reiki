//
//  FavoritesTVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class FavoritesTVC: UITableViewCell {

    @IBOutlet var eventImageView: CustomImageView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var favoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
