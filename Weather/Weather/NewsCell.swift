//
//  NewsCell.swift
//  Weather
//
//  Created by jimmy233 on 2018/1/2.
//  Copyright © 2018年 NJU. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Desc: UILabel!
    @IBOutlet weak var imageUrl: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
