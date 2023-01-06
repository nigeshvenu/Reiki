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
    
    private let skeletonAnimationView = AnimationView()
    var level = ""
    
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
        lvlDescLbl.text = "You gave reached lvl \(level) now."
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
