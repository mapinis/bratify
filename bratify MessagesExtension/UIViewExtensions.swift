//
//  BorderExtension.swift
//  bratify MessagesExtension
//
//  Extends the UIView to have border settings
//  https://stackoverflow.com/a/45118493
//
//  And extends to be able to render as image
//  https://stackoverflow.com/a/41288197
//
//  Created by Mark Apinis on 7/24/24.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
}

extension UIView {
    
    // creates a UIImage out of this UIView
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
