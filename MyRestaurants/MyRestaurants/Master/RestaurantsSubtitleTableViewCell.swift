//
//  RestaurantsSubtitleTableViewCell.swift
//  MyRestaurants
//
//  Created by Leandro Prado on 2020-08-19.
//  Copyright © 2020 Leandro Prado. All rights reserved.
//

import UIKit

class RestaurantsSubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
      textLabel?.textColor = .darkGray
      detailTextLabel?.textColor = .mainBlue
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

}
