//
//  songSummaryCell.swift
//  spotifyvip
//
//  Created by Douglas Poveda on 10/29/17.
//  Copyright © 2017 Sundevs. All rights reserved.
//

import UIKit

class SongSummaryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
