//
//  NewBadgePopUpVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 13/12/22.
//

import UIKit
import Lottie

class NewBadgePopUpVC: UIViewController {
    
    @IBOutlet var badgeDecorView: UIView!
    @IBOutlet var badgeNoLbl: UILabel!
    @IBOutlet var badgeDescLbl: UILabel!
    
    var badge = ""
    private let skeletonAnimationView = AnimationView()

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
        badgeNoLbl.text = "\(badge)"
        badgeDescLbl.text = getBadeDesc()
    }
    
    func addCongratsAnimation(){
        let animation = Animation.named("confetti_1")
        skeletonAnimationView.animation = animation
        skeletonAnimationView.contentMode = .scaleAspectFit
        badgeDecorView.addSubview(skeletonAnimationView)
        skeletonAnimationView.loopMode = .playOnce
        skeletonAnimationView.isUserInteractionEnabled = false
        skeletonAnimationView.backgroundBehavior = .stop
        skeletonAnimationView.translatesAutoresizingMaskIntoConstraints = false
        skeletonAnimationView.topAnchor.constraint(equalTo: badgeDecorView.topAnchor, constant: 0).isActive = true
        skeletonAnimationView.bottomAnchor.constraint(equalTo: badgeDecorView.bottomAnchor, constant: 0).isActive = true
        skeletonAnimationView.leftAnchor.constraint(equalTo: badgeDecorView.leftAnchor, constant: 0).isActive = true
        skeletonAnimationView.trailingAnchor.constraint(equalTo: badgeDecorView.trailingAnchor, constant: 0).isActive = true
    }
    
    /*func getBadeDesc()->String{
        if self.badge == "Badge 1"{
           return "You have gained badge 1 for completing 1 week of non consecutive calendar days."
        }else if self.badge == "Badge 2"{
            return "You have gained badge 2 for completing 2 weeks of non consecutive calendar days."
        }else if self.badge == "Badge 3"{
            return "You have gained badge 3 for completing 3 weeks of non consecutive calendar days."
        }else if self.badge == "Badge 4"{
            return "You have gained badge 4 for completing 1 month of non consecutive calendar days."
        }else if self.badge == "Badge 5"{
            return "You have gained badge 5 for completing 1 week of consecutive calendar days."
        }else if self.badge == "Badge 6"{
            return "You have gained badge 6 for completing 2 weeks of consecutive calendar days."
        }else {
            return "You have gained badge 7 for completing 3 weeks of consecutive calendar days."
        }
    }*/
    
    func getBadeDesc()->String{
        if self.badge == "Badge 1"{
           return "7 days completed (500 xp)"
        }else if self.badge == "Badge 2"{
            return "14 days completed (500xp)"
        }else if self.badge == "Badge 3"{
            return "21 days completed (500xp)"
        }else if self.badge == "Badge 4"{
            return "30 days completed (1000xp)"
        }else if self.badge == "Badge 5"{
            return "7 consecutive days (1000xp)"
        }else if self.badge == "Badge 6"{
            return "14 consecutive days (2000 xp)"
        }else if self.badge == "Badge 7"{
            return "21 consecutive days(3000 xp)"
        }else if self.badge == "Badge 8" {
            return "30 consecutive days (5000 xp)"
        }
        return ""
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
