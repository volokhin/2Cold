import UIKit

public class CarouselProgressControl : UIControl {

	/// Основной цвет элементов
	public var itemColor: UIColor = .gray
	/// Цвет текущего элемента
	public var selectedItemColor: UIColor = .white
	/// Коэффициент, определяющий как меняется размер текущего элемента относительно остальных.
	/// Например, значение 2.0 означает, что выделенный элемент будет в 2 раза больше остальных элементов.
	public var selectedItemScaleFactor: CGFloat = 1.5
	/// Диаметр элементов
	public var itemDiameter: CGFloat = 10
	/// Количество элементов, которые одновременно помещяются в контрол
	public var visibleItemsCount: Int = 7

	/// Общее количество элементов в карусели
	public var itemsCount: Int = 10 {
		didSet {
			if oldValue != self.itemsCount {
				self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.sideOffset, bottom: 0, right: self.sideOffset)
				self.collectionView.reloadData()
			}
		}
	}

	/// Отступ между соседними элементами
	public var itemsOffset: CGFloat = 5 {
		didSet {
			self.collectionViewLayout.minimumLineSpacing = self.itemsOffset
		}
	}

	/// Индекс текущего элемента
	public var selectedItemIndex: Int = 0 {
		didSet {
			if oldValue != self.selectedItemIndex {
				self.updateSelectedItem()
			}
		}
	}

	public override var intrinsicContentSize: CGSize {
		let width = self.itemDiameter * CGFloat(self.visibleItemsCount) + self.itemsOffset * CGFloat(self.visibleItemsCount - 1)
		let height = self.itemDiameter
		return CGSize(width: width, height: height)
	}

	private var sideOffset: CGFloat {
		let allItemsWidth = self.itemDiameter * CGFloat(self.itemsCount) + self.itemsOffset * CGFloat(self.itemsCount - 1)
		return allItemsWidth > self.intrinsicContentSize.width ? self.itemDiameter * 2 + self.itemsOffset * 2 : 0
	}

	private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 0;
		return layout
	}()

	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
		collectionView.register(CarouselProgressItemCell.self, forCellWithReuseIdentifier: "default")
		collectionView.backgroundColor = .clear
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.alwaysBounceHorizontal = true
		collectionView.contentInset = UIEdgeInsets(top: 0, left: self.sideOffset, bottom: 0, right: self.sideOffset)
		collectionView.dataSource = self
		collectionView.delegate = self
		return collectionView
	}()

	private var firstCellLoaded: Bool = false

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.isUserInteractionEnabled = false
		self.addSubview(self.collectionView)
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()

		self.collectionView.frame = self.bounds
	}

	private func updateSelectedItem() {
		self.updateScrollPosition()
		self.updateSelection()
	}

	private func updateScrollPosition() {
		guard self.selectedItemIndex >= 0 && self.selectedItemIndex < self.itemsCount else { return }
		// Этот метод прокручивает карусель таким образом, чтобы выделенная ячейка оказалась
		// в области видимости и при этом ни одна ячейка не обрезалась границами карусели
		let path = IndexPath(row: self.selectedItemIndex, section: 0)
		if let cell = self.collectionView.cellForItem(at: path) {
			// Это фрейм в который должна попасть выделенная ячейка
			let targetFrame = CGRect(x: self.sideOffset, y: 0, width: self.bounds.width - (self.sideOffset * 2), height: self.bounds.height)
			let cellCenter = cell.superview!.convert(cell.center, to: self)
			let cellFrame = cell.superview!.convert(cell.frame, to: self)
			if !targetFrame.contains(cellCenter) {
				if cellCenter.x > targetFrame.maxX {
					let dif = cellFrame.maxX - targetFrame.maxX
					let offset = CGPoint(x: self.collectionView.contentOffset.x + dif, y: self.collectionView.contentOffset.y)
					self.collectionView.setContentOffset(offset, animated: true)
				} else if cellCenter.x < targetFrame.minX {
					let dif = targetFrame.minX - cellFrame.minX
					let offset = CGPoint(x: self.collectionView.contentOffset.x - dif, y: self.collectionView.contentOffset.y)
					self.collectionView.setContentOffset(offset, animated: true)
				}
			}
		} else {
			// Что-то пошло не так, ну, прокрутим хоть как-нибудь
			self.collectionView.scrollToItem(at: path, at: .right, animated: false)
		}
	}

	private func updateSelection() {
		guard self.selectedItemIndex >= 0 && self.selectedItemIndex < self.itemsCount else { return }
		let path = IndexPath(row: self.selectedItemIndex, section: 0)
		let cell = self.collectionView.cellForItem(at: path) as? CarouselProgressItemCell
		self.collectionView.visibleCells
			.filter { $0 !== cell }
			.forEach { $0.isSelected = false }
		cell?.isSelected = true
	}
}

extension CarouselProgressControl {

	private func updateScaleFactor(for cell: CarouselProgressItemCell) {
		guard self.sideOffset != 0 else { return }
		let center = cell.superview!.convert(cell.center, to: self)
		var x = center.x
		if x < self.sideOffset {
			cell.scaleFactor = x / self.sideOffset
		} else if x > self.bounds.width - self.sideOffset {
			x = self.bounds.width - x
			cell.scaleFactor = x / self.sideOffset
		} else {
			cell.scaleFactor = 1
		}
	}

	private func updateCell(_ cell: CarouselProgressItemCell, indexPath: IndexPath) {
		cell.itemColor = self.itemColor
		cell.selectedItemColor = self.selectedItemColor
		cell.scaleFactor = 1
		cell.selectedItemScaleFactor = self.selectedItemScaleFactor
		cell.isSelected = indexPath.row == self.selectedItemIndex
	}
}

extension CarouselProgressControl : UICollectionViewDataSource {

	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.itemsCount
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if !self.firstCellLoaded {
			self.firstCellLoaded = true
			self.updateScrollPosition()
		}
		let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
		if let cell = cell as? CarouselProgressItemCell {
			self.updateCell(cell, indexPath: indexPath)
		}
		return cell
	}

	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let cell = cell as? CarouselProgressItemCell {
			self.updateCell(cell, indexPath: indexPath)
			self.updateScaleFactor(for: cell)
		}
	}
}

extension CarouselProgressControl : UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.itemDiameter, height: self.itemDiameter)
	}

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let cells = self.collectionView.visibleCells.compactMap { $0 as? CarouselProgressItemCell }
		for cell in cells {
			self.updateScaleFactor(for: cell)
		}
	}

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let allItemsWidth = self.itemDiameter * CGFloat(self.itemsCount) + self.itemsOffset * CGFloat(self.itemsCount - 1)
		let leftInset = max((collectionView.frame.width - allItemsWidth) / 2, 0)
		let rightInset = leftInset
		return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
	}
}

