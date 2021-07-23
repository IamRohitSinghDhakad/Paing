//
//  VideoPreviewViewController.swift
//  Paing
//
//  Created by Paras on 23/07/21.
//

import UIKit

class VideoPreviewViewController: UIViewController {
    
    
    @IBOutlet weak var cvVideo: UICollectionView!
    
    let margin: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvVideo.delegate = self
        self.cvVideo.dataSource = self
        
        guard let collectionView = self.cvVideo, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - Collection Methods

extension VideoPreviewViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cvVideo.dequeueReusableCell(withReuseIdentifier: "VideoPreviewCollectionViewCell", for: indexPath) as! VideoPreviewCollectionViewCell
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
      //  self.actionImageVideoSelect(index: row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 1   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((self.cvVideo.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: Int(self.cvVideo.bounds.height))
    }
    
}
