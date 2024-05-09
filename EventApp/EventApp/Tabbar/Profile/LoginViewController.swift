//
//  LoginViewController.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    private var username: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        alertLabel.isHidden = true
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        isAuthenticated()
    }
    
    func isAuthenticated() {
        if UserAPIManager.shared.isAuthenticated() == true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToProfile", sender: self)
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print(username, password)
        alertLabel.isHidden = true
        UserAPIManager.shared.authenticateUser(username: username, password: password) { token, error in
            if let token = token {
                print("Successfully authenticated. JWT token: \(token)")
                self.login(withToken: token)
            } else if let error = error {
                print("Error during authentication: \(error)")
                DispatchQueue.main.async {
                    self.alertLabel.isHidden = false
                }
            }
        }
    }
    
    func login(withToken token: String) {
        UserAPIManager.shared.saveToken(token)
        UserAPIManager.shared.setAuthenticated(true)
    
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToProfile", sender: self)
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usernameTextField {
            if let text = usernameTextField.text as NSString? {
                let newText = text.replacingCharacters(in: range, with: string)
                username = newText
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
