//
//  InitialLoadingViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 18/09/21.
//

import UIKit
import CloudKit

class InitialLoadingViewController: UIViewController {

    private let navigationManager = NavigationManager()
    var username: String!
    var userImageData: Data!
    var userRecordID: CKRecord.ID?

    override func viewDidLoad() {
        super.viewDidLoad()

        username = UserSingleton.shared.fetchName()
        userImageData = UserSingleton.shared.fetchUserImageData()
        userRecordID = UserSingleton.shared.fetchUserRecordID() ?? nil
        
        UserSingleton.shared.imageData = userImageData
        UserSingleton.shared.name = username
        UserSingleton.shared.recordID = userRecordID
        
        print(UserSingleton.shared.name)
        print(UserSingleton.shared.imageData)
        print(UserSingleton.shared.recordID)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    
    private func showInitialScreen() {
        if username == "" && userImageData == nil {
            navigationManager.show(initialScreen: .onboarding, inController: self)
        } else {
            navigationManager.show(initialScreen: .home, inController: self)
        }
    }
}
