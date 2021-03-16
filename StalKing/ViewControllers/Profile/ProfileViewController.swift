//
//  ProfileViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 06/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    internal var data: [CardContent] = []
    
    private var collectionRef: CollectionReference!
    
    var userDataView = UIView()
    
    
    var db:DBHelper = DBHelper()
    
    lazy var userNameLabel: UILabel = {
        let field = UILabel()
        field.text = Auth.auth().currentUser?.displayName
        field.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return field
    }()
    
    lazy var spotsCountLabel: UILabel = {
        let field = UILabel()
        field.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return field
    }()
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView(image:#imageLiteral(resourceName: "sample"))
        image.sd_setImage(with: getCurrentUserProfilePictureURL(), placeholderImage: UIImage(named: "placeholder.png"))
        image.layer.borderWidth = 0.5
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        return image
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 20.0
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        collectionRef = Firestore.firestore().collection("spots")
        collectionRef.order(by: "timestamp")
        view.backgroundColor = .white
        
        userDataView.addSubview(profileImage)
        userDataView.addSubview(userNameLabel)
        userDataView.addSubview(spotsCountLabel)
        view.addSubview(userDataView)
        view.addSubview(collectionView)
        
        setUserDataViewConstraints()
        setSpotsCountLabelConstraints()
        setUserProfileImageConstraints()
        setUserNameLabelConstraints()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        profileImage.layer.cornerRadius = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // reload collection before every entry
        fetchMySpots()
    }
    
    func fetchMySpots() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        self.data = []
        collectionRef.whereField("owner.uid", isEqualTo: Auth.auth().currentUser?.uid)
            .getDocuments(completion: {(snapshot, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                    return
                } else {
                    
                    //   var index = 0
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        let content = documentData["content"] as! String
                        let imageUrl = documentData["image"]
                        let timestamp = documentData["timestamp"] as! Timestamp
                        
                        // Uncomment to use SQLite instead of stream
                        //                        let date = formatter.string(from:(timestamp.dateValue()))
                        //                        self.db.insert(id: index, content: content, imageURL: imageUrl as! String, timestamp: date)
                        //                        index+=1
                        self.data.append(CardContent(content: content, imageUrl: imageUrl as? String, timestamp: timestamp))
                    }
                    self.spotsCountLabel.text = "My spots: \(self.data.count)"
                    self.collectionView.reloadData()
                    
                }
            })
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(RoundedCardView.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(RoundedImageCardView.self, forCellWithReuseIdentifier: "imgcell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: spotsCountLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    func setUserDataViewConstraints() {
        userDataView.translatesAutoresizingMaskIntoConstraints = false
        userDataView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        userDataView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        userDataView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func setSpotsCountLabelConstraints() {
        spotsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        spotsCountLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
        spotsCountLabel.leadingAnchor.constraint(equalTo: userDataView.leadingAnchor, constant: 10).isActive = true
    }
    
    func setUserProfileImageConstraints() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: userDataView.topAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: userDataView.centerXAnchor).isActive = true
    }
    
    func setUserNameLabelConstraints() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: userDataView.centerXAnchor).isActive = true
    }
    
    
    
}


