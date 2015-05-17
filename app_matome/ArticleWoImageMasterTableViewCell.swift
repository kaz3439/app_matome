//
//  ArticleWoImageMasterTableViewCell.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 1/25/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ArticleWoImageMasterTableViewCell: UITableViewCell {

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        self.frameView.layer.shadowOpacity = 0.1;
        self.frameView.layer.shadowRadius = 2.0;
        self.frameView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    }
}
