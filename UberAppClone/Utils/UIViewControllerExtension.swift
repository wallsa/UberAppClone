//
//  UIViewControllerExtension.swift
//  UberAppClone
//
//  Created by Wallace Santos on 04/12/22.
//

import Foundation
import UIKit

extension UIViewController{
    
    func presentAlertController(title:String, withMessage message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
        
    }
    func shouldPresentLoadingView(_ present:Bool, message:String? = nil){
        if present {
            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .black
            loadingView.alpha = 0
            loadingView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .large
            indicator.center = view.center
            indicator.tag = 2
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.7
            label.tag = 3
            
            self.view.addSubview(loadingView)
            loadingView.addSubview(indicator)
            loadingView.addSubview(label)
            
            label.centerX(inview: view)
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else {
            view.subviews.forEach { subview in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.3) {
                        subview.alpha = 0
                        
                    } completion: { _ in
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
}
