//
//  RetrospectiveViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 14/09/21.
//

import UIKit

class RetrospectiveViewController: UIViewController {

    var retrospectiveType: RetrospectiveType!
    @IBOutlet var retrospectiveTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if retrospectiveType == .personal {
            retrospectiveTitleLabel.text = "Sua retrospectiva"
        } else if retrospectiveType == .group {
            retrospectiveTitleLabel.text = "Retrospectiva do grupo"
        }
    }
}
