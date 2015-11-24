//
//  SDETimelineLayout.swift
//  TimelineLayoutSample
//
//  Created by seedante on 15/11/17.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

private let decorationLineViewKind = "LineView"

class SDETimelineLayout: UICollectionViewFlowLayout {

    //the follow parameter is relative to header view config in storyboard
    let footerXOffset: CGFloat = 8.0
    let decorationLineXOffset: CGFloat = 18.0

    override init() {
        super.init()
        self.registerClass(DecorationLineView.self, forDecorationViewOfKind: decorationLineViewKind)
        self.footerReferenceSize = CGSize(width: 10.0, height: 2.0)
        self.sectionInset = UIEdgeInsets(top: 10, left: 48, bottom: 10, right: 50.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.registerClass(DecorationLineView.self, forDecorationViewOfKind: decorationLineViewKind)
        self.footerReferenceSize = CGSize(width: 10.0, height: 2.0)
        self.sectionInset = UIEdgeInsets(top: 10, left: 48, bottom: 10, right: 50.0)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = super.layoutAttributesForElementsInRect(rect)

        let headerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionHeader })//.sort({$0.indexPath.section < $1.indexPath.section})
        if headerLayoutAttrs?.count > 0{
            let sectionCount = (self.collectionView?.dataSource?.numberOfSectionsInCollectionView!(self.collectionView!))!
            for headerLayoutAttr in headerLayoutAttrs!{
                /*
                -------- HeaderView
                |
                |        DecorationView
                |
                -------- HeaderView
                |
                |        DecorationView
                |
                -------- FooterView
                */

                let decorationViewLayoutAttr = self.layoutAttributesForDecorationViewOfKind(decorationLineViewKind, atIndexPath: headerLayoutAttr.indexPath)
                if decorationViewLayoutAttr != nil{
                    layoutAttrs?.append(decorationViewLayoutAttr!)
                }

                let headerSize = headerLayoutAttr.size
                var lineLength: CGFloat = 0

                if headerLayoutAttr.indexPath.section < sectionCount - 1{
                    if let nexHeaderLayoutAttr = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: headerLayoutAttr.indexPath.section + 1)){
                        lineLength = nexHeaderLayoutAttr.frame.origin.y - headerLayoutAttr.frame.origin.y
                    }
                }else{
                    //Only one footer, in last section.
                    let footerLayouts = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionFooter && $0.indexPath.section == headerLayoutAttr.indexPath.section})
                    if footerLayouts?.count == 1{
                        let footerLayoutAttr = footerLayouts!.first
                        let y = footerLayoutAttr!.frame.origin.y
                        footerLayoutAttr!.frame = CGRect(x: footerXOffset, y: y, width: 20, height: 2)
                        lineLength =  y - headerLayoutAttr.frame.origin.y - headerSize.height / 2
                    }else{
                        lineLength = rect.height + rect.origin.y - headerLayoutAttr.frame.origin.y - headerSize.height / 2
                        //or
//                        if let footerLayoutAttr = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath: headerLayoutAttr.indexPath){
//                            lineLength = footerLayoutAttr.frame.origin.y - headerLayoutAttr.frame.origin.y
//                        }
                    }
                }

                //about line width, on non-retina iOS device, it must >= 0.54, or else can't see it. There is no problem on retina iOS device with 0.5 width, it can deep to 0.27 width.
                decorationViewLayoutAttr?.frame = CGRect(x: decorationLineXOffset, y: (headerLayoutAttr.frame.origin.y + headerSize.height / 2), width: 0.55, height: lineLength)
            }
        }

        return layoutAttrs
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

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        if elementKind == UICollectionElementKindSectionFooter{
            let origin = layoutAttr?.frame.origin
            layoutAttr?.frame = CGRect(x: footerXOffset, y: origin!.y, width: 20, height: 2)
        }
        return layoutAttr
    }

    //#MARK: config initial layout animation
    override func initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind, atIndexPath: elementIndexPath)
        if elementKind == UICollectionElementKindSectionFooter{
            layoutAttr?.size = CGSizeZero
        }
        return layoutAttr
    }

    override func initialLayoutAttributesForAppearingDecorationElementOfKind(elementKind: String, atIndexPath decorationIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.initialLayoutAttributesForAppearingDecorationElementOfKind(elementKind, atIndexPath: decorationIndexPath)
        let headerLayoutAttr = self.initialLayoutAttributesForAppearingSupplementaryElementOfKind(UICollectionElementKindSectionHeader, atIndexPath: decorationIndexPath)
        var offsetY: CGFloat = 0
        if headerLayoutAttr != nil{
            offsetY = (headerLayoutAttr?.frame.origin.y)! + (headerLayoutAttr?.size.height)! / 2
        }
        layoutAttr?.frame = CGRect(x: decorationLineXOffset, y: offsetY, width: 1.0, height: 1.0)

        return layoutAttr
    }

}
