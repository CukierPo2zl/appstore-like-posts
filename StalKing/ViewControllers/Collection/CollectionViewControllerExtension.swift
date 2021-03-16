//
//  CollectionViewControllerExtension.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 28/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HeaderViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.row]
        let cardHeroId = "card\(indexPath.row)"
        
        
        if(item.imageUrl != nil){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgcell", for: indexPath)
                as! RoundedImageCardView
            cell.imageCardView.imageView.sd_setImage(with: URL(string: item.imageUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            cell.imageCardView.usernameLabel.text = item.username
            cell.imageCardView.contentLabel.text  = item.content
            cell.imageCardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
            cell.imageCardView.hero.id = cardHeroId
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                as! RoundedCardView
            cell.cardView.usernameLabel.text = item.username
            cell.cardView.contentLabel.text  = item.content
            cell.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
            cell.cardView.hero.id = cardHeroId
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = data[indexPath.row]
        
        if(item.imageUrl != nil){
            return CGSize(width: view.frame.size.width-20, height: view.frame.size.width-50)
        }
        return CGSize(width: view.frame.size.width-20, height: view.frame.size.width/3+30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionView.indetifier, for: indexPath) as! HeaderCollectionView
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapped(cell:data[indexPath.row] , index: indexPath.row)
    }
    
}



