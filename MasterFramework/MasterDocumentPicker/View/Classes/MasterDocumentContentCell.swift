//
//  DropBoxContentCell.swift
//  LawyerApp
//
//  Created by Adapting Social on 19/04/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

class MasterDocumentContentCell: UITableViewCell {

    
    @IBOutlet var dbContentImg: UIImageView!
    
    @IBOutlet var downloadProgress: UIProgressView!
    
    @IBOutlet var contentTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
