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
    
    var ball_array: [UIImageView]! = [];
    var bird_array: [UIImageView]! = [];

    var bird_slots: [CGFloat]! = [];

    let total_bird_count = 5;

    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat)
    {
        let ball = UIImage(named: "ball.jpg");
        let ball_view = UIImageView(image: ball!);
        ball_view.frame = CGRect(x: x, y: y, width: 32, height: 32);
        view.addSubview(ball_view);

        ball_array.append(ball_view);

        gravity_behavior.addItem(ball_view);
        collision_behavior.addItem(ball_view);
        dynamic_item_behavior.addItem(ball_view);
        dynamic_item_behavior.addLinearVelocity(CGPoint(x: vx * 15.2 + 20, y: vy * 10 - 50), for: ball_view);
    }

    func updateBehaviors(){
        dynamic_animator = UIDynamicAnimator(referenceView: self.view);
        dynamic_item_behavior = UIDynamicItemBehavior(items: []);
        collision_behavior = UICollisionBehavior(items: []);
        gravity_behavior = UIGravityBehavior(items: []);

        // Add Custom Boundaries
        collision_behavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height));
        collision_behavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: 0));
        // collision_behavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height));

        dynamic_animator.addBehavior(gravity_behavior);
        dynamic_animator.addBehavior(dynamic_item_behavior);
        dynamic_animator.addBehavior(collision_behavior);
    }

    @objc func ballEdge()
    {
        for ball in ball_array
        {
            // If ball is out of view frame, erase it from the dynamicItemBeh and array.
            // But not delete the var itself, I don't know how, maybe the thing in the array is a pointer
            if ((ball.frame.minX > screen_size!.maxX) || (ball.frame.minY > screen_size!.maxY)) {
                dynamic_item_behavior.removeItem(ball);
                if let idx = ball_array.firstIndex(of: ball) {
                    ball_array.remove(at: idx);
                }
            }
        }
    }

    func initBirdPos()
    {
        let height = screen_size.maxY;
        let start_y_off: CGFloat = height * 0.05;

        for i in 0...4 {
            // 65 === bird_image.height, +13 for the extra gap
            bird_slots.append(start_y_off + CGFloat(i * 78));
        }
    }

    // TODO Find a way to reset the arrays, to spawn new birds when one dies
    var bird_count = 0;
    var indices: [Int]! = [0, 1, 2, 3, 4].shuffled();
    @objc func spawnBirds()
    {
        if bird_count < total_bird_count {
            let bird = UIImage(named: "heron.png");
            let bird_view = UIImageView(image: bird);

            bird_view.frame = CGRect(x: screen_size.maxX * 0.9 - bird!.size.width, y: bird_slots![indices.removeLast()], width: 48, height: 65);
            bird_count += 1;

            view.addSubview(bird_view);
            bird_array.append(bird_view);
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        screen_size = UIScreen.main.bounds;

        shooter.my_delegate = self;
        shooter.center.x = shooter.bounds.midX * 3;
        shooter.center.y = screen_size.height / 2;

        let value = UIInterfaceOrientation.landscapeLeft.rawValue;
        UIDevice.current.setValue(value, forKey: "orientation");

        initBirdPos();
        updateBehaviors();

        // Schedule update() to be called every second to not be intensive, could drop down to 20ms for 50 fps.
        let ball_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ballEdge), userInfo: nil, repeats: true);

        // Bird Spawner
        let bird_timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(spawnBirds), userInfo: nil, repeats: true);
    }

    override var shouldAutorotate: Bool {
        return true;
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft;
    }
}
