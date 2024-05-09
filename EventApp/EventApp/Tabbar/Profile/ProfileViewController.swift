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
        fetchUser()
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        usernameTextField.text = user.username
        emailTextField.text = user.email
        firstnameTextField.text = user.first_name
        lastnameTextField.text = user.last_name
        
        usernameTextField.isEnabled = false
        usernameTextField.textColor = .gray
        emailTextField.isEnabled = false
        emailTextField.textColor = .gray
 
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
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
        UserAPIManager.shared.updateUser(firstName: self.firstnameTextField.text ?? "", lastName: self.lastnameTextField.text ?? "") { success, error in
            if success {
                print("User updated successfully")
            } else {
                if let error = error {
                    print("Error updating user: \(error)")
                } else {
                    print("Error updating user")
                }
            }
        }

    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UserAPIManager.shared.setAuthenticated(false)
        UserAPIManager.shared.saveToken("")
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
