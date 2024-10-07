//
//  PurchaseHistoryCell.swift
//  Reiki
//
//  Created by NewAgeSMB on 22/11/22.
//

import UIKit

class PurchaseHistoryCell: UITableViewCell {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var viewContents: UIView!
    @IBOutlet var itemImage: CustomImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var coinLbl: UILabel!
    
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
    
    func setCorner(numberOfRows:Int,indexPath:IndexPath){
        if numberOfRows == 1{ //Single Cell
            viewContents.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 16)
        }else if (indexPath.row == numberOfRows - 1) { // bottom cell
            viewContents.setRoundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 16)
        }else if (indexPath.row == 0) { // top cell
            viewContents.setRoundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 16)
        }else{
            viewContents.setRoundCorners([.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 0)
        }
    }
}
