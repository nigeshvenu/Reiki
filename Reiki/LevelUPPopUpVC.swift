//
//  LevelUPPopUpVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 12/12/22.
//

import UIKit
import Lottie

class LevelUPPopUpVC: UIViewController {
    
    @IBOutlet var lvlDecorView: UIView!
    @IBOutlet var lvlImageView: UIImageView!
    @IBOutlet var lvlLbl: UILabel!
    @IBOutlet var lvlDescLbl: UILabel!
    //@IBOutlet var prestigeImgView: UIImageView!
    
    //Prestige
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4View: UIView!
    @IBOutlet weak var star4CountLbl: UILabel!
    
    
    private let skeletonAnimationView = AnimationView()
    var level = ""
    var isprestige = false
    var prestigeRestartCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        addCongratsAnimation()
        skeletonAnimationView.play{ status in
            self.skeletonAnimationView.removeFromSuperview()
        }
        setUI()
    }
    
    func setUI(){
        lvlImageView.image = LevelImageHelper.getImage(leveNumber: level)
        lvlLbl.text = "LVL \(level)"
        lvlDescLbl.text = "You have reached lvl \(level) now."
        //prestigeImgView.isHidden = !isprestige
        
        //prestige
        if !isprestige{
            star1ImageView.isHidden = true
            star2ImageView.isHidden = true
            star3ImageView.isHidden = true
            star4View.isHidden = true
        }else{
            let prestigeTotalRestart = prestigeRestartCount
            star1ImageView.isHidden = prestigeTotalRestart == 0 || prestigeTotalRestart > 3
            star2ImageView.isHidden = prestigeTotalRestart < 2 || prestigeTotalRestart > 3
            star3ImageView.isHidden = prestigeTotalRestart < 3 || prestigeTotalRestart > 3
            star4View.isHidden = prestigeTotalRestart < 4
            star4CountLbl.text = String(prestigeTotalRestart)
        }
    }
    
    func addCongratsAnimation(){
        let animation = Animation.named("confetti_1")
        skeletonAnimationView.animation = animation
        skeletonAnimationView.contentMode = .scaleAspectFit
        lvlDecorView.addSubview(skeletonAnimationView)
        skeletonAnimationView.loopMode = .playOnce
        skeletonAnimationView.isUserInteractionEnabled = false
        skeletonAnimationView.backgroundBehavior = .stop
        skeletonAnimationView.translatesAutoresizingMaskIntoConstraints = false
        skeletonAnimationView.topAnchor.constraint(equalTo: lvlDecorView.topAnchor, constant: 0).isActive = true
        skeletonAnimationView.bottomAnchor.constraint(equalTo: lvlDecorView.bottomAnchor, constant: 0).isActive = true
        skeletonAnimationView.leftAnchor.constraint(equalTo: lvlDecorView.leftAnchor, constant: 0).isActive = true
        skeletonAnimationView.trailingAnchor.constraint(equalTo: lvlDecorView.trailingAnchor, constant: 0).isActive = true
    }
    
    @IBAction func doneBtnClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: Notification.Name("Notification"), object: nil)
        })
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
