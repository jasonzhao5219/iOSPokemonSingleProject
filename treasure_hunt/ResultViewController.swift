//
//  ResultViewController.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var soundManager = SoundManager()

    @IBOutlet var winningLabel: UILabel!
    
    @IBOutlet var hintLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hintLabel.backgroundColor = UIColor(patternImage: UIImage(named: "treasure")!)
        backButton.setTitle("Play Again!", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.short)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        soundManager.stopSound()
    }



}
