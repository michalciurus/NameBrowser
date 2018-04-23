//  Created by Michal Ciurus

import UIKit
import BlockstackLogic
import SharedTools

class NamesListViewController: UITableViewController, Identifiable, InjectableInteractor {
    
    //MARK: Private Properties
    
    @IBOutlet private weak var bottomActivityIndicator: UIActivityIndicatorView! {
        didSet {
            bottomActivityIndicator.isHidden = !(interactor.presenter.isLoadingMore.value ?? false)
        }
    }
    
    @IBOutlet private weak var loadMoreButton: UIButton! {
        didSet {
            loadMoreButton.isHidden = !(interactor.presenter.showLoadMore.value ?? false)
        }
    }

    @IBOutlet private weak var infoLabel: UILabel!
    private var dataSource: TableViewDataSource<NamesListViewCell, String>?
    private var searchBar: UISearchBar?
    private var searchThrottleTimer: Timer?
    
    //MARK: Public Properties
    
    var interactor: NamesListInteractor!
    let routeToNameEvent = EventObservable<String>()
    
    //MARK: Public Methods

    func inject(_ interactor: NamesListInteractor) {
        self.interactor = interactor
    }
    
    override func viewDidLoad() {
        title = "Names"
        assertDependency()
        setupDatasource()
        setupObservers()
        setupSearch()
        subscribeTo(errorEmitter: interactor.presenter)
        interactor.fetchInitialNames()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        assert(dataSource != nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        interactor.willDisplay(nameIndex: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = interactor.presenter.names.value?[indexPath.row] else { fatalError("Missing name")}
        
        routeToNameEvent.fireEvent(with: name)
    }
    
}

private extension NamesListViewController {
    
    @IBAction func loadMoreTapped() {
        interactor.fetchNextPage()
    }
    
    @objc func pullToRefresh() {
        finishSearch()
        interactor.fetchInitialNames()
    }
    
    func setupObservers() {
        interactor.presenter.names.observe { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
        
        interactor.presenter.showLoadMore.observe { [weak self] show in
            guard let show = show else { return }
            self?.loadMoreButton.isHidden = !show
        }
        
        interactor.presenter.isLoadingMore.observe { [weak self] show in
            guard let show = show else { return }
            self?.bottomActivityIndicator.isHidden = !show
        }
        
        interactor.presenter.infoLabel.observe { [weak self] text in
            self?.infoLabel.text = text
        }
    }
    
    func setupSearch() {
        searchBar = UISearchController(searchResultsController: nil).searchBar
        searchBar?.delegate = self
        searchBar?.barTintColor = UIColor(white: 0.95, alpha: 1)
        searchBar?.tintColor = UIColor.blockstackVolet()
       
        tableView.tableHeaderView = searchBar
    }
    
    func setupDatasource() {
        dataSource = TableViewDataSource(cellIdentifier: NamesListViewCell.identifier, observable: interactor.presenter.names) { cell, presenter in
            cell.configure(name: presenter)
            return cell
        }
        tableView.dataSource = dataSource
    }
    
    func finishSearch() {
        searchBar?.text = nil
        searchBar?.setShowsCancelButton(false, animated: true)
        self.interactor.showAllNames()
        searchBar?.resignFirstResponder()
    }

}

extension NamesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchThrottleTimer?.invalidate()
            searchThrottleTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                self?.interactor.search(name: searchText)
                searchBar.setShowsCancelButton(true, animated: true)
            }
        } else {
            self.interactor.showAllNames()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.finishSearch()
        }
    }
    
}

