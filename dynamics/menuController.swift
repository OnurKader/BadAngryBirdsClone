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
    
    func assignBackground(){
        let background = UIImage(named: "cat-bg.jpg");

        var imageView : UIImageView!;
        imageView = UIImageView(frame: view.bounds);
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill;
        imageView.clipsToBounds = true;
        imageView.image = background;
        imageView.center = view.center;
        view.addSubview(imageView);
        self.view.sendSubviewToBack(imageView);
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground();

        // Do any additional setup after loading the view.
    }
    

}
