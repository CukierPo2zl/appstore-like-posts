 //
//  SignInViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 26/11/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import FirebaseAuth
 
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        // Styles
        Utils.styleTextField(emailTextField)
        Utils.styleTextField(passwordTextField)
        Utils.styleFilledButton(signInButton)
    }
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all fields"
        }
        return nil
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError(error!.localizedDescription)
                } else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(
            identifier: Constants.Storyboard.homeViewController) as?
            HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
