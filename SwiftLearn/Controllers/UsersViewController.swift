import UIKit
import RxSwift
import RxDataSources

class UsersViewController: UIViewController, UITableViewDelegate {

    private var viewModel = UsersViewModel()
    private var disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tv.rowHeight = 60
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshUsers(_:)), for: .valueChanged)
        tv.refreshControl = refreshControl
        return tv
    }()

    @objc private func refreshUsers(_ sender: Any) {
        viewModel.fetchUsers(refreshControl: tableView.refreshControl)
    }

    @objc func onTapAdd() {
        navigationController?.pushViewController(AddUserViewController(), animated: false)
    }

    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>> { _, tv, indexPath, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.name.text = item.name
            cell.avatar.downloaded(from: item.avatar)
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            dataSource[sectionIndex].model
        }
        viewModel.users.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Users"
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        navigationItem.rightBarButtonItem = add
        view.addSubview(tableView)
        tableView.frame = view.frame
        viewModel.fetchUsers(refreshControl: tableView.refreshControl)
        bindTableView()
    }
}

