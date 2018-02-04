import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    var card: Card?
    
    func setCard(_ card:Card){
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
    }
    
    func flip(){
        UIView.transition(from: backImageView, to: frontImageView, duration: 1.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
}
