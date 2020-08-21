//
//  RestaurantsViewController.swift
//  MyRestaurants
//
//  Created by Leandro Prado on 2020-08-19.
//  Copyright © 2020 Leandro Prado. All rights reserved.
//

import UIKit

class RestaurantsDetailViewController: UIViewController {
    
    var restaurants: Restaurants! {
        didSet {
            updateView()
        }
    }
    
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = .preferredFont(forTextStyle: .largeTitle)
        lb.textColor = .darkGray
        lb.adjustsFontForContentSizeCategory = true
        lb.setContentHuggingPriority(.required, for: .vertical)
        return lb
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        setupView()
    }
    
    private func setupView() {
        let vStack = VerticalStackView(arrangedSubviews: [
            nameLabel,
            imageView
        ], spacing: 16, alignment: .center, distribution: .fill)
        
        view.addSubview(vStack)
        vStack.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 32, left: 16, bottom: 16, right: 32))
    }
    
    private func updateView() {
        nameLabel.text = restaurants.name
        imageView.image = UIImage(named: restaurants.name)
        title = restaurants.category.rawValue
    }
}
