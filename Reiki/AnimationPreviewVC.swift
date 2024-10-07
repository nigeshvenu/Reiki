//
//  AnimationPreviewVC.swift
//  Reiki
//
//  Created by Newage on 05/04/24.
//

import UIKit
import Lottie

class AnimationPreviewVC: UIViewController {

    @IBOutlet weak var animationPlayView: UIView!
    
    var animationUrl : URL!
    private let animationView = AnimationView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addCloseBtnToNavigationItem()
        addAnimationView()
        loadAnimationFromUrl(url: animationUrl)
        
    }
    
    func addCloseBtnToNavigationItem(){
        // Create a UIButton with your image
        let imageButton = UIButton(type: .custom)
        imageButton.setImage(UIImage(named: "icon-close"), for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // Adjust the frame as needed

        // Add a target and action to the button if needed
        imageButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        // Create a UIBarButtonItem with the custom view (imageButton)
        let imageBarButtonItem = UIBarButtonItem(customView: imageButton)

        // Assign the image button bar button item to the right bar button item
        navigationItem.rightBarButtonItem = imageBarButtonItem
    }
    
    @objc func cancelButtonTapped() {
        // Implement the action when the cancel button is tapped
        // For example, you can dismiss the current view controller
        self.dismiss(animated: true, completion: nil)
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

extension AnimationPreviewVC{
    
    func addAnimationView(){
        self.animationPlayView.addSubview(animationView)
        animationView.isUserInteractionEnabled = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          animationView.topAnchor.constraint(equalTo: self.animationPlayView.topAnchor, constant: 0),
          animationView.leadingAnchor.constraint(equalTo: self.animationPlayView.leadingAnchor, constant: 0),
          animationView.bottomAnchor.constraint(equalTo: self.animationPlayView.bottomAnchor, constant: 0),
          animationView.trailingAnchor.constraint(equalTo: self.animationPlayView.trailingAnchor, constant: 0)
        ])
    }
    
    func loadAnimationFromUrl(url:URL){
        AppDelegate.shared.showLoading(isShow: true)
        Animation.loadedFrom(url: url, closure: { [weak self] animation in
            AppDelegate.shared.showLoading(isShow: false)
            guard let self = self else { return }
            
            if let animation = animation {
                self.animationView.animation = animation
                self.animationView.contentMode = .scaleAspectFit
                self.animationView.loopMode = .loop
                //Play Animation
                self.playAnimation(completion: { [weak self] in
                    print("Animation Completed Playing")
                })
            }
        }, animationCache: LRUAnimationCache.sharedCache)
    }
    
    func playAnimation(completion: (() -> Void)? = nil) {
        animationView.play { _ in
            completion?()
        }
    }
}
