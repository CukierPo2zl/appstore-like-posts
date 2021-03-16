//
//  Utils.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 28/11/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import Hero
import UIKit

class Utils {
    static func styleTextField(_ textField:UITextField){
        let bottomLine = CALayer();
        
        bottomLine.frame = CGRect(x:0, y: textField.frame.height-2, width: textField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.systemIndigo.cgColor
        
        textField.borderStyle = .none
        
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton){
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemIndigo.cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = .systemIndigo
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*>&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

func getRandomImageURL() -> URL {
    let rand = Int(arc4random_uniform(1000))
    return URL(string: "https://picsum.photos/200/300?image=\(rand)")!
}

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable var zPosition: CGFloat {
        get {
            return layer.zPosition
        }
        
        set {
            layer.zPosition = newValue
        }
    }
}



class TemplateImageView: UIImageView {
    @IBInspectable var templateImage: UIImage? {
        didSet {
            image = templateImage?.withRenderingMode(.alwaysTemplate)
        }
    }
}

extension UIViewController {
    
    func disableHero() {
        navigationController?.hero.isEnabled = false
    }
    
    func enableHero() {
        hero.isEnabled = true
        navigationController?.hero.isEnabled = true
    }
    
    func showHero(_ viewController: UIViewController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        viewController.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = navigationAnimationType
        navigationController?.pushViewController(viewController, animated: true)
    }
}




extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

import FirebaseAuth
import FBSDKLoginKit

func getCurrentUserProfilePictureURL()->URL{
    let user = Auth.auth().currentUser
    if let user = user{
        let accessToken = AccessToken.current!.tokenString
        return URL(string: user.photoURL!.absoluteString+"?access_token="+accessToken+"&width=300&height=300")!;
    }
    return URL(string: "")!
}
