//
//  SignupSuccessVC.swift
//  Reiki
//
//  Created by NewAgeSMB on 30/08/22.
//

import UIKit

class SignupSuccessVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToHomeBtnClicked(_ sender: Any) {
        let VC = self.getHomePageVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func closeBtnClicked(_ sender: Any) {
        goToHomeBtnClicked(self)
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
