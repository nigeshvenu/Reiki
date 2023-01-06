//
//  CardHistoryVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 15/12/22.
//

import UIKit

class CardHistoryVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var listEmptyLbl: UILabel!
    
    var viewModal = HomePageVM()
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    var pageLimit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCardsRequest()
    }

    func setCardImage(cardId:String,random:String)->UIImage{
        var image = UIImage()
        //let randomNumber = String(Int.random(in: 1..<3))
        let randomNumber = Int(random) ?? 1
        if cardId == "1"{
            image = UIImage(named: "ReikiParticle\(randomNumber)")!
        }else if cardId == "2"{
            image = UIImage(named: "SpiritAnimal\(randomNumber)")!
        }else if cardId == "3"{
            image = UIImage(named: "LoveEnergy\(randomNumber)")!
        }else if cardId == "4"{
            image = UIImage(named: "TheDivineFeminine\(randomNumber)")!
        }else if cardId == "5"{
            image = UIImage(named: "TranscendentalEnjoyer\(randomNumber)")!
        }else if cardId == "6"{
            image = UIImage(named: "BirdInstict\(randomNumber)")!
        }else if cardId == "7"{
            image = UIImage(named: "MountainBoost\(randomNumber)")!
        }else if cardId == "8"{
            image = UIImage(named: "Oneness\(randomNumber)")!
        }else if cardId == "9"{
            image = UIImage(named: "RareDiamond\(randomNumber)")!
        }
        return image
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

extension CardHistoryVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // MARK: - UICollectionViewDataSource protocol
        
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModal.cardHistoryArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let card = self.viewModal.cardHistoryArray[indexPath.row]
        if card.card != nil{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCoinCVC", for: indexPath as IndexPath) as! CardCoinCVC
            let coin = card.card!
            cell.cardImgView.image = setCardImage(cardId: coin.cardId, random: coin.random)
            cell.coinLbl.text = coin.goldCoins
            cell.cardTitleLbl.text = coin.name
            cell.cardSubtitleLbl.text = coin.occurance
            cell.createdDateLbl.text = card.createdDate
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardDateCVC", for: indexPath as IndexPath) as! CardDateCVC
            let dateCard = card.activity!
            cell.dateLbl.text = dateCard.eventdateAsDate.toString(dateFormat: "dd")
            cell.monthLbl.text = dateCard.eventdateAsDate.toString(dateFormat: "MMMM")
            cell.createdDateLbl.text = card.createdDate
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.0 - 15, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = self.viewModal.cardHistoryArray.count - 1
        if !isLoadingList && indexPath.row == lastElement {
            self.isLoadingList = true
            self.currentPage += 1
            self.getCardsRequest()
        }
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isTracking{
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
                let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                if (offsetY > contentHeight - scrollView.frame.height) && !isLoadingList {
                    self.isLoadingList = true
                    self.currentPage += 1
                    self.getCardsRequest()
                }
            }
        }
    }*/
}

extension CardHistoryVC{
    
    func getCardsRequest(){
        var offset = 0
        if currentPage != 1{
            offset = (currentPage * pageLimit) - pageLimit
        }
        let param = ["offset":offset,
                     "limit":pageLimit,
                     "where":["active":true,"user_id":Int(UserModal.sharedInstance.userId)!,"type":["$ne":"Purchase"]],
                     "sort":[["created_at","DESC"]]] as [String : Any]
        AppDelegate.shared.showLoading(isShow: true)
        viewModal.getUserAllCoins(urlParams: param, param: nil, onSuccess: { message in
            AppDelegate.shared.showLoading(isShow: false)
            if !self.viewModal.isPageEmptyReached{
                self.isLoadingList = false
            }
            self.collectionView.reloadData()
            self.listEmptyLbl.isHidden = self.viewModal.cardHistoryArray.count > 0
            self.collectionView.isHidden = self.viewModal.cardHistoryArray.count == 0
        }, onFailure: { error in
            AppDelegate.shared.showLoading(isShow: false)
            SwiftMessagesHelper.showSwiftMessage(title: "", body: error, type: .danger)
        })
    }
}
