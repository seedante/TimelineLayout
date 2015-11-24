//
//  CollectionViewController.swift
//  LayoutAnimationSample
//
//  Created by seedante on 15/11/10.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

private let headerLineViewIdentifier = "HeaderView"
private let footerLineViewIdentifier = "FooterView"
private let textCellIdentifier = "TextCell"
private let shaftHolderCell1Identifier = "ShaftHolderCell1"
private let shaftHolderCell2Identifier = "ShaftHolderCell2"
private let historicalRelicsCellIdentifier = "HistoricalRelicsCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {


    var dataSource: [[String]] =    [["6000BC", "", "DUFUNA", "DUFUNA.png"],
                                     ["600BC-200AD", "", "NOK", "NOK.png"],
                                     ["≈220AD", "", "AKWANSHI", "AKWANSHI.png"],
                                     ["≈500 - 1200AD", "", "CALABAR", "CALABAR.png"],
                                     ["≈900AD", "", "IGBO UKWU", "IGBO UKWU.png"],
                                     ["≈1000 - 1500AD", "", "IFE", "IFE.png"],
                                     ["≈1200 - 1400AD", "", "OWO", "OWO.png"],
                                     ["≈1400AD", "", "TADA", "TADA.png"],
                                     ["≈1500AD", "", "ESIE", "ESIE.png"],
                                     ["≈1900AD", "", "BENIN", "BENIN.png"]
                                    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.registerClass(LineView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerLineViewIdentifier)
        self.collectionView?.registerClass(LineView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerLineViewIdentifier)

        let backgroundColor = UIColor.init(patternImage: UIImage(named: "patternImage.png")!)
        self.collectionView?.backgroundColor = backgroundColor

        let titleView = TitleView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        collectionView?.superview?.addSubview(titleView)

        NSLayoutConstraint(item: titleView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView.superview, attribute: .CenterX, multiplier: 1.0, constant: 0).active = true
        NSLayoutConstraint(item: titleView, attribute: .Top, relatedBy: .Equal, toItem: titleView.superview, attribute: .TopMargin, multiplier: 1.0, constant: 100).active = true
        NSLayoutConstraint(item: titleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 300).active = true
        NSLayoutConstraint(item: titleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 50).active = true
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource[section].count
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var supplementaryView: UICollectionReusableView
        if kind == UICollectionElementKindSectionHeader{
            let reuseIdentifier = indexPath.section == 0 ? "Header" : headerLineViewIdentifier
            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath)
        }else{
            let reuseIdentifier = indexPath.section == dataSource.count - 1 ? "Footer" : footerLineViewIdentifier
            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath)
        }

        return supplementaryView
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cellIdentifier: String
        switch indexPath.item{
        case 0, 2:
            cellIdentifier = textCellIdentifier
        case 1:
            /* Solution-1: Decoration view to be line view. */
            cellIdentifier = shaftHolderCell1Identifier
            /* Solution-2: Header view to be line view. */
            //cellIdentifier = (indexPath.section == 0 || indexPath.section == dataSource.count - 1) ? shaftHolderCell1Identifier : shaftHolderCell2Identifier
        case 3:
            cellIdentifier = historicalRelicsCellIdentifier
        default:
            cellIdentifier = "EmptyCell"
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)

        // Configure the cell
        switch indexPath.item{
        case 0, 2:
            if let textLabel = cell.viewWithTag(10) as? UILabel{
                textLabel.text = dataSource[indexPath.section][indexPath.item]
            }
        case 3:
            if let imageView = cell.viewWithTag(10) as? UIImageView{
                let image = UIImage(named: dataSource[indexPath.section][indexPath.item])
                imageView.image = image
            }
        default: break
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        /* Solution-1: Decoration view to be line view. */
        var headerSize = CGSizeZero
        if section == 0{
            headerSize = CGSize(width: 100, height: 2)
        }
        return headerSize

        /* Solution-2: Header view to be line view. */
//        var headerSize = CGSize(width: 1, height: 2)
//        if section == 0{
//            headerSize = CGSize(width: 100, height: 2)
//        }
//        return headerSize

    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize = CGSizeZero
        switch indexPath.item{
        case 0:
            cellSize = CGSize(width: 120, height: 21)
        case 1:
            cellSize = CGSize(width: 120, height: 120)
        case 2:
            cellSize = CGSize(width: 120, height: 21)
        case 3:
            switch indexPath.section{
            case 0:
                cellSize = CGSize(width: 120, height: 120)
            case 1, 4, 5, 9:
                cellSize = CGSize(width: 250, height: 250)
            case 2, 3, 6, 7, 8:
                cellSize = CGSize(width: 100, height: 100)
            default: break
            }

        default:break
        }

        return cellSize
    }


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        var footerSize = CGSizeZero
        if section == dataSource.count - 1{
            footerSize = CGSize(width: 35, height: 2)
        }
        return footerSize
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch section{
        case 0:
            return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        case 1:
            return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 0)
        case 2:
            return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 0)
        case 3:
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
        case 4:
            return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 0)
        case 5:
            return UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 0)
        case 6:
            return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 0)
        case 7:
            return UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 0)
        case 8:
            return UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 0)
        case 9:
            return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 0)
        default:
            return UIEdgeInsets(top: 20, left: 100, bottom: 20, right: 0)
        }
    }

}
