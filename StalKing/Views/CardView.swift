//
//  CardView.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 23/12/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import Hero



class CardView: UIView {
    let usernameLabel = UILabel()
    let contentLabel = UILabel()
    
    var usernameLabelTopConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentLabel.numberOfLines = 3

        usernameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentLabel.font = UIFont.systemFont(ofSize: 16)

        addSubview(usernameLabel)
        addSubview(contentLabel)
        
        setUsernameLabelConstraints()
        setContentLabelConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setUsernameLabelConstraints() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        usernameLabelTopConstraint = usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        usernameLabelTopConstraint.isActive = true
    }
    
    func setContentLabelConstraints() {
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}

class ImageCardView: CardView {
    let imageContainer = UIView()
    var imageView = UIImageView(image: nil)
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        usernameLabelTopConstraint.isActive = false
        imageView.contentMode = .scaleAspectFill
        contentLabel.numberOfLines = 4

        imageView.layer.cornerRadius = 25.0
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        
        imageContainer.addSubview(imageView)
        addSubview(imageContainer)
        
        setImageContainerConstraints()
        setImageViewConstraints()
        setNewUsernameLabelConstraints()
    }

    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor).isActive = true
    }
    
    func setImageContainerConstraints() {
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.40).isActive = true
        imageContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
     func setNewUsernameLabelConstraints() {
        usernameLabelTopConstraint = usernameLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 20)
        usernameLabelTopConstraint.isActive = true
    }
    
    
}
