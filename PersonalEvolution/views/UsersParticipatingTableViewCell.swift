//
//  UsersParticipatingTableViewCell.swift
//  PersonalEvolution
//
//  Created by André Arns on 15/09/21.
//

import UIKit

class UsersParticipatingTableViewCell: UITableViewCell {

    var user: User!
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(user: User) {
        self.user = user
        userImageView.image = UIImage(data: user.imageData!)
        usernameLabel.text = user.name
    }
}
