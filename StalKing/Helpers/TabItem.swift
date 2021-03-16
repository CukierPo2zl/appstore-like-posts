//
//  TabItem.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 06/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit
enum TabItem: String, CaseIterable {
    case home = "home"
    case messages = "messages"
    case profile = "profile"
    case settings = "settings"
    

var viewController: UIViewController {
    switch self {
        case .home:
            return CollectionViewController()
        case .messages:
            return ProfileViewController()
        case .profile:
            return ProfileViewController()
        case .settings:
            return SettingsViewController()
        }
    }

    var icon: [String: UIImage] {
        switch self {
        case .home:
            let icons = [
                "active": UIImage(systemName: "house.fill")!,
                "default": UIImage(systemName: "house")!
            ]
            return icons
            
        case .messages:
            let icons = [
                "active": UIImage(systemName: "bubble.right.fill")!,
                "default": UIImage(systemName: "bubble.right")!
            ]
            return icons
            
        case .profile:
            let icons = [
                "active": UIImage(systemName: "person.fill")!,
                "default": UIImage(systemName: "person")!
            ]
            return icons
            
        case .settings:
            let icons = [
                "active": UIImage(systemName: "line.horizontal.3")!,
                "default": UIImage(systemName: "line.horizontal.3")!
            ]
            return icons
        }
    }
    
    
var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
