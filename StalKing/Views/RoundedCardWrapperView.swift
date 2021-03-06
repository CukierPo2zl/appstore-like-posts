//
//  RoundedCardWrapperView.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 27/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit
import Hero

class RoundedCardWrapperCell: UICollectionViewCell {
    
    var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.transform = transform
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}

class RoundedCardView: RoundedCardWrapperCell {
    let cardView = CardView()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        addSubview(cardView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
            cardView.frame = bounds
        }
    }
}

class RoundedImageCardView: RoundedCardWrapperCell {
    let imageCardView = ImageCardView()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageCardView.backgroundColor = .white
        imageCardView.layer.cornerRadius = 16
        addSubview(imageCardView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageCardView.superview == self {
            imageCardView.frame = bounds
        }
    }
}

