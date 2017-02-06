//
//  GridLayout.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/03.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    struct Defaults {
        
        static let MinimumSpacing: CGFloat = 20
        static let DesiredItemWidth: CGFloat = 50
        static let SectionInsetVertical: CGFloat = 20
        static let SectionInsetHorizontal: CGFloat = 20
        static let FooterCollapsedHeight: CGFloat = 0
        static let FooterExpandedHeight: CGFloat = 100
        static let cellHeight: CGFloat = 20
        
        static func desiredItemWidth(forSizeClass: UIUserInterfaceSizeClass) -> CGFloat {
            if case .regular = forSizeClass {
                return 224
            } else {
                return 148
            }
        }
    }
    
    public enum FooterState {
        case collapsed
        case expanded
        
        var footerHeight: CGFloat {
            switch self {
            case .collapsed: return Defaults.FooterCollapsedHeight
            case .expanded: return Defaults.FooterExpandedHeight
            }
        }
    }
    
    public var footerState: FooterState = .expanded {
        didSet {
            if footerState != oldValue {
                invalidateLayout()
            }
        }
    }
    
    public override init() {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        minimumLineSpacing = (Defaults.MinimumSpacing)
        minimumInteritemSpacing = (Defaults.MinimumSpacing)
        sectionInset = UIEdgeInsetsMake(Defaults.SectionInsetVertical, Defaults.SectionInsetHorizontal, Defaults.SectionInsetVertical, Defaults.SectionInsetHorizontal)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        itemSize = calculateItemSize(collectionView)
        footerReferenceSize = CGSize(width: collectionView.bounds.width, height: footerState.footerHeight)
        oldBounds = collectionView.bounds
    }
    
    func calculateItemSize(_ collectionView: UICollectionView) -> CGSize {
        
        var itemWidth = Defaults.desiredItemWidth(forSizeClass: collectionView.traitCollection.horizontalSizeClass)
        
        var viewWidth = collectionView.frame.width
        let spacing = Defaults.MinimumSpacing
        let horizontalSectionInsets = sectionInset.left + sectionInset.right
        
        if viewWidth == 0 {
            itemSize = CGSize(width: itemWidth, height: itemWidth + Defaults.cellHeight)
        }
        
        viewWidth = viewWidth - horizontalSectionInsets
        
        itemWidth = LayoutColumnsItemWidthCalculator.itemWidth(forViewWidth: viewWidth, desiredItemWidth: itemWidth, horizontalInterItemSpacing: spacing)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    var oldBounds: CGRect = .zero
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != oldBounds.size
    }

}
