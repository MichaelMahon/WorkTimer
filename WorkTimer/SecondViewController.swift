//
//  SecondViewController.swift
//  WorkTimer
//
//  Created by Michael Mahon on 2/22/18.
//  Copyright © 2018 Michael Mahon. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func swipedRight(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
}

