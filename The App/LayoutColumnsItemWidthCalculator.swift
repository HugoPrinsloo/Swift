//
//  LayoutColumnsItemWidthCalculator.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/03.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

/// A helper to calculate the width of items given a view width and desired width
public struct LayoutColumnsItemWidthCalculator {
    /**
     Returns the item width for an element in a flow layout making a best effort attempt to match the desiredItemWidth.
     
     - parameter viewWidth: the total width of content that will be displayed. This should already be the width subtracted by various
     section insets etc.
     - parameter desiredItemWidth: The desired width for each cell.
     - parameter horizontalInterItemSpacing: The spacing between cells that you desire.
     - parameter minimumColumnCount: The minimum number of columns to use
     */
    public static func itemWidth(forViewWidth viewWidth: CGFloat, desiredItemWidth: CGFloat, horizontalInterItemSpacing: CGFloat, minimumColumnCount: Int = 1) -> CGFloat {
        let items = max(CGFloat(minimumColumnCount), viewWidth / desiredItemWidth)
        let columns = floor(items)
        var itemWidth = (viewWidth - (columns - 1) * horizontalInterItemSpacing) / columns
        itemWidth = floor(itemWidth)
        return itemWidth
    }
}
