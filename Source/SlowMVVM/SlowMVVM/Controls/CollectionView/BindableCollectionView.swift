import Foundation
import SlowCommon

public class BindableCollectionView : UIView {

	public let collection: UICollectionView
	public var templateSelector: ICellTemplateSelector = DefaultCellTemplateSelector()

	public var dataSource: IDataSource? {
		didSet {
			self.unsubscribe(from: oldValue)
			self.subscribe(to: self.dataSource)
			self.collection.reloadData()
		}
	}

	public let firstCellWillLoad: Event<Void> = Event()

	private var registeredTemplates: Set<AnyCellTemplate> = []
	private var isFirstCellLoaded: Bool = false

	public init(layout: UICollectionViewLayout) {
		self.collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		super.init(frame: .zero)
		self.backgroundColor = .clear
		self.collection.dataSource = self
		self.collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
		self.addSubview(self.collection)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.collection.frame = self.bounds
	}

	private func unsubscribe(from dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }
		dataSource.reloaded.unsubscribe(self)
	}

	private func subscribe(to dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }
		dataSource.reloaded.subscribe(self) {
			this in
			this.collection.reloadData()
		}
	}
}

extension BindableCollectionView : UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dataSource?.count ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		self.riseFirstCellWillLoadIfNeeded()
		if let dataSource = self.dataSource, let item = dataSource.item(at: indexPath.row) {
			if let template = self.templateSelector.template(for: item) {
				self.registerIfNeeded(template, in: collectionView)
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: template.reuseIdentifier, for: indexPath)
				if var cell = cell as? IHaveViewModel {
					cell.viewModelObject = item as? ViewModelBase
				}
				return cell
			}
		}
		return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
	}

	private func riseFirstCellWillLoadIfNeeded() {
		if !self.isFirstCellLoaded {
			self.isFirstCellLoaded = true
			self.firstCellWillLoad.raise()
		}
	}

	private func registerIfNeeded(_ template: AnyCellTemplate, in collectionView: UICollectionView) {
		guard !self.registeredTemplates.contains(template) else { return }
		template.register(in: collectionView)
		self.registeredTemplates.insert(template)
	}

}
