//
//  ProfileViewControllerExtension.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 28/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        if(item.imageUrl != nil){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgcell", for: indexPath)
                as! RoundedImageCardView
            
            cell.imageCardView.imageView.sd_setImage(with: URL(string: item.imageUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            
           
            cell.imageCardView.usernameLabel.text = formatter.string(from: (item.timestamp?.dateValue())!)
            cell.imageCardView.contentLabel.text  = item.content
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                as! RoundedCardView
            
            cell.cardView.usernameLabel.text = formatter.string(from: (item.timestamp?.dateValue())!)
            cell.cardView.contentLabel.text  = item.content
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = data[indexPath.row]
        
        if(item.imageUrl != nil){
            return CGSize(width: view.frame.size.width-20, height: view.frame.size.width/2+30)
        }
        return CGSize(width: view.frame.size.width-20, height: view.frame.size.width/3)
    }
    
}



