//
//  ContentItemTableViewCell.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import UIKit

class ContentItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: ContentItem? {
        didSet {
            titleLabel.text = item?.title
        }
    }

}
