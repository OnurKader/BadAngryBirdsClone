import UIKit

protocol SubviewDelegate{
    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat);
}

class ViewController: UIViewController, SubviewDelegate {
    
    @IBOutlet weak var shooter: dragImageView!;

    var dynamic_animator: UIDynamicAnimator!;
    var dynamic_item_behavior: UIDynamicItemBehavior!;
    var gravity_behavior: UIGravityBehavior!;
    var collision_behavior: UICollisionBehavior!;
    
    var ball_array: [UIImageView] = [];
    
    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat)
    {
        let ball = UIImage(named: "ball.jpg");
        let ball_view = UIImageView(image: ball!);
        ball_view.frame = CGRect(x: x, y: y, width: 32, height: 32);
        ball_array.append(ball_view);
        view.addSubview(ball_view);
        
        gravity_behavior.addItem(ball_view);
        collision_behavior.addItem(ball_view);
        dynamic_item_behavior.addItem(ball_view);
        
        dynamic_item_behavior.addLinearVelocity(CGPoint(x: vx * 8.1, y: vy * 9.32 - 25), for: ball_view);
    }

    func updateBehaviors(){
        dynamic_item_behavior = UIDynamicItemBehavior(items: ball_array);
        collision_behavior = UICollisionBehavior(items: ball_array);
        collision_behavior.translatesReferenceBoundsIntoBoundary = true;
        gravity_behavior = UIGravityBehavior(items: ball_array);
        dynamic_animator.addBehavior(gravity_behavior);
        dynamic_animator.addBehavior(dynamic_item_behavior);
        dynamic_animator.addBehavior(collision_behavior);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        
        shooter.my_delegate = self;
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue;
        UIDevice.current.setValue(value, forKey: "orientation");
        
        dynamic_animator = UIDynamicAnimator(referenceView: self.view);
        
        updateBehaviors();
    }

    override var shouldAutorotate: Bool {
        return true;
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft;
    }
}

