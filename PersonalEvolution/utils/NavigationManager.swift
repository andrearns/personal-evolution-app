//
//  NavigationManager.swift
//  PersonalEvolution
//
//  Created by André Arns on 18/09/21.
//

import Foundation
import UIKit

struct NavigationManager {
    
    enum InitialScreen {
        case onboarding
        case home
    }
    
    func show(initialScreen: InitialScreen, inController: UIViewController) {
        var viewController: UIViewController!
        
        switch initialScreen {
        case .home:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBar")
        case .onboarding:
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Onboarding")
        }
        
        if let sceneDelegate = inController.view.window?.windowScene?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = viewController
            UIView.transition(
                with: window,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
}
