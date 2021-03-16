//
//  MySpotsViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 27/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit

class MySpotsViewController: UIViewController {
    lazy private var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        let spacing:CGFloat = 20.0
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(horizontalCollectionView)
        
    }
    
}
