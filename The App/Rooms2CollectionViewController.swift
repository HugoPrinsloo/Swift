//
//  Rooms2CollectionViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/24.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class Rooms2CollectionViewController: UICollectionViewController {
    
    enum Room {
        case storeBanner
        case actionSheetController
        case comingSoon
        
        var title: String {
            switch self {
            case .storeBanner:
                return "Store Banner"
            case .actionSheetController:
                return "Conflict Sheet Controller"
            case .comingSoon:
                return "Coming soon"
            }
        }
        
        var subtitle: String {
            switch self {
            case .storeBanner:
                return "Infinite scroll banner looks amazeballs on a store page"
            case .actionSheetController:
                return "Give the user the opportunity to select which conflicted files to keep"
            case .comingSoon:
                return ""
            }
        }
        
        var backgroundImage: UIImage {
            switch self {
            case .storeBanner:
                return #imageLiteral(resourceName: "BannerBackground")
            case .actionSheetController:
                return #imageLiteral(resourceName: "Conflict Background")
            case .comingSoon:
                return #imageLiteral(resourceName: "ComingSoon-Background")
            }
        }
    }
    
    fileprivate let rooms: [Room] = [.storeBanner, .actionSheetController, .comingSoon]
    
    let kRoomCellScaling: CGFloat = 0.6
    var selectedIndexPath: NSIndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Room2Cell
        let room = rooms[indexPath.row]
   
        cell.title.text = room.title
        cell.subtitle.text = room.subtitle
        cell.image.image = room.backgroundImage

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath as NSIndexPath?
        var controller = UIViewController()
        switch rooms[indexPath.row] {
        case .storeBanner:
            controller = ComingSoonViewController.create()
        case .actionSheetController:
            controller = DemoConflictsViewController.create()
        case .comingSoon:
            controller = ComingSoonViewController.create()
        }
        present(controller, animated: true, completion: nil)
    }
}

extension Rooms2CollectionViewController {
    func setupCollectionView() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * kRoomCellScaling)
        let cellHeight = floor(screenSize.height * kRoomCellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView?.reloadData()
    }
}

extension Rooms2CollectionViewController {
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

class Room2Cell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var image: UIImageView!
}



