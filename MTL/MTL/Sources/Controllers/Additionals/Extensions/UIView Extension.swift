//
//  Array Extension.swift
//  MTL
//
//  Created by Bogdan Grozyan on 15.05.2021.
//

import UIKit

extension UIView {
//    func loadFromNib(nibName: String) -> UIView? {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
    
    func addBlurToView(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = self.bounds
        blurredView.alpha = 0.8
        blurredView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(blurredView)
    }
    
    func removeBlurFromView() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                guard let subview = subview as? UIVisualEffectView else {
                    return
                }
                if subview.effect is UIBlurEffect {
                    subview.removeFromSuperview()
                }
            }
        }
    }
}
