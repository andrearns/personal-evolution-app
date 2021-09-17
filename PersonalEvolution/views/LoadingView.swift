//
//  LoadingView.swift
//  PersonalEvolution
//
//  Created by André Arns on 16/09/21.
//

import UIKit

class LoadingView: UIView {

    class func lockView() {
        DispatchQueue.main.async {
            let loadingView = LoadingView(frame: UIScreen.main.bounds)
            loadingView.backgroundColor = .white
            
            if let _lastWindow = UIApplication.shared.windows.last {
                if !_lastWindow.subviews.contains(where: { $0 is LoadingView }) {
                    _lastWindow.endEditing(true)
                    _lastWindow.addSubview(loadingView)
                }
            }
            
            loadingView.addFadeAnimationWithFadeType(.fadeIn)
            
            let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            indicator.center = loadingView.center
            indicator.tintColor = .black
            
            indicator.startAnimating()
            loadingView.addSubview(indicator)
        }
    }
    
    class func unlockView() {
        DispatchQueue.main.async {
            if let _lastWindow = UIApplication.shared.windows.last {
                for subview in _lastWindow.subviews {
                    if let loadingView = subview as? LoadingView {
                        loadingView.addFadeAnimationWithFadeType(.fadeOut)
                    }
                }
            }
        }
    }

}

enum FadeType {
    case fadeIn
    case fadeOut
}

extension UIView {
    func addFadeAnimationWithFadeType(_ fadeType: FadeType) {
        
        switch fadeType {
        case .fadeIn:
            DispatchQueue.main.async {
                self.alpha = 0.0
                UIView.animate(withDuration: 0.1) { () -> Void in
                    self.alpha = 1.0
                }
            }
            
        case .fadeOut:
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                DispatchQueue.main.async {
                    self.alpha = 0.0
                }
                
            }, completion: { (finished) -> Void in
                if finished {
                    self.removeFromSuperview()
                }
            })
        }
    }
}
