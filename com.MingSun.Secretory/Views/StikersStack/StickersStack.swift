//
//  StickersStack.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/28/19.
//

import UIKit

protocol StickersStackDataSource: AnyObject {
	func numberOfStickers() -> Int
	func contentViewForSticker(at index: Int) -> UIView
}

class StickersStack: UIView {
	weak var dataSource: StickersStackDataSource?

	typealias StickerOffset = (h: CGFloat, v: CGFloat)
	var defaultOffset: StickerOffset = (h: CGFloat(10), v: CGFloat(10))
	var defaultStickerSize: CGSize {
		let stackSize = bounds
		let defaultSize = (w: stackSize.width - CGFloat(maxVisibleStickers) * defaultOffset.h * 2,
						   h: stackSize.height - CGFloat(maxVisibleStickers) * defaultOffset.v)
		return CGSize.init(width: defaultSize.w, height: defaultSize.h)
	}

	/**
	stickers array is used as a stack, consider it: [bottom,.....,top]
	**/
	private let stickersPool = ElementsPool<Sticker>(with: { return Sticker() })
	private var stickers: [Sticker] = []
	private var endIndex: Int = 0
	var maxVisibleStickers: Int = 5

	override init(frame: CGRect) {
		super.init(frame: frame)

		initialSetup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		initialSetup()
	}

	private func initialSetup() {
		observeChanges()
	}
}

// ******** StickerPresentation related ********
extension StickersStack {
	func reloadStack() {
		removeAll()

		guard let newCount = dataSource?.numberOfStickers(), newCount != 0 else { return }
		endIndex = newCount - 1
		let startIndex = endIndex - min(newCount,maxVisibleStickers) + 1

		for i in startIndex...endIndex {
			addSticker(at: i, animate: false)
		}

		redoTransform()
	}

	func addSticker(at i: Int, animate: Bool = true) {
		let sticker = stickersPool.draw()
		if let contentView = dataSource?.contentViewForSticker(at: i) {
			sticker.attachContentView(contentView)
		}
		stickers.append(sticker)
		setupSticker(sticker)
		if animate {
			addNewVisibleStickerToTop(sticker)
		}
	}

	private func setupSticker(_ sticker: Sticker) {
		addSubview(sticker)
		sticker.frame = getNewStickerRect()
	}

	private func getNewStickerRect() -> CGRect {
		let size = defaultStickerSize
		let minX = (bounds.width - size.width) / 2
		let minY = bounds.height - size.height

		return CGRect.init(x: minX, y: minY, width: size.width, height: size.height)
	}

//	func oldVisibleStickerDisappear(_ sticker: Sticker) {
//		sticker.removeFromSuperview()
//	}

	func addNewVisibleStickerToTop(_ sticker: Sticker) {
		bringSubviewToFront(sticker)
		redoTransform()
	}

//	func newVisibleStickerAddedToBack(_ sticker: Sticker) {
//		setupSticker(sticker)
//		sendSubviewToBack(sticker)
//	}
//
//	func removeTopSticker() {
//		stickers.removeLast()
//		if stickers.count >= maxVisibleStickers {
//			if let bottom = getBottomVisibleSticker() {
//				newVisibleStickerAddedToBack(bottom)
//			}
//		}
//	}
//
//	func getBottomVisibleSticker() -> Sticker? {
//		if stickers.count == 0 { return nil }
//
//		let index = stickers.count - maxVisibleStickers - 1
//		let validIndex = max(0,index)
//		return stickers[validIndex]
//	}

	func removeAll() {
		for (i,s) in stickers.enumerated().reversed() {
			stickers.remove(at: i)
			stickersPool.release(s)
		}
	}
}

// ******** Animation related ********
extension StickersStack {
	func observeChanges() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(orientationDidChange),
											   name: UIDevice.orientationDidChangeNotification,
											   object: nil)
	}

	@objc func orientationDidChange() {
		redoFrame()
		redoTransform()
	}

	private func redoFrame() {
		for s in stickers {
			s.reset()
			s.frame = getNewStickerRect()
		}
	}

	private func redoTransform() {
		for (i,v) in stickers.enumerated() {
			v.reset()
			v.swing(stickers.count - 1 - i)
			v.saveCurrentState()
		}
	}
}
