//
//  ThemeVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 06/10/22.
//

import UIKit

class ThemeVC: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyLbl: UILabel!
    
    var viewModal = UnlockablesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setCalendarBackground(date: Date())
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getThemesRequest()
    }
    
    func setCalendarBackground(date:Date){
        switch date.kvkMonth{
        case 12,1,2:
            backgroundImageView.image = UIImage(named: "CalandarWinter")
        case 3,4,5:
            backgroundImageView.image = UIImage(named: "CalandarSpring")
        case 6,7,8:
            backgroundImageView.image = UIImage(named: "CalandarSummer")
        case 9,10,11:
            backgroundImageView.image = UIImage(named: "CalandarAutumn")
        default:
            break
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

extension ThemeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModal.themeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = self.viewModal.themeArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnlockableContentCVC", for: indexPath) as! UnlockableContentCVC
         cell.imageView.ImageViewLoading(mediaUrl: theme.image, placeHolderImage: nil)
         cell.coinLbl.text = theme.coin
         cell.leadingConst.constant = 0
         cell.trialConst.constant = 0
         cell.topConst.constant = 0
         cell.bottomConst.constant = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width / 2
        return CGSize(width:  cellWidth - 5, height: cellWidth + (cellWidth*0.30))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension ThemeVC{
    
    func getThemesRequest(){
        let param = ["offset":0,
                     "limit":-1,
                     "where":["active":true]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getThemes(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            self.collectionView.reloadData()
            self.collectionView.isHidden = self.viewModal.themeArray.count == 0
            self.emptyLbl.isHidden = self.viewModal.themeArray.count > 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
    
}
