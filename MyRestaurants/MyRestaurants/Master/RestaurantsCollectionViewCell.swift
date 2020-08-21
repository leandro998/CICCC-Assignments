//
//  RestaurantsCollectionViewCell.swift
//  MyRestaurants
//
//  Created by Leandro Prado on 2020-08-19.
//  Copyright © 2020 Leandro Prado. All rights reserved.
//

import UIKit

class RestaurantsCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
       let iv = UIImageView()
       iv.translatesAutoresizingMaskIntoConstraints = false
       iv.contentMode = .scaleAspectFill
       iv.layer.masksToBounds = true
       return iv
     }()
     
     override init(frame: CGRect) {
       super.init(frame: frame)
       contentView.addSubview(imageView)
       imageView.matchParent()
     }
     
     required init?(coder: NSCoder) {
       fatalError()
     }
}
