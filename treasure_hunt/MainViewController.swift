

import UIKit
import Canvas
class MainViewController: UIViewController {
    var soundManager = SoundManager()
    @IBOutlet var titleImage: UIImageView!
    
    @IBOutlet var animView: CSAnimationView!
    
   
    @IBAction func GoPressed(_ sender: Any) {
        animView.startCanvasAnimation()
    }
    
    @IBAction func StartBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "StartSegue", sender: sender)
    }
    //    override func viewDidAppear(_ animated: Bool) {
//        soundManager.playSound(.openmusic)
//
//    }
    @IBAction func UwindBack(_ sender: UIStoryboardSegue) {
    }
    override func viewDidAppear(_ animated: Bool) {
        titleImage.startRotating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


extension UIView {
    func startRotating(duration: Double = 4.0) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
