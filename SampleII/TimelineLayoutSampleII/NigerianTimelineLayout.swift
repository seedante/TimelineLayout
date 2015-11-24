//
//  NigerianTimelineLayout.swift
//  TimelineLayoutSampleII
//
//  Created by seedante on 15/11/20.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

private let decorationLineViewKind = "LineView"

class NigerianTimelineLayout: UICollectionViewFlowLayout {

    let lineThickness: CGFloat = 2
    let nodeRadius: CGFloat = 10.0

    override init(){
        super.init()
        self.scrollDirection = .Horizontal
        self.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.registerClass(LineView.self, forDecorationViewOfKind: decorationLineViewKind)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollDirection = .Horizontal
        self.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.registerClass(LineView.self, forDecorationViewOfKind: decorationLineViewKind)
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let oldBounds = self.collectionView!.bounds
        if CGRectEqualToRect(oldBounds, newBounds){
            return false
        }else{
            return true
        }
    }

    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, withIndexPath: indexPath)
    }

    /*
    Solution 1: use decorationView to be line view. When you change to another solution, remember that modify code in "CollectionViewController.swift".
    */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = super.layoutAttributesForElementsInRect(rect)

        //reverse layout direction
        let cellLayoutAttrs = layoutAttrs?.filter({ $0.representedElementCategory == .Cell })
        let fixedHeight = self.collectionView!.bounds.height - self.sectionInset.top - self.sectionInset.bottom
        var isCalculated = false
        var timelineY: CGFloat = 0.0
        if cellLayoutAttrs?.count > 0{
            for layoutAttribute in cellLayoutAttrs!{
                layoutAttribute.center = CGPoint(x: layoutAttribute.center.x, y: fixedHeight - layoutAttribute.center.y)
                if layoutAttribute.indexPath.item == 1 && !isCalculated{
                    timelineY = layoutAttribute.frame.origin.y + layoutAttribute.size.height - nodeRadius - lineThickness / 2
                    isCalculated = true
                }
            }
        }

        //config decoration view
        if let decorationViewLayoutAttr = self.layoutAttributesForDecorationViewOfKind(decorationLineViewKind, atIndexPath: NSIndexPath(forItem: 0, inSection: 0)){
            let sectionCount = self.collectionView!.dataSource!.numberOfSectionsInCollectionView!(self.collectionView!)
            let firstNodeCellAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))
            let lastNodeCellAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: sectionCount - 1))
            let timelineStartX = firstNodeCellAttr!.center.x
            let timelineEndX = lastNodeCellAttr!.center.x
            decorationViewLayoutAttr.frame = CGRect(x: timelineStartX, y: timelineY, width: timelineEndX - timelineStartX, height: lineThickness)

            layoutAttrs?.append(decorationViewLayoutAttr)
        }


        //config header view
        let headerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionHeader })
        if headerLayoutAttrs?.count == 1{
            let headerLayoutAttr = headerLayoutAttrs!.first!
            if let cellLayoutAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: headerLayoutAttr.indexPath.section)){
                let origin = headerLayoutAttr.frame.origin
                let headerEndX = cellLayoutAttr.center.x - nodeRadius + 1
                headerLayoutAttr.frame = CGRect(x: origin.x, y: timelineY, width: headerEndX - origin.x, height: lineThickness)
            }
        }

        //config footer view
        let footerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionFooter })
        if footerLayoutAttrs?.count == 1{
            let footerLayoutAttr = footerLayoutAttrs!.first!
            if let cellLayoutAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: footerLayoutAttr.indexPath.section)){
                let origin = footerLayoutAttr.frame.origin
                let size = footerLayoutAttr.size
                let footerStartX = cellLayoutAttr.center.x + nodeRadius - 1
                footerLayoutAttr.frame = CGRect(x: footerStartX, y: timelineY, width: origin.x + size.width - footerStartX, height: lineThickness)
            }
        }
        
        return layoutAttrs
    }


    /*
    Solution 2: use header view to be line view. When you change to another solution, remember that modify code in "CollectionViewController.swift".
    */
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let layoutAttrs =  super.layoutAttributesForElementsInRect(rect)
//
//        //reverse layout direction
//        let cellLayoutAttrs = layoutAttrs?.filter({ $0.representedElementCategory == .Cell })
//        let fixedHeight = self.collectionView!.bounds.height - self.sectionInset.top - self.sectionInset.bottom
//        var isCalculated = false
//        var timelineY: CGFloat = 0.0
//        if cellLayoutAttrs?.count > 0{
//            for layoutAttribute in cellLayoutAttrs!{
//                layoutAttribute.center = CGPoint(x: layoutAttribute.center.x, y: fixedHeight - layoutAttribute.center.y)
//                if layoutAttribute.indexPath.item == 1 && !isCalculated{
//                    timelineY = layoutAttribute.frame.origin.y + layoutAttribute.size.height - nodeRadius - lineThickness / 2
//                    isCalculated = true
//                }
//            }
//        }
//
//        //config header view
//        let headerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionHeader })
//        if headerLayoutAttrs?.count > 0{
//            for headerLayoutAttr in headerLayoutAttrs!{
//                var headerStartX: CGFloat = 0
//                if headerLayoutAttr.indexPath.section == 0{
//                    headerStartX = headerLayoutAttr.frame.origin.x
//                }else{
//                    let cellLayoutAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: headerLayoutAttr.indexPath.section - 1))
//                    headerStartX = cellLayoutAttr!.center.x + nodeRadius - 1
//                }
//
//                var headerEndX: CGFloat = 0
//                if let cellLayoutAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: headerLayoutAttr.indexPath.section)){
//                    headerEndX = cellLayoutAttr.center.x - nodeRadius + 1
//                }
//                headerLayoutAttr.frame = CGRect(x: headerStartX, y: timelineY, width: headerEndX - headerStartX, height: lineThickness)
//            }
//        }
//
//        //Config footer view. Only one footer.
//        let footerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionFooter })
//        if footerLayoutAttrs?.count == 1{
//            let footerLayoutAttr = footerLayoutAttrs!.first!
//            let origin = footerLayoutAttr.frame.origin
//            let size = footerLayoutAttr.size
//            if let cellLayoutAttr = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: footerLayoutAttr.indexPath.section)){
//                let lineLength = origin.x + size.width - (cellLayoutAttr.center.x + nodeRadius - 1)
//                footerLayoutAttr.frame = CGRect(x: cellLayoutAttr.center.x + nodeRadius - 1 , y: timelineY, width: lineLength, height: lineThickness)
//            }
//        }
//
//        return layoutAttrs
//    }

}
