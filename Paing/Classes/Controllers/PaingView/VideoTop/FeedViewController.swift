//
//  FeedViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 24/07/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet var cvFeed: UICollectionView!
    
    var arrayVideoCollection: [BlogListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvFeed.delegate = self
        self.cvFeed.dataSource = self
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.estimatedItemSize = .zero
        
      //  collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
//        collectionView?.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
//        collectionView?.isPagingEnabled = true
//        collectionView?.dataSource = self
//
//        view.addSubview(collectionView!)
//
    }
    
}

extension FeedViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayVideoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.arrayVideoCollection[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath)as! FeedCollectionViewCell
        
        
        cell.configure(with: model)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 1   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((self.cvFeed.bounds.width) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: Int(self.cvFeed.bounds.width), height: Int(self.cvFeed.bounds.height))
    }
}
