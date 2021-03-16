//
//  ViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 26/11/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, LoginButtonDelegate {
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var facebookLoginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate = self
        facebookLoginButton.permissions = ["public_profile", "email"]
        stackView.addArrangedSubview(facebookLoginButton)
        authUserAndTransition()
        
    }
    
    func setUpElements() {
        Utils.styleFilledButton(signUpButton)
        Utils.styleHollowButton(signInButton)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        createSpinnerView()
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
           
            let db = Firestore.firestore()
            db.collection("users").document(authResult!.user.uid).setData([
                "displayName": authResult!.user.displayName!,
                "email": authResult!.user.email!,
                "photoUrl": authResult!.user.photoURL?.absoluteString,

                ], merge: true)
            { (error) in
                if error != nil {
                    print("Server error")
                }
            }
            self.transitionToHome()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out")
    }
    func authUserAndTransition(){
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if (user != nil && AccessToken.current?.tokenString != nil){
                self.transitionToHome()
            } else {
                self.setUpElements()
            }
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func transitionToHome(){
        createSpinnerView()
        let homeViewController = storyboard?.instantiateViewController(
            identifier: Constants.Storyboard.homeViewController) as?
        HomeViewController
        UIApplication.shared.windows.first?.rootViewController = homeViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    
}

