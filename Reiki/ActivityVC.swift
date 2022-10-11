//
//  ActivityVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit
import Lottie

class ActivityVC: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    private let animationView = AnimationView()
    private var loopMode = LottieLoopMode.loop
    private var fromProgress: AnimationProgressTime = 0
    private var toProgress: AnimationProgressTime = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        activityIndicatorView.backgroundColor = UIColor.init(hexString: "#B3000000")
        addLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        playLoaderAnimation()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    class func viewController() -> ActivityVC {
       return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activity") as! ActivityVC
    }

}

extension ActivityVC{
    
    func addLoader(){
        let animation = Animation.named("loader")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        animationView.loopMode = loopMode
        animationView.isUserInteractionEnabled = false
        animationView.backgroundBehavior = .stop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 140),
            animationView.widthAnchor.constraint(equalToConstant: 140)
           ])
    }
    
    func playLoaderAnimation(){
        animationView.play(fromProgress: fromProgress, toProgress: toProgress, loopMode: loopMode)
    }
}
