import UIKit

protocol SubviewDelegate{
    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat);
}

class ViewController: UIViewController, SubviewDelegate {

    @IBOutlet weak var shooter: dragImageView!;
    @IBOutlet weak var score_label: UILabel!;
    @IBOutlet weak var time_label: UILabel!;
    
    var dynamic_animator: UIDynamicAnimator!;
    var dynamic_item_behavior: UIDynamicItemBehavior!;
    var gravity_behavior: UIGravityBehavior!;
    var collision_behavior: UICollisionBehavior!;

    var screen_size : CGRect!;

    var ball_array: [UIImageView]! = [];
    var bird_array: [UIImageView]! = [];

    var bird_slots: [CGFloat]! = [];
    var score: UInt16 = 0;
    var time_limit: UInt8 = 5;
    var time_over: Bool = false;
    
    let pass_score: UInt8 = 10;

    // TODO Get from screen size. Height / 78
    let total_bird_count = 5;

    func floatEqual(a: CGFloat, b: CGFloat) -> Bool
    {
        let epsilon: CGFloat = 0.02;
        return (abs(a-b) < epsilon);
    }
    
    func spawnBall(x: CGFloat, y: CGFloat, vx: CGFloat, vy: CGFloat)
    {
        if (!time_over)
        {
            let ball = UIImage(named: "cannonball.png");
            let ball_view = UIImageView(image: ball!);
            ball_view.frame = CGRect(x: x, y: y, width: 32, height: 32);
            view.addSubview(ball_view);
            ball_array.append(ball_view);

            gravity_behavior.addItem(ball_view);
            collision_behavior.addItem(ball_view);
            dynamic_item_behavior.addItem(ball_view);
            dynamic_item_behavior.addLinearVelocity(CGPoint(x: vx * 15.2 + 20, y: vy * 10 - 50), for: ball_view);
        }
    }

    func temp() -> Void {
        for (ball) in ball_array {
            for (bird) in bird_array {
                if ball.frame.intersects(bird.frame) {
                    for (slot) in bird_slots {
                        if(floatEqual(a: bird.frame.minY, b: slot)) {
                            // Move the image view so the ball doesn't hit the bird twice if the ball is moving slowly.
                            bird.frame = CGRect(x: -1337, y: -8008, width: 75, height: 65);
                            bird.removeFromSuperview();
                            // Find the index of the
                            indices.append(bird_slots.firstIndex(of: slot)!);
                            indices.shuffle();
                            score += 10;
                            // Not efficient but remove the bird from the array so it's references are lost. Let garbage collection take care of it.
                            if let idx = bird_array.firstIndex(of: bird) {
                                bird_array.remove(at: idx);
                            }
                            bird_count -= 1;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    func adjustBackground(filename: String){
        let bg_img = UIImage(named: filename);
        let bg_view = UIImageView(image: bg_img!);
        bg_view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        bg_view.contentMode = UIView.ContentMode.scaleAspectFill;
        self.view.addSubview(bg_view);
        self.view.sendSubviewToBack(bg_view);
    }

    func updateBehaviors(){
        dynamic_animator = UIDynamicAnimator(referenceView: self.view);
        dynamic_item_behavior = UIDynamicItemBehavior(items: []);
        collision_behavior = UICollisionBehavior(items: []);
        gravity_behavior = UIGravityBehavior(items: []);

        // Add Custom Boundaries
        collision_behavior.addBoundary(withIdentifier: "leftBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: UIScreen.main.bounds.height));
        collision_behavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: CGPoint(x: 0, y: 0), to: CGPoint(x: UIScreen.main.bounds.width, y: 0));
        collision_behavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: UIScreen.main.bounds.height), to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height));

        collision_behavior.action = temp;
        dynamic_item_behavior.friction = 0.01;
        
        dynamic_animator.addBehavior(gravity_behavior);
        dynamic_animator.addBehavior(dynamic_item_behavior);
        dynamic_animator.addBehavior(collision_behavior);
    }

    func removeBall(ball: UIImageView)
    {
        dynamic_item_behavior.removeItem(ball);
        gravity_behavior.removeItem(ball);
        collision_behavior.removeItem(ball);
        ball.removeFromSuperview();
        if let idx = ball_array.firstIndex(of: ball) {
           ball_array.remove(at: idx);
       }
    }

    @objc func ballEdge()
    {
        if(!time_over){
            for ball in ball_array
            {
                // If ball is out of view frame, erase it from the dynamicItemBeh and array.
                // But not delete the var itself, I don't know how, maybe the thing in the array is a pointer
                if ((ball.frame.minX > screen_size!.maxX) || (ball.frame.minY > screen_size!.maxY)) {
                    removeBall(ball: ball);
                }
            }
        }
    }

    func hideAllSubviews(){
        self.view.subviews.forEach { $0.isHidden = true }
    }
    
    func unhideAllSubviews(){
        self.view.subviews.forEach { $0.isHidden = true }
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
    var indices: [Int]! = Array(0...4).shuffled();
    @objc func spawnBirds()
    {
        if(!time_over)
        {
            if bird_count < total_bird_count {
                let bird = UIImage(named: "birb.png");
                let bird_view = UIImageView(image: bird);
                let last : Int = indices.removeLast();
                bird_view.frame = CGRect(x: screen_size.maxX * 0.9 - bird!.size.width, y: bird_slots![last], width: 75, height: 65);
                bird_count += 1;

                view.addSubview(bird_view);
                bird_array.append(bird_view);
            }
        }
    }

    func getRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0);
    }

    func go_menu()
    {
        let game_over = UILabel(frame: CGRect(x: 0, y: 0, width: 256, height: 36));
        game_over.center = CGPoint(x: screen_size.midX, y: screen_size.maxY * 0.2718281828);
        game_over.textAlignment = NSTextAlignment.center;
        game_over.text = "Game Over";
        game_over.textColor = UIColor.black;
        game_over.font = UIFont.boldSystemFont(ofSize: 42);
        let go_score = UILabel(frame: CGRect(x: 0, y: 0, width: 256, height: 24));
        go_score.center = CGPoint(x: screen_size.midX, y: screen_size.maxY * 0.2718281828 + 54);
        go_score.textAlignment = NSTextAlignment.center;
        go_score.text = "Your Score: " + String(score);
        go_score.textColor = getRGB(red: 18, green: 156, blue: 36);
        go_score.font = UIFont.boldSystemFont(ofSize: 25);
        hideAllSubviews();
        self.view.addSubview(game_over);
        self.view.addSubview(go_score);
    }

    func gameOver()
    {
        if(time_over && score >= pass_score)   // Winning State
        {
            go_menu();
        }
        else if(time_over)
        {
            go_menu();
        }
    }

    @objc func countdown()
    {
        if(time_limit > 0){
            time_limit -= 1;
            score_label.text = "Score: " + String(score);
            time_label.text = "Time Left: " + String(time_limit);
        }
        else
        {
            time_over = true;
            // Do Game Over screen and display score in a different way
            gameOver();
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        screen_size = UIScreen.main.bounds;

        shooter.my_delegate = self;
        shooter.center.x = shooter.bounds.midX * 3;
        shooter.center.y = screen_size.height / 2;

        adjustBackground(filename: "xp_background.png");
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue;
        UIDevice.current.setValue(value, forKey: "orientation");

        // Get the y positions of the birds
        initBirdPos();
        // Just Collision initialization
        updateBehaviors();


        // Schedule update() to be called every 2 seconds to not be intensive, could drop down to 20ms for 50 fps.
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ballEdge), userInfo: nil, repeats: true);

        // Bird Spawner
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(spawnBirds), userInfo: nil, repeats: true);
    
        // Countdown and Score
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true);

        
        // TODO Add a 20 second timer that stops the game and shows the end screen
    }

    override var shouldAutorotate: Bool {
        return true;
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft;
    }
}
