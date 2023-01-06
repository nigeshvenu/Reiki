//
//  UnlockHiddenChestVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 05/10/22.
//

import UIKit

class UnlockHiddenChestVC: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var goldLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subTitleLbl: UILabel!
    
    open var doneBtnClick: (() -> Void)?
    var card = CardModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
        setUI(random: card.random)
    }
    
    func setUI(random:String){
        //let randomNumber = String(Int.random(in: 1..<3))
        let randomNumber = Int(random) ?? 1
        if card.cardId == "1"{
            imageView.image = UIImage(named: "ReikiParticle\(randomNumber)")
        }else if card.cardId == "2"{
            imageView.image = UIImage(named: "SpiritAnimal\(randomNumber)")
        }else if card.cardId == "3"{
            imageView.image = UIImage(named: "LoveEnergy\(randomNumber)")
        }else if card.cardId == "4"{
            imageView.image = UIImage(named: "TheDivineFeminine\(randomNumber)")
        }else if card.cardId == "5"{
            imageView.image = UIImage(named: "TranscendentalEnjoyer\(randomNumber)")
        }else if card.cardId == "6"{
            imageView.image = UIImage(named: "BirdInstict\(randomNumber)")
        }else if card.cardId == "7"{
            imageView.image = UIImage(named: "MountainBoost\(randomNumber)")
        }else if card.cardId == "8"{
            imageView.image = UIImage(named: "Oneness\(randomNumber)")
        }else if card.cardId == "9"{
            imageView.image = UIImage(named: "RareDiamond\(randomNumber)")
        }
        goldLbl.text = card.goldCoins
        titleLbl.text = card.name
        subTitleLbl.text = card.occurance
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: false) {
            self.doneBtnClick!()
        }
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        self.dismiss(animated: false) {
            self.doneBtnClick!()
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
