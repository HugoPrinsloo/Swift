//
//  BannerView.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/03.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

protocol StoreBannerViewDelegate {
    func storeBannerView(_ storeBannerView: StoreBannerView, didSelectItemAtIndex index: Int)
}

protocol StoreBannerViewDataSource {
    func storeBannerViewNumberOfImages(_ storeBannerView: StoreBannerView) -> Int
    func storeBannerView(_ storeBannerView: StoreBannerView, imageAtIndex index: Int) -> UIImage
}

struct BannerConfiguration {
    static var autoScrollEnabled = true
    static var autoScrollSpeed = 4.0
    static var bannerMaxWidth: CGFloat = 375
}

// MARK: View
class StoreBannerView: UIView {
    
    fileprivate let collectionView: UICollectionView!
    fileprivate let flowLayout: StoreBannerCollectionViewLayout!
    
    var dataSource: StoreBannerViewDataSource?
    var delegate: StoreBannerViewDelegate?
    
    fileprivate var autoScrollingEnabled = BannerConfiguration.autoScrollEnabled
    fileprivate var timer: Timer?
    
    override init(frame: CGRect) {
        
        flowLayout = StoreBannerCollectionViewLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(frame: frame)
        commonInit()
    }
    
    fileprivate func commonInit() {
        self.addSubview(collectionView)
        
        collectionView.register(StoreBannerCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.backgroundColor = UIColor.white
        
        flowLayout.minimumLineSpacing = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        autoScrolling(autoScrollingEnabled)
    }
    
    /**
     When autoscrolling enabled we set a timer to call triggerAutoScroll() every 3 seconds.
     - triggerAutoScroll() makes the actual scroll by looking at the current offset and calculates space needed to the center and sets it to the targetOffset.
     */
    func autoScrolling(_ enabled: Bool) {
        if enabled {
            timer = Timer.scheduledTimer(timeInterval: BannerConfiguration.autoScrollSpeed, target: self, selector: #selector(StoreBannerView.triggerAutoScroll), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    func triggerAutoScroll() {
        let currentOffset: CGFloat = self.collectionView.contentOffset.x
        let targetOffset: CGFloat = currentOffset + self.flowLayout.itemSize.width
        collectionView.setContentOffset(CGPoint(x: targetOffset, y: self.collectionView.contentOffset.y), animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
        DispatchQueue.main.async(execute: {
            let indexPath = IndexPath(row: 3, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        flowLayout = StoreBannerCollectionViewLayout()
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: aDecoder)
        commonInit()
    }
}

// MARK: CollectionViewDelegate
extension StoreBannerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.storeBannerView(self, didSelectItemAtIndex: indexPath.row % 3)
    }
}

// MARK: CollectionViewDataSource
extension StoreBannerView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfImages()
    }
    
    fileprivate func numberOfImages() -> Int {
        return (dataSource?.storeBannerViewNumberOfImages(self) ?? 0) * 3
    }
    
    fileprivate func imageAtIndexPath(_ indexPath: IndexPath) -> UIImage? {
        return dataSource?.storeBannerView(self, imageAtIndex: indexPath.row % 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StoreBannerCollectionViewCell
        cell.bannerImage.image = imageAtIndexPath(indexPath)
        return cell
    }
    
    /** Calculations in scrollViewDidScroll creates the infinite scroll effect */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = flowLayout.itemSize.width
        let bannerItems = CGFloat(numberOfImages()) / 3
        let periodOffset = pageWidth * bannerItems
        let offsetActivatingMoveToBeginning = pageWidth * bannerItems * 2
        let offsetActivatingMoveToEnd = pageWidth * bannerItems
        let offsetX = scrollView.contentOffset.x
        
        if offsetX > offsetActivatingMoveToBeginning {
            scrollView.contentOffset = CGPoint(x: offsetX - periodOffset, y: 0)
        } else if offsetX < offsetActivatingMoveToEnd {
            scrollView.contentOffset = CGPoint(x: offsetX + periodOffset, y: 0)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        autoScrolling(false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        autoScrolling(autoScrollingEnabled)
    }
}

// MARK: StoreBannerCollectionViewCell
class StoreBannerCollectionViewCell: UICollectionViewCell {
    
    var bannerImage: UIImageView
    
    override init(frame: CGRect) {
        
        bannerImage = UIImageView(frame: .zero)
        
        super.init(frame: frame)
        
        contentView.addSubview(bannerImage)
        
        bannerImage.translatesAutoresizingMaskIntoConstraints = false
        bannerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bannerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bannerImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bannerImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bannerImage.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: StoreBannerCollectionViewLayout
class StoreBannerCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        var size = collectionView.frame.size
        size.width = min(collectionView.frame.width, BannerConfiguration.bannerMaxWidth)
        itemSize = size
    }
    
    override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        guard let collectionView = collectionView else { return }
        if let centerIndexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)) {
            collectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        let bounds = collectionView.bounds
        return !newBounds.equalTo(bounds)
    }
    
    /** This places the CollectionViewCell in the center. Create Paging effect */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.bounds.width * 0.5
        let layoutAttributesForElements = self.layoutAttributesForElements(in: collectionView.bounds)!
        var layoutAttributes = layoutAttributesForElements.first
        
        for layoutAttributesForElement in layoutAttributesForElements {
            let distance1: CGFloat = layoutAttributesForElement.center.x - proposedContentOffsetCenterX
            let distance2: CGFloat = layoutAttributes!.center.x - proposedContentOffsetCenterX
            if fabs(distance1) < fabs(distance2) {
                layoutAttributes = layoutAttributesForElement
            }
        }
        if let layoutAttributes = layoutAttributes {
            return CGPoint(x: layoutAttributes.center.x - collectionView.bounds.width * 0.5, y: proposedContentOffset.y)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
}

class StoreBannerCell: UICollectionViewCell {
    
    let view = StoreBannerView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct StoreBannerItem {
    let sku: String?
    let image: () -> UIImage
    let isSubscription: Bool
}

extension StoreBannerItem {
    
    static func allItems() -> [StoreBannerItem] {
        let path = Bundle.main.path(forResource: "StoreBanner", ofType: "plist")!
        let bannerItems = NSArray(contentsOfFile: path) as! [[String: AnyObject]]
        return bannerItems.map { itemDict in
            let sku = itemDict["sku"] as! String
            let imageName = itemDict["imageName"] as! String
            let imageBlock = { return UIImage(named: imageName)! }
            let isSubscription = itemDict["subscription"] as! Bool
            return StoreBannerItem(sku: sku, image: imageBlock, isSubscription: isSubscription)
        }
    }
}
