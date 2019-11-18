//
//  menuController.swift
//  dynamics
//
//  Created by ok19aad on 18/11/2019.
//  Copyright © 2019 ok19aad. All rights reserved.
//

import UIKit

class menuController: UIViewController {

    @IBAction func play_game(_ sender: Any) {
        performSegue(withIdentifier: "playGame", sender: self);
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
