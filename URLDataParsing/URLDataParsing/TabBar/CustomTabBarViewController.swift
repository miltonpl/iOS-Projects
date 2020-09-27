//
//  CustomTabBarViewController.swift
//  URLDataParsing
//
//  Created by Milton Palaguachi on 9/22/20.
//  Copyright © 2020 Milton. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .yellow
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .black
        let vc5 = UIViewController()
        vc5.view.backgroundColor = .blue
        let vc6 = UIViewController()
        vc6.view.backgroundColor = .gray
        let vc7 = UIViewController()
        vc7.view.backgroundColor = .purple
        self.tabBar.items = []
        self.viewControllers = [vc1, vc2,vc3,vc4,vc5,vc6,vc7,]
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
