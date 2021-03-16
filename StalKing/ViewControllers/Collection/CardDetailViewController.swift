//
//  CardDetailViewController.swift
//  StalKing
//
//  Created by Adrian Oleszczak on 24/12/2020.
//  Copyright © 2020 Adrian Oleszczak. All rights reserved.
//

import UIKit
import Hero


class CardViewController: UIViewController {
  let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  
    
  let contentCard = UIView()
  let commentsView = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    view.backgroundColor = .clear
    view.addSubview(visualEffectView)
        
    commentsView.numberOfLines = 0
    commentsView.text = "Comments"
    
    if #available(iOS 13.0, *) {
      contentCard.backgroundColor = .systemBackground
    } else {
      contentCard.backgroundColor = .white
    }

    contentCard.clipsToBounds = false
    
    contentCard.addSubview(commentsView)

    view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
  }
    
    
  @objc func handlePan(gr: UIPanGestureRecognizer) {
    let translation = gr.translation(in: view)
    switch gr.state {
    case .began:
      dismiss(animated: true, completion: nil)
    case .changed:
      Hero.shared.update(translation.y / view.bounds.height)
    default:
      let velocity = gr.velocity(in: view)
      if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
        Hero.shared.finish()
      } else {
        Hero.shared.cancel()
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let bounds = view.bounds
    visualEffectView.frame  = bounds
    contentCard.frame  = bounds
    
    commentsView.frame = CGRect(x: 20, y: bounds.width, width: bounds.width - 20, height: bounds.height - bounds.width - 20)
  }
}

class CardDetailViewController: CardViewController {
    let cardView = CardView()
    override func viewDidLoad() {
      super.viewDidLoad()
     
      cardView.contentLabel.numberOfLines = 0
      contentCard.addSubview(cardView)
        
      view.addSubview(contentCard)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = view.bounds
        cardView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: bounds.width-10, height: bounds.height/2 + 20)
    }
}

class ImageCardDetailViewController: CardViewController {
    let imageCardView = ImageCardView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageCardView.contentLabel.numberOfLines = 0
        contentCard.addSubview(imageCardView)
        
        view.addSubview(contentCard)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = view.bounds
        imageCardView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: bounds.width-20, height: bounds.height/2 + 20)
    }
}
