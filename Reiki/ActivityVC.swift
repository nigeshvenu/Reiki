//
//  ActivityVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit

class ActivityVC: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSettings()
    }
    
    func initialSettings(){
        activityIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
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

