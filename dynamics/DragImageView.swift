//
//  dragImageView.swift
//  dynamics
//
//  Created by ok19aad on 08/11/2019.
//  Copyright © 2019 ok19aad. All rights reserved.
//

import UIKit

class dragImageView: UIImageView {

   var startLocation: CGPoint?
      
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          startLocation = touches.first?.location(in: self)
      }
      
      
      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentLocation = touches.first?.location(in: self);
          
        let dx = currentLocation!.x - startLocation!.x;
        let dy = currentLocation!.y - startLocation!.y;
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy);

        let halfx = self.bounds.midX;
        newCenter.x = max(halfx, newCenter.x);
        newCenter.x = min(self.superview!.bounds.width * 0.185, newCenter.x);
          
        let halfy = self.bounds.midY;
        newCenter.y = max(self.superview!.bounds.height * 0.25 + halfy, newCenter.y);
        newCenter.y = min(self.superview!.bounds.height * 0.75 - halfy, newCenter.y);
          
        self.center = newCenter;
      }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.center = CGPoint(x: 108 + 32, y: self.superview!.bounds.height/2);
    }
}
