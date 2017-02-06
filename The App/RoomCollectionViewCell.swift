//
//  RoomCollectionViewCell.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/09.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

@IBDesignable class RoomCollectionViewCell: UICollectionViewCell {
    let detailView = DetailedView(frame: .zero)
    var roomTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        contentView.addSubview(detailView)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.masksToBounds = false
        
        detailView.titleLabel.text = roomTitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let scale = bounds.width / screenBounds.width
        
        detailView.transitionProgress = 1
        detailView.frame = screenBounds
        detailView.transform = CGAffineTransform(scaleX: scale, y: scale)
        detailView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }
}
