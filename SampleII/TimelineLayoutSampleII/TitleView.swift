//
//  TitleView.swift
//  TimelineLayoutSampleII
//
//  Created by seedante on 15/11/21.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

class TitleView: UIView {

    // Create CustomView.xib, set File's Owner to CustomView.
    // Link the top level view in the XIB to the contentView outlet.
    // The code comes from https://gist.github.com/bwhiteley/049e4bede49e71a6d2e2

    @IBOutlet private var contentView:UIView?

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("TitleView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(content)
    }

}
