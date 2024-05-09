//
//  PreProfileViewController.swift
//  EventApp
//
//  Created by Bekarys on 09.05.2024.
//

import UIKit

class PreProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        isAuthenticated()
    }
    
    func isAuthenticated() {
        if UserAPIManager.shared.isAuthenticated() == true {
            print("yes")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
        } else {
            print("no")
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
