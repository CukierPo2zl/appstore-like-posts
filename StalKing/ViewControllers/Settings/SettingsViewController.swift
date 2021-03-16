//
//  SettingsViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 06/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    let items = ["logout"]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    lazy var tableView = UITableView()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        setupLabel()
        setupTableView()
    }
    
    func setupLabel(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
          
            let signOutAlert = UIAlertController(title: "sign out", message: "", preferredStyle: UIAlertController.Style.actionSheet)
            
            let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive, handler: {(action) in
                let firebaseAuth = Auth.auth()
                let loginManager = LoginManager()

                do {
                    try firebaseAuth.signOut()
                   
                        loginManager.logOut()
                
                    self.transitionToInitialView()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            signOutAlert.addAction(signOutAction)
            signOutAlert.addAction(cancelAction)
            self.present(signOutAlert, animated: true, completion: nil)
            
        }
    }
    func transitionToInitialView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: Constants.Storyboard.initialViewController) as! ViewController
        
        UIApplication.shared.windows.first?.rootViewController = newViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    
    
    
}


