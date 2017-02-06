//
//  RoomsCollectionViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/09.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RoomsCollectionViewController: UICollectionViewController {
    
    enum Room {
        case actionSheetController
        case comingSoon
        
        var title: String {
            switch self {
            case .actionSheetController:
                return "Action Sheet Controller"
            case .comingSoon:
                return "Coming soon"
            }
        }
        
        var backgroundImage: UIImage {
            switch self {
            case .actionSheetController:
                return #imageLiteral(resourceName: "HomeBackground")
            case .comingSoon:
                return #imageLiteral(resourceName: "Placeholder")
            }
        }
    }
    
    fileprivate let rooms: [Room] = [.actionSheetController, .comingSoon]
    
    let kRoomCellScaling: CGFloat = 0.6
    var selectedIndexPath: NSIndexPath?

//    let transitionManager = PanelTransition()
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RoomCollectionViewCell
        switch rooms[indexPath.row] {
        case .actionSheetController:
            cell.contentView.backgroundColor = UIColor.blue
            cell.roomTitle = "Conflict Controller"
        case .comingSoon:
            cell.contentView.backgroundColor = UIColor.red
            cell.roomTitle = "Conflict Controller"
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath as NSIndexPath?
        var controller = UIViewController()
        switch rooms[indexPath.row] {
        case .actionSheetController:
            controller = DemoConflictsViewController.create()
        case .comingSoon:
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as UIViewController
        }
        
//        controller.transitioningDelegate = transitionManager
        
        present(controller, animated: true, completion: nil)
    }
}

extension RoomsCollectionViewController {
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

extension RoomsCollectionViewController {
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

//extension RoomsCollectionViewController: PanelTransitionViewController {
//    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailedView! {
//        if let indexPath = selectedIndexPath {
//            if let cell = collectionView?.cellForItem(at: indexPath as IndexPath) as? RoomCollectionViewCell {
//                return cell.detailView
//            }
//        }
//        return nil
//    }
//}
