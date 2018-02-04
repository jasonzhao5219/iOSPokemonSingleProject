//
//  ResultViewController.swift
//  treasure_hunt
//
//  Created by Rachel Ng on 1/18/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit
import CoreData
class ResultViewController: UIViewController,UICollectionViewDelegate ,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    var model = CardModel()
    var cardArray = [Card]()
    //initial CoreDate context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func BackPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        cell.flip()
    }
    var soundManager = SoundManager()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var winningLabel: UILabel!
    
    @IBOutlet var hintLabel: UILabel!
    
    @IBOutlet var backButton: UIButton!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
    var passTreasureCounter:Int16 = 1
    var EntityInResult = [PokemonEntity]()
    func getCards(passvalue:Int16) -> [Card]{
        var generateCardsArray = [Card]()
        
        for _ in 0...passvalue {
            let randomNumber = arc4random_uniform(6) + 1
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generateCardsArray.append(cardOne)
            
            
        }
        return generateCardsArray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // hintLabel.backgroundColor = UIColor(patternImage: UIImage(named: "treasure-map")!)
        backButton.setTitle("Play Again!", for: .normal)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.short)
        //fetch CoreDate
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonEntity")
        do {
            // get the results by executing the fetch request we made earlier
            let results = try managedObjectContext.fetch(itemRequest)
            // downcast the results as an array of AwesomeEntity objects
            EntityInResult = results as! [PokemonEntity]
      
            passTreasureCounter = EntityInResult[EntityInResult.count-1].entitycounter

            try managedObjectContext.save()
            
            
        } catch {
            // print the error if it is caught (Swift automatically saves the error in "error")
            print("\(error)")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        //call the getcards method of the card model
        cardArray = getCards(passvalue: passTreasureCounter)
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        soundManager.stopSound()
    }



}
