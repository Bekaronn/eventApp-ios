//
//  ProfileViewController.swift
//  EventApp
//
//  Created by Bekarys on 09.05.2024.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    private var user: UserProfile = UserProfile(id: 0, username: "", email: "", first_name: "", last_name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        usernameTextField.text = user.username
        emailTextField.text = user.email
        firstnameTextField.text = user.first_name
        lastnameTextField.text = user.last_name
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstnameTextField {
            if let text = textField.text {
                user.first_name = text
                print(text + "text maken 1")
            }
        }
        if textField == lastnameTextField {
            if let text = textField.text {
                user.last_name = text
                print(text + "text maken 1")
            }
        }
        return true
    }
    
    func fetchUser() {
        UserAPIManager.shared.fetchUserProfile { result in
            switch result {
            case .success(let userProfile):
                self.user = userProfile
                DispatchQueue.main.async {
                    self.usernameTextField.text = self.user.username
                    self.emailTextField.text = self.user.email
                    self.firstnameTextField.text = self.user.first_name
                    self.lastnameTextField.text = self.user.last_name
                }
                print(self.user)
            case .failure(let error):
                print("Error fetching user profile: \(error)")
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserAPIManager.shared.setAuthenticated(false)
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
