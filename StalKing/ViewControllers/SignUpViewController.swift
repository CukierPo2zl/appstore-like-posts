//
//  SignUpViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 26/11/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        // Styles
        Utils.styleTextField(firstNameTextField)
        Utils.styleTextField(lastNameTextField)
        Utils.styleTextField(emailTextField)
        Utils.styleTextField(passwordTextField)
        Utils.styleFilledButton(signUpButton)
    }

    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all fields"
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utils.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
            
        } else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.showError("Error while creating user")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "displayName": firstName+" "+lastName,
                        "email": email,
                        "uid": result!.user.uid
                    ]) { (error) in
                        if error != nil {
                            self.showError("Server error")
                        }
                    }
                    self.transitionToHome()
                }
            }
            
        }
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(
            identifier: Constants.Storyboard.homeViewController) as?
            HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
