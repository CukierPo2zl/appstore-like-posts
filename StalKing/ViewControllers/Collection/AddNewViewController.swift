//
//  AddNewViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 30/12/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import CoreLocation
import Alamofire

class AddNewViewController: UIViewController {
    
    var placeholder = "Placeholder..."
    var header = UIView()
    
    lazy var submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new spot"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    lazy var userNameLabel: UILabel = {
        let field = UILabel()
        field.text = Auth.auth().currentUser?.displayName
        field.isUserInteractionEnabled = true
        field.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return field
    }()
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView(image:#imageLiteral(resourceName: "sample"))
        image.sd_setImage(with: getCurrentUserProfilePictureURL(), placeholderImage: UIImage(named: "placeholder.png"))
        image.layer.borderWidth = 0.5
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.gray.cgColor
        image.clipsToBounds = true
        return image
    }()
    
    var placeholderLabel = UILabel()
    var inputField = UITextView()
    
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 20.0
        return sv
    }()
    
    var userInfoView = UIView()
    
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        header.addSubview(titleLabel)
        header.addSubview(submitButton)
        
        userInfoView.addSubview(profileImage)
        userInfoView.addSubview(userNameLabel)
        
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(userInfoView)
        
        setupTextView()
        stackView.addArrangedSubview(inputField)
        
        view.addSubview(stackView)
        
        setStackViewConstraints()
        setTitleLabelConstraints()
        setSubmitButtonConstraints()
        setHeaderConstraints()
        setUserInfoViewConstraints()
        setUserProfileImageConstraints()
        setUserNameLabelConstraints()
        setInputFieldConstraints()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        titleLabel.font = titleLabel.font.withSize(28.0)
    }
    
    override func viewWillLayoutSubviews() {
        profileImage.layer.cornerRadius = 20
    }
    
    var locationManager = CLLocationManager()
    
    @objc func onSubmit(sender : UIButton){
        let group = DispatchGroup()
        
        var currentLoc: CLLocation!
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
        }
        
        if(currentLoc != nil){
            if(!inputField.text.isEmpty && inputField.text != placeholder) {
                let db = Firestore.firestore()
//                group.enter()
                let resp = db.collection("spots").addDocument(data: [
                    "timestamp": FieldValue.serverTimestamp(),
                    "content": inputField.text!,
                    "owner": [
                        "displayName": Auth.auth().currentUser?.displayName,
                        "uid": Auth.auth().currentUser?.uid
                    ]
                ])
//                group.leave()
                
                
//                group.notify(queue: .main, execute: {
                    self.sendSpotConnetctor(documentID: resp.documentID, position: currentLoc)
//                })
                inputField.text = nil
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    func sendSpotConnetctor(documentID: String, position: CLLocation){
        let body:[String: Any] = [
            "spotId": documentID,
            "position": "POINT(\(position.coordinate.longitude) \(position.coordinate.latitude))"
        ]
        AF.request(Constants.API_URL+"elcity/", method: .post, parameters: body).response{response in
            print(response)
        }
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    func setUserInfoViewConstraints() {
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        userInfoView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        userInfoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setUserProfileImageConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setUserNameLabelConstraints(){
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor).isActive = true
    }
    
    func setInputFieldConstraints(){
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        inputField.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10).isActive = true
        inputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func setHeaderConstraints(){
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        header.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    func setTitleLabelConstraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
    
    func setSubmitButtonConstraints(){
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
}

extension AddNewViewController: UITextViewDelegate {
    
    func setupTextView(){
        inputField.delegate = self
        inputField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        inputField.text = placeholder
        inputField.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}
