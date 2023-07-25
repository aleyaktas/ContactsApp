//
//  UserInfoTableViewCell.swift
//  ContactsApp
//
//  Created by Aleyna Aktaş on 25.07.2023.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var celSubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
