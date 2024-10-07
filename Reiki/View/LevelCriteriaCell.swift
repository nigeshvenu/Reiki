//
//  LevelCriteriaCell.swift
//  Reiki
//
//  Created by Newage on 04/07/24.
//

import UIKit

class LevelCriteriaCell: UITableViewCell {

    @IBOutlet weak var levelTitleLbl: UILabel!
    @IBOutlet weak var levelShapeLbl: UILabel!
    @IBOutlet weak var levelImgView: UIImageView!
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
