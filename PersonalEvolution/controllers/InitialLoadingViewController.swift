//
//  InitialLoadingViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 18/09/21.
//

import UIKit

class InitialLoadingViewController: UIViewController {

    private let navigationManager = NavigationManager()
    var username: String!
    var userImageData: Data!

    override func viewDidLoad() {
        super.viewDidLoad()

        username = UserSingleton.shared.fetchName() ?? nil
        userImageData = UserSingleton.shared.fetchUserImageData() ?? nil
        
        UserSingleton.shared.imageData = userImageData
        UserSingleton.shared.name = username
        
        print(UserSingleton.shared.name)
        print(UserSingleton.shared.imageData)
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
