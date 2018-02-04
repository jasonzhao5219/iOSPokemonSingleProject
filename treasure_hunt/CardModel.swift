//
//  CardModel.swift
//  treasure_hunt
//
//  Created by Jason Zhao on 2/1/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        var generateCardsArray = [Card]()
        
        for _ in 1...6 {
            let randomNumber = arc4random_uniform(6) + 1
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generateCardsArray.append(cardOne)
            
            
        }
        return generateCardsArray
    }
    
}
