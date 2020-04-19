//
//  TCell.swift
//  Score
//
//  Created by 949699582 on 2020/2/21.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

class TCell: UITableViewCell {

    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var scoreLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
