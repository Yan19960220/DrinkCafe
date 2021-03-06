//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by 张岩 on 2020/8/13.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class CafeTableViewCell: UITableViewCell {

    //MARK: properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
