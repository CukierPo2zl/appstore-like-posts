//
//  CollectionViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 23/12/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import Hero
import Firebase
import CoreLocation
import Alamofire
import SDWebImage


class CollectionViewController: UIViewController {
    private var locationManager = CLLocationManager()
    
    internal var data: [CardContent] = []
    
    private var spotIds: [NSDictionary] = []
    
    private var collectionRef: CollectionReference!
    
    private let refreshControl = UIRefreshControl()
    
    private var spotIdsResquest = DispatchGroup()
        
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 20.0
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        collectionRef = Firestore.firestore().collection("spots")
        collectionRef.limit(to: 20)
                
        fetchData()
        setupView()
        setupCollectionView()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
    
    func fetchData() {
        self.data = []
        self.collectionView.reloadData()
        
        // get document ids from pythonanywhere server
        getSpotsIds()
        
        spotIdsResquest.notify(queue: .main, execute: {
            for id in self.spotIds {
                let docRef = self.collectionRef.document(id["spotId"] as! String)
                self.loadDocument(docRef: docRef)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadDocument(docRef: DocumentReference){
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                let owner = documentData!["owner"] as! NSDictionary
                let username = owner["displayName"] as! String
                let content = documentData!["content"] as! String
                let imageUrl = documentData?["image"]
                
                if (imageUrl != nil){
                    let card = CardContent(username: username, content: content, imageUrl: imageUrl as? String)
                    self.data.append(card)
                }else{
                    self.data.append(CardContent(username: username, content: content))
                }
            } else {
                print("Document does not exist")
            }
            self.collectionView.reloadData()
        }
    }
    
    func getSpotsIds(){
        self.spotIdsResquest.enter()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            AF.request(Constants.API_URL+"elcity/?lat=\(currentLoc.coordinate.latitude)&lng=\(currentLoc.coordinate.longitude)").responseJSON { response in
                
                self.spotIds = response.value as! [NSDictionary]
                self.spotIdsResquest.leave()
            }
        }
        
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    func setupCollectionView() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(RoundedCardView.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(RoundedImageCardView.self, forCellWithReuseIdentifier: "imgcell")
        collectionView.register(
            HeaderCollectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionView.indetifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func cellTapped(cell: CardContent, index: Int) {
        // MARK: Hero configuration
        
        let cardHeroId = "card\(index)"
        
        if(cell.imageUrl != nil){
            let vc = ImageCardDetailViewController()
            
            vc.imageCardView.imageView.sd_setImage(with: URL(string: cell.imageUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            vc.modalPresentationStyle = .fullScreen
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .none
            vc.heroModalAnimationType = .none
            vc.imageCardView.hero.id = cardHeroId
            vc.imageCardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
            vc.imageCardView.usernameLabel.text = cell.username
            vc.imageCardView.contentLabel.text = cell.content
            vc.contentCard.hero.modifiers = [.source(heroID: cardHeroId), .spring(stiffness: 250, damping: 25)]
            vc.commentsView.hero.modifiers = [.useNoSnapshot, .forceAnimate, .spring(stiffness: 250, damping: 25)]
            vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
            
            present(vc, animated: true, completion: nil)
        } else {
            let vc = CardDetailViewController()
            
            vc.modalPresentationStyle = .fullScreen
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .none
            vc.heroModalAnimationType = .none
            vc.cardView.hero.id = cardHeroId
            vc.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
            vc.cardView.usernameLabel.text = cell.username
            vc.cardView.contentLabel.text = cell.content
            vc.contentCard.hero.modifiers = [.source(heroID: cardHeroId), .spring(stiffness: 250, damping: 25)]
            vc.commentsView.hero.modifiers = [.useNoSnapshot, .forceAnimate, .spring(stiffness: 250, damping: 25)]
            vc.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    func labelTapped() {
        let vc = AddNewViewController()
        present(vc, animated: true, completion: nil)
    }
    
}

