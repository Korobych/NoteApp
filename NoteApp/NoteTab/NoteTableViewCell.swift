//
//  NoteTableViewCell.swift
//  NoteApp
//
//  Created by Sergey Korobin on 20/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var colorView: UIView!{
        didSet{
            colorView.layer.borderColor = UIColor.gray.cgColor
            colorView.layer.borderWidth = 1.0
        }
    }
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
