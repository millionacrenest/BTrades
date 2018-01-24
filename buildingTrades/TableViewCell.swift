//
//  TableViewCell.swift
//  buildingTrades
//
//  Created by Allison Mcentire on 8/26/17.
//  Copyright © 2017 Allison Mcentire. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var picture: UIImageView!
    

    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var textBodyView: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        captionLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
