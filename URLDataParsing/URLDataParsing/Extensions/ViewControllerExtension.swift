//
//  ExtensionFiles.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.


fileprivate var aView: UIView?
import UIKit
extension UIViewController {
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
//        aView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0.8, alpha: 0.2)
        aView?.backgroundColor = .systemBlue
        let activityIndicator = UIActivityIndicatorView(style: .large)
        guard let newView = aView else { fatalError("View unable to unwrapped in extetion")}
        activityIndicator.center = newView.center
        activityIndicator.startAnimating()
        newView.addSubview(activityIndicator)
        self.view.addSubview(newView)
        
    }
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
