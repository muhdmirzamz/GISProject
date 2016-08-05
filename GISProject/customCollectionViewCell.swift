//
//  customCollectionViewCell.swift
//  GISProject
//
//  Created by XINGYU on 4/8/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class customCollectionViewCell: UICollectionViewCell {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opponents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! OpponentCVCell
        cell.opponent = self.opponents[indexPath.item]
        opponentName = "    \(self.opponents[indexPath.item].firstName) \(self.opponents[indexPath.item].surname)  (\(self.opponents[indexPath.item].rank))".uppercaseString
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name:"Profile", bundle:nil)
        if let previewViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileVC") as? ProfileVC {
            self.navigationController?.pushViewController(previewViewController, animated: true)
        }
    }
    
}
