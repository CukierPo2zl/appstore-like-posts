//
//  TabNavigationMenu.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 06/01/2021.
//  Copyright © 2021 Adrian Oleszczak. All rights reserved.
//

import UIKit
class TabNavigationMenu: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    var menuItems: [TabItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
     convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        self.menuItems = menuItems
        self.layer.backgroundColor = UIColor.white.cgColor
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            self.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
        
    }
        // Create a custom nav menu item
        func createTabItem(item: TabItem) -> UIView {
            let tabBarItem = UIView(frame: CGRect.zero)
            let itemIconView = UIImageView(frame: CGRect.zero)

            
            itemIconView.image = item.icon["default"]!.withRenderingMode(.automatic)
            itemIconView.translatesAutoresizingMaskIntoConstraints = false
            itemIconView.clipsToBounds = true
            itemIconView.tintColor = .systemIndigo
            tabBarItem.layer.backgroundColor = UIColor.white.cgColor
            tabBarItem.addSubview(itemIconView)

            tabBarItem.translatesAutoresizingMaskIntoConstraints = false
            tabBarItem.clipsToBounds = true
            NSLayoutConstraint.activate([
                itemIconView.heightAnchor.constraint(equalToConstant: 25),
                itemIconView.widthAnchor.constraint(equalToConstant: 25),
                itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
                itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8),
                itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 35),
//
            ])
            tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
            return tabBarItem
        }
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        let itemToActivate:UIImageView = tabToActivate.subviews[0] as! UIImageView
        
        itemToActivate.image = menuItems[tab].icon["active"]!.withRenderingMode(.automatic)
        
        let borderWidth = tabToActivate.frame.size.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.systemIndigo.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 3)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let itemToInactivate:UIImageView = inactiveTab.subviews[0] as! UIImageView
               
        itemToInactivate.image = menuItems[tab].icon["default"]!.withRenderingMode(.automatic)
               
        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
}
