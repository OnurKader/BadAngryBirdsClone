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
    
    var screen_size : CGRect!;
        
    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat)
    {
        let ball = UIImage(named: "ball.jpg");
        let ball_view = UIImageView(image: ball!);
        ball_view.frame = CGRect(x: x, y: y, width: 32, height: 32);
        view.addSubview(ball_view);

        gravity_behavior.addItem(ball_view);
        collision_behavior.addItem(ball_view);
        dynamic_item_behavior.addItem(ball_view);
        
        dynamic_item_behavior.addLinearVelocity(CGPoint(x: vx * 8.1, y: vy * 9.32 - 25), for: ball_view);
    }

    func updateBehaviors(){
        dynamic_item_behavior = UIDynamicItemBehavior(items: []);
        collision_behavior = UICollisionBehavior(items: []);
        collision_behavior.translatesReferenceBoundsIntoBoundary = false;
        gravity_behavior = UIGravityBehavior(items: []);
        
        // Add Custom Boundaries
        collision_behavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height));
        collision_behavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: 0));
        collision_behavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height));

        
        dynamic_animator.addBehavior(gravity_behavior);
        dynamic_animator.addBehavior(dynamic_item_behavior);
        dynamic_animator.addBehavior(collision_behavior);
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        screen_size = UIScreen.main.bounds;
        
        shooter.my_delegate = self;
        shooter.center.x = shooter.bounds.midX * 3;
        shooter.center.y = screen_size.height / 2;
        
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

