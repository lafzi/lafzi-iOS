//
//  AyatTableViewCell.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 30/11/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class AyatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var noSuratAyat: UILabel!
    @IBOutlet weak var ayatArabic: UILabel!
    @IBOutlet weak var ayatIndonesia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
