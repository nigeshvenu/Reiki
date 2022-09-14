//
//  SignupCharacterVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 25/08/22.
//

import UIKit
struct CharacterStruct {
    var name = ""
    var image = ""
    var isSelected = false
}

class SignupCharacterVC: UIViewController {
    var characterArray = [CharacterStruct]()
    var selectedIndex : CharacterStruct?
    
    @IBOutlet var collectionView: UICollectionView!
    var firstName = ""
    var lastName = ""
    var email = ""
    var countryCode = ""
    var mobileNumber = ""
    var password = ""
    var aboutMe = ""
    var viewModal = SignupVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSettings(){
        let char1 = CharacterStruct(name: "Micheal", image: "Micheal",isSelected: true)
        selectedIndex = char1
        let char2 = CharacterStruct(name: "Thomas", image: "Thomas",isSelected: false)
        let char3 = CharacterStruct(name: "Jessie", image: "Jessie",isSelected: false)
        let char4 = CharacterStruct(name: "Linda", image: "Linda",isSelected: false)
        let char5 = CharacterStruct(name: "Ana", image: "Ana",isSelected: false)
        self.characterArray.append(char1)
        self.characterArray.append(char2)
        self.characterArray.append(char3)
        self.characterArray.append(char4)
        self.characterArray.append(char5)
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.signupRequest()
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

extension SignupCharacterVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
        // tell the collection view how many cells to make
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return characterArray.count
        }
    
        // make a cell for each cell index path
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCVC", for: indexPath as IndexPath) as! CharacterCVC
            let char = characterArray[indexPath.row]
            cell.characterImageView.image = UIImage(named: char.image)
            cell.characterNameLbl.text = char.name
            cell.checkBtn.backgroundColor = char.isSelected ? UIColor.init(hexString: "#6DA741") : UIColor.init(hexString: "#E2E2E2")
            return cell
        }
        
        // MARK: - UICollectionViewDelegate protocol
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // handle tap events
            //print("You selected cell #\(indexPath.item)!")
            for i in characterArray.indices{
                characterArray[i].isSelected = false
            }
            characterArray[indexPath.row].isSelected = true
            selectedIndex = characterArray[indexPath.row]
            collectionView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2.0, height: 250)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = collectionView.frame.size.width / 2.0
        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return section == 0 ? UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }*/
}

extension SignupCharacterVC{
    
    func signupRequest(){
         let sessionId = UserDefaults.standard.string(forKey: "sessionId") ?? ""
        let param = ["first_name":self.firstName,
                     "last_name":self.lastName,
        "email":email,
        "password":password,
                     "about_me":self.aboutMe,
                     "avatar":selectedIndex?.name ?? "",
        "session_id":sessionId] as [String : Any]
         AppDelegate.shared.showLoading(isShow: true)
        viewModal.signup(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            UserDefaults.standard.removeObject(forKey: "sessionId")
            SwiftMessagesHelper.showSwiftMessage(title: "", body: message, type: .success)
            let VC = self.getSignupSuccessVC()
            self.navigationController?.pushViewController(VC, animated: true)
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
