//
//  BadgeCell.swift
//  Reiki
//
//  Created by Newage on 03/07/24.
//

import UIKit

class BadgeCell: UITableViewCell {

    @IBOutlet weak var badgeTitleLbl: UILabel!
    @IBOutlet weak var badgeDescLbl: UILabel!
    @IBOutlet var mainView: UIView!
    
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
