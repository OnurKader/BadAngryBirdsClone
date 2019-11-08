import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ball: UIImageView!
    
    var dynamic_animator: UIDynamicAnimator!;
    var dynamic_item_behavior: UIDynamicItemBehavior!;
    var gravity_behavior: UIGravityBehavior!;
    var collision_behavior: UICollisionBehavior!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        dynamic_animator = UIDynamicAnimator(referenceView: self.view);
        gravity_behavior = UIGravityBehavior(items: [ball]);
        dynamic_item_behavior = UIDynamicItemBehavior(items: [ball]);
        collision_behavior = UICollisionBehavior(items: [ball]);
        
        dynamic_item_behavior.addLinearVelocity(CGPoint(x: 175, y: -470), for: ball)
        collision_behavior.translatesReferenceBoundsIntoBoundary = true;
        dynamic_animator.addBehavior(dynamic_item_behavior);
        dynamic_animator.addBehavior(collision_behavior);
        dynamic_animator.addBehavior(gravity_behavior);
    }


}

