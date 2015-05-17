//
//  ArticleMasterTableViewLoadingCell.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 3/21/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ArticleMasterTableViewLoadingCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
