//  Created by Michal Ciurus

import UIKit
import BlockstackLogic
import Kingfisher
import SharedTools

enum NameInfoViewControllerConstants {
    static let cellIdentifier = "NameHistoryCell"
}

class NameInfoViewController: PoppableViewController, InjectableInteractor {
    
    typealias C = NameInfoViewControllerConstants
    
    //MARK: Private Properties
    
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.text = interactor.name
        }
    }
    @IBOutlet weak var twitterButton: UIButton! {
        didSet {
            twitterButton.alpha = 0.5
            twitterButton.isEnabled = false
        }
    }
    @IBOutlet private weak var historyTitle: UILabel! {
        didSet {
            historyTitle.isHidden = true
        }
    }
    @IBOutlet private weak var historyTableView: UITableView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    private var dataSource: TableViewDataSource<UITableViewCell, NameHistoryPresenter>?
    
    //MARK: Public Properties
    
    var interactor: NameInfoInteractor!
    
    //MARK: Public Methods
    
    func inject(_ interactor: NameInfoInteractor) {
        self.interactor = interactor
    }
    
    override func viewDidLoad() {
        assertDependency()
        setupObservers()
        interactor.fetchInfo()
        subscribeTo(errorEmitter: interactor.presenter)
        setupTableView()
    }
    
}

private extension NameInfoViewController {
    
    @IBAction func didTapTwitter(_ sender: Any) {
        guard let urlString = interactor.presenter.profile.value?.twitterUrl, let twitterUrl = URL(string: urlString) else { return }
        UIApplication.shared.open(twitterUrl, options: [ : ], completionHandler: nil)
    }
    
    func setupTableView() {
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: C.cellIdentifier)
        dataSource = TableViewDataSource<UITableViewCell, NameHistoryPresenter>(cellIdentifier: C.cellIdentifier, observable: interactor.presenter.nameHistory) { cell, presenter in
            cell.textLabel?.text = presenter.operationLabel
            return cell
        }
        historyTableView.dataSource = dataSource
        historyTableView.tableFooterView = UIView()
    }
    
    func setupObservers() {
        
        interactor.presenter.nameHistory.observe { [weak self] _ in
            self?.historyTableView.reloadData()
            let historyCount = self?.interactor.presenter.nameHistory.value?.count ?? 0
            self?.historyTitle.isHidden = historyCount == 0
        }
        
        interactor.presenter.profile.observe { [weak self] profilePresenter in
            self?.loadingIndicator.isHidden = true
            guard let profilePresenter = profilePresenter else { return }
            self?.username.text = profilePresenter.nameLabel
            self?.descriptionLabel.text = profilePresenter.descriptionLabel
            self?.name.text = profilePresenter.blockstackNameLabel
            self?.profileImage.kf.indicatorType = IndicatorType.activity
            
            let twitterUrl = profilePresenter.twitterUrl
            
            self?.twitterButton.isEnabled = twitterUrl != nil
            self?.twitterButton.alpha = twitterUrl != nil ? 1.0 : 0.5
            guard let imageUrl = profilePresenter.imageUrl else { return }
            self?.profileImage.kf.setImage(with: URL(string: imageUrl),  options:[.transition(ImageTransition.fade(1))])
        }
    }
    
}
