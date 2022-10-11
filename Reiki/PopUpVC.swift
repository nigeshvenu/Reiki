//
//  PopUpVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 14/09/22.
//

import UIKit
import Lottie

class PopUpVC: UIViewController {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var yesBtn: UIButton!
    @IBOutlet var noBtn: UIButton!
    @IBOutlet var alertView: UIView!
    
    var titleString = ""
    var messageString = ""
    open var noBtnClick: (() -> Void)?
    open var yesBtnClick: (() -> Void)?
    private let animationView = AnimationView()
    private var loopMode = LottieLoopMode.playOnce
    private var fromProgress: AnimationProgressTime = 0
    private var toProgress: AnimationProgressTime = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        noBtn.layer.borderWidth = 1
        noBtn.layer.borderColor = UIColor.init(hexString: "#7F69A8").cgColor
        //titleLbl.text = titleString
        messageLbl.text = messageString
        addLoader()
        playLoaderAnimation()
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func noBtnClicked(_ sender: Any) {
        noBtnClick!()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func yesBtnClicked(_ sender: Any) {
        yesBtnClick!()
        self.dismiss(animated: false, completion: nil)
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

extension PopUpVC{
    
    func addLoader(){
        let animation = Animation.named("alert")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        alertView.addSubview(animationView)
        animationView.loopMode = loopMode
        animationView.isUserInteractionEnabled = false
        animationView.backgroundBehavior = .stop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          animationView.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 0),
          animationView.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: 0),
          animationView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor, constant: 0),
          animationView.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor, constant: 0)
        ])
    }
    
    func playLoaderAnimation(){
        animationView.play(fromProgress: fromProgress, toProgress: toProgress, loopMode: loopMode)
    }
}
