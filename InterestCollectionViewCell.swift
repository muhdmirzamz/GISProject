 

import UIKit

class InterestCollectionViewCell: UICollectionViewCell
{
    
    
  
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var lockLabel: UIImageView!
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.lockLabel.hidden = true
    }
}





















