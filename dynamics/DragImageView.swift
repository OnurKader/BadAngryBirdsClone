//
//  dragImageView.swift
//  dynamics
//
//  Created by ok19aad on 08/11/2019.
//  Copyright © 2019 ok19aad. All rights reserved.
//

import UIKit

class dragImageView: UIImageView {

    var my_delegate: SubviewDelegate?;
    
    var startLocation: CGPoint?;
    var max_width: CGFloat?;
    var min_width: CGFloat?;
    var max_height: CGFloat?;
    var min_height: CGFloat?;

      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self);
        max_width = self.bounds.midX * 6;
        min_width = self.bounds.midX;
        max_height = self.superview!.bounds.height * 0.25 + self.bounds.midY;
        min_height = self.superview!.bounds.height * 0.75 - self.bounds.midY;
      }


      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self);
          
        let dx = currentLocation!.x - startLocation!.x;
        let dy = currentLocation!.y - startLocation!.y;
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy);

        newCenter.x = max(min_width!, newCenter.x);
        newCenter.x = min(max_width!, newCenter.x);
          
        newCenter.y = max(max_height!, newCenter.y);
        newCenter.y = min(min_height!, newCenter.y);
          
        self.center = newCenter;
      }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.my_delegate?.spawnBall(x: self.center.x, y: self.center.y, vx: (min_width! * 3 - self.center.x), vy: (self.superview!.bounds.height / 2 - self.center.y));
        self.center = CGPoint(x: min_width! * 3, y: self.superview!.bounds.height/2);
    }
}
