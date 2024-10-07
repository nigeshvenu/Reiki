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
    @IBOutlet var shadowView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var favoriteBtn: UIButton!
    @IBOutlet var customLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCorner(numberOfRows:Int,indexPath:IndexPath){
        if numberOfRows == 1{
            mainView.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 16)
        }else if (indexPath.row == numberOfRows - 1) { // bottom cell
            mainView.setRoundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else if (indexPath.row == 0) { // top cell
            mainView.setRoundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 16)
        }else{
            mainView.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 0)
        }
    }
    
}
