//
//  CollectionReusableView.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 29/12/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderCollectionView: UICollectionReusableView {
    static let indetifier = "collectionHeader"
        
    var delegate: HeaderViewDelegate?
    
    var container = UIView()
    
    lazy var placeholder: UILabel = {
        let field = UILabel()
        field.text = "Say hello to your neightbours"
        field.textColor = .gray
        field.isUserInteractionEnabled = true
        return field
    }()
    
    lazy var profileImage:UIImageView = {
        let image = UIImageView(image:#imageLiteral(resourceName: "sample"))
        image.sd_setImage(with: getCurrentUserProfilePictureURL(), placeholderImage: UIImage(named: "placeholder.png"))
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        profileImage.contentMode = .scaleAspectFill
        addSubview(container)
   }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = CGRect(x: .zero, y: .zero, width: bounds.width - 20 , height: bounds.height-50)
        container.center = center
        container.clipsToBounds = true
        
        let imageWidth = container.bounds.width/4 - 45
        profileImage.frame = CGRect(x: .zero, y: .zero, width: imageWidth, height: container.bounds.height)
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        
        placeholder.frame = CGRect(x: imageWidth + 10, y: .zero, width: container.bounds.width - imageWidth, height: container.bounds.height)
        
        self.setupLabelTap()
        container.addSubview(profileImage)
        container.addSubview(placeholder)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let del = self.delegate {
            del.labelTapped()
        }
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.placeholder.addGestureRecognizer(labelTap)
    }
}
