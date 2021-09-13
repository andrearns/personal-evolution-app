//
//  CustomTextView.swift
//  PersonalEvolution
//
//  Created by André Arns on 11/09/21.
//

import UIKit

class CustomTextField: UITextField {
    
    struct Constants {
        static let sidePadding: CGFloat = 12
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y,
            width: bounds.size.width,
            height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
