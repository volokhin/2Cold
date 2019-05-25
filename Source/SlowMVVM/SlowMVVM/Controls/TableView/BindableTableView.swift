import Foundation
import SlowCommon

public class BindableTableView : UIView {

	public let table: UITableView = UITableView(frame: .zero, style: .plain)
	public var templateSelector: ICellTemplateSelector = DefaultCellTemplateSelector()

	public var dataSource: IDataSource? {
		didSet {
			self.unsubscribe(from: oldValue)
			self.subscribe(to: self.dataSource)
			self.table.reloadData()
		}
	}

	public let scrollViewDidScroll: Event<UIScrollView> = Event()

	private var registeredTemplates: Set<AnyCellTemplate> = []

	public init() {
		super.init(frame: .zero)
		self.table.dataSource = self
		self.table.delegate = self
		self.table.register(UITableViewCell.self, forCellReuseIdentifier: "default")
		self.addSubview(self.table)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.table.frame = self.bounds
	}

	private func unsubscribe(from dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }
		dataSource.reloaded.unsubscribe(self)
	}

	private func subscribe(to dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }
		dataSource.reloaded.subscribe(self) {
			this in
			this.table.reloadData()
		}
	}
}

extension BindableTableView : UITableViewDataSource {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource?.count ?? 0
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let dataSource = self.dataSource, let item = dataSource.item(at: indexPath.row) {
			if let template = self.templateSelector.template(for: item) {
				self.registerIfNeeded(template, in: tableView)
				let cell = tableView.dequeueReusableCell(withIdentifier: template.reuseIdentifier, for: indexPath)
				if var cell = cell as? IHaveViewModel {
					cell.viewModelObject = item as? ViewModelBase
				}
				return cell
			}
		}
		return tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
	}

	private func registerIfNeeded(_ template: AnyCellTemplate, in tableView: UITableView) {
		guard !self.registeredTemplates.contains(template) else { return }
		template.register(in: tableView)
		self.registeredTemplates.insert(template)
	}

}

extension BindableTableView : UITableViewDelegate {

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let dataSource = self.dataSource, let item = dataSource.item(at: indexPath.row) {
			(item as? CellViewModelBase)?.didSelect()
		}
	}

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.scrollViewDidScroll.raise(scrollView)
	}

}
