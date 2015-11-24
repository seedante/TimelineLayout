# UICollectionView Timeline Layout Sample
Design by [Łukasz Frankiewicz](https://dribbble.com/shots/1885957-Gallery-UI-transitions-iPad-UI-UX-iOS). Layout 1 Screenshot:

![Timeline Layout I](https://github.com/seedante/TimelineLayout/blob/master/Timeline-Layout-I-Screenshot.jpg)

Design by [Sasha Lantukh](https://dribbble.com/shots/2247856-Save-African-History-Nigerian-Timeline). Layout 2 Screenshot:

![Timeline Layout II](https://github.com/seedante/TimelineLayout/blob/master/Timeline-Layout-II-Screenshot.jpg)

**关于实现思路：[UICollectionView：打造时间轴布局(timeline layout)](http://www.jianshu.com/p/e10d95c676a8)。**

# Issue Collection

### Sample 1: Snapshotting a view that has not been rendered results in an empty snapshot

No affect on work. The issue can be reproduced on iOS 8.0 and iOS 9.1, and no solution for now. 

If a section across CollectionView's visible area's bottom, when you add or delete section, it will raise this issue easily on landscape mode, not so much on portrait mode.

### Sample 2: NSInternalInconsistencyException when scrolling to the bottom

Fatal Issue. Don't Worry. It's fixed. If you get this exception in some place, I hope the words below can help you.

The log like this:

	NSInternalInconsistencyException: layout attributes for xxx changed from xxx to xxx without invalidating the layout.

Actually, the log has told us what happened. When scrolling to bottom or top, people always continue to scroll to beyond the contentSize and CollectionView will go back. In the process, layout system will call `layoutAttributesForElementsInRect:`for two different rect, if any layoutAttributes changed its property, you will get this exception. That's what exception means. If any layoutAttributes changes dunamically, don't change it in this process. 

### Sample 2: cached frame mismatch

No affect on work. The issue can be reproduced on iOS 9.1, and no solution for now. 

You can search such issues in some repoes, all with the same reason: 

	Logging only once for UICollectionViewFlowLayout cache mismatched frame
	UICollectionViewFlowLayout has cached frame mismatch for index path <NSIndexPath: 0x16e2cf40> {length = 2, path = 0 - 1} - cached value: {{100, 557}, {120, 120}}; expected value: {{100, 51}, {120, 120}}
	This is likely occurring because the flow layout subclass TimelineLayoutSampleII.NigerianTimelineLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them


Does this line of code `let layoutAttrs =  super.layoutAttributesForElementsInRect(rect)` get into trouble? We all know that value type assignment is just copy in Swift. Just in case, I manually copy elements one by one into another array since `copy()` function is unavailable in Swift 2.0. This doesn't work. 

Let's see the second line of log. One layoutAttributes changed, but I changed all others layoutAttributes return by super. This issue can reproduce on iOS 9.1, not on iOS 8.0. I guess it's UIKit's problem. If you find the solution, please tell me.
