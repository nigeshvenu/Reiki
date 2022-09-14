//
//  SideMenuVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 31/08/22.
//

import UIKit
import SwiftyAttributes
import SideMenu
protocol SideMenuDelegate {
    func selectedIndex(row:Int)
}

class SideMenuVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var userImageView: CustomImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userAddressLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var versionLbl: UILabel!
   
    var delegate : SideMenuDelegate?
    var optionsArray = [CharacterStruct]()
    var ParentNavigationController : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        mainView.roundCorners(cornerRadius: 20.0, cornerMask: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner])
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.init(hexString: "#FBEAEA").cgColor
        let user = UserModal.sharedInstance
        userImageView.ImageViewLoading(mediaUrl: UserModal.sharedInstance.image, placeHolderImage: UIImage(named: "no_image"))
        var address = [user.city,user.state]
        address = address.filter({!$0.isEmpty})
        userAddressLbl.text = address.joined(separator: ", ")
        userAddressLbl.isHidden = address.count == 0
        userNameLbl.attributedText = user.firstName.withFont(FontHelper.montserratFontSize(fontType: .semiBold, size: 20.0)) + " ".withFont(FontHelper.montserratFontSize(fontType: .Light, size: 18.0)) + user.lastName.withFont(FontHelper.montserratFontSize(fontType: .Light, size: 20.0))
        let home = CharacterStruct(name: "Home", image: "home", isSelected: false)
        let calendar = CharacterStruct(name: "Calendar", image: "calendar", isSelected: false)
        let cardFinder = CharacterStruct(name: "Card Finder", image: "cardfinder", isSelected: false)
        let unlockables = CharacterStruct(name: "Unlockables", image: "unlockables", isSelected: false)
        let favorites = CharacterStruct(name: "Favorites", image: "favorites", isSelected: false)
        let profile = CharacterStruct(name: "Profile", image: "profile", isSelected: false)
        let changePassword = CharacterStruct(name: "Change Password", image: "changepassword", isSelected: false)
        let changeMobile = CharacterStruct(name: "Change mobile number", image: "ChangeMobile", isSelected: false)
        let terms = CharacterStruct(name: "Terms & Conditions", image: "terms", isSelected: false)
        let privacy = CharacterStruct(name: "Privacy Policy", image: "privacy", isSelected: false)
        let deleteAccount = CharacterStruct(name: "Delete Account", image: "AccountDelete", isSelected: false)
        let logout = CharacterStruct(name: "Logout", image: "logout", isSelected: false)
        optionsArray.append(home)
        optionsArray.append(calendar)
        optionsArray.append(cardFinder)
        optionsArray.append(unlockables)
        optionsArray.append(favorites)
        optionsArray.append(profile)
        optionsArray.append(changePassword)
        optionsArray.append(changeMobile)
        optionsArray.append(terms)
        optionsArray.append(privacy)
        optionsArray.append(deleteAccount)
        optionsArray.append(logout)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
           self.versionLbl.text = "App Version " + version
       }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SideMenuVC : UITableViewDelegate,UITableViewDataSource{
    // number of rows in table view
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return optionsArray.count
      }
      
      // create a cell for each table view row
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          // create a new cell if needed or reuse an old one
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "OptionsTVC") as! OptionsTVC
          let option = optionsArray[indexPath.row]
          cell.optionImageView.image = UIImage(named: option.image)
          cell.optionNameLbl.text = option.name
          cell.arrowImg.isHidden = indexPath.row == optionsArray.count - 1
          return cell
      }
      
      // method to run when table view cell is tapped
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print("You tapped cell number \(indexPath.row).")
          if let menu = navigationController as? SideMenuNavigationController {
              guard let navController = ParentNavigationController else { return }
              if indexPath.row == 0{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      navController.viewControllers.append(self.getHomePageVC())
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 5{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      navController.viewControllers.append(self.getProfileVC())
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 6{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      navController.viewControllers.append(self.getChangePasswordVC())
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 7{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      navController.viewControllers.append(self.getChangeMobileNumberVC())
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 8{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      let VC = self.getWebViewVC()
                      VC.agreementHeaderTitle = "Terms & Conditions"
                      navController.viewControllers.append(VC)
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 9{
                  DispatchQueue.main.async {
                      _ = navController.viewControllers.popLast()
                      let VC = self.getWebViewVC()
                      VC.agreementHeaderTitle = "Privacy Policy"
                      navController.viewControllers.append(VC)
                      navController.setViewControllers(navController.viewControllers, animated: true)
                      menu.dismiss(animated: true, completion:nil)
                  }
              }else if indexPath.row == 10{
                  dismiss(animated: true, completion: {
                      self.delegate?.selectedIndex(row: indexPath.row)
                  })
              }else if indexPath.row == optionsArray.count - 1{
                  dismiss(animated: true, completion: {
                      self.delegate?.selectedIndex(row: indexPath.row)
                  })
              }else{
                  dismiss(animated: true, completion:nil)
              }
          }
         
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
}

