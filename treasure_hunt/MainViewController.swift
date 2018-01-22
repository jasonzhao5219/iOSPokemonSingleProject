//
//  MainViewController.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var soundManager = SoundManager()
    @IBOutlet var titleImage: UIImageView!
    
//    override func viewDidAppear(_ animated: Bool) {
//        soundManager.playSound(.openmusic)
//
//    }
    @IBAction func UwindBack(_ sender: UIStoryboardSegue) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleImage.startRotating()
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
