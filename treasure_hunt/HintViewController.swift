//
//  HintViewController.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol HintViewControllerDelegate: class {
    func displayHint(by controller: HintViewController, with text: String)
}

class HintViewController: UIViewController {
    
    weak var delegate: HintViewControllerDelegate?
    
    var message: String = ""

    var soundManager = SoundManager()
    
    @IBOutlet var hintLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hintLabel.backgroundColor = UIColor(patternImage: UIImage(named: "Treasure-map")!)
        hintLabel.text = ("\(message)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.bell)
    }
    


}
