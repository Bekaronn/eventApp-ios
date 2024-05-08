//
//  ProfileViewController.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var username: String = ""
    private var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let user = User(username: username, password: password)
        print(username, password)
        UserAPIManager.shared.authenticateUser(user: user) { token, error in
            if let token = token {
                print("Successfully authenticated. JWT token: \(token)")
                self.login(withToken: token)
            } else if let error = error {
                print("Error during authentication: \(error)")
            }
        }
    }
    
    func login(withToken token: String) {
        UserAPIManager.shared.saveToken(token)
        UserAPIManager.shared.setAuthenticated(true)
    
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToNext", sender: self)
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
extension ProfileViewController: UITextFieldDelegate {
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
