//
//  RegisterViewController.swift
//  EventApp
//
//  Created by Bekarys on 09.05.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var username: String = ""
    private var email: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func registerButton(_ sender: Any) {
        print(username, email, password)
        UserAPIManager.shared.registerUser(username: username, email: email, password: password){
            success, message, error in
            if success {
                print(message ?? "")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            } else {
                print("Registration failed")
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
}
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            if let text = usernameTextField.text as NSString? {
                let newText = text.replacingCharacters(in: range, with: string)
                username = newText
            }
        } else if textField == emailTextField {
            if let text = emailTextField.text as NSString? {
                let newText = text.replacingCharacters(in: range, with: string)
                email = newText
            }
        } else if textField == passwordTextField {
            if let text = passwordTextField.text as NSString? {
                let newText = text.replacingCharacters(in: range, with: string)
                password = newText
            }
        }
        return true
    }
}
