//
//  SearchAppResultsViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/20.
//

import UIKit

protocol SearchAppResultsViewDelegate: AnyObject {
    
    func pushAppDetailView(_ appDetail: AppDetail)
    
}

private enum SearhKeywordSaving {
    
    case active
    case deactive
    
}

final class SearchAppResultsViewController: UITableViewController {
    
    weak var delegate: SearchAppResultsViewDelegate?
    
    private let searchKeywordTableHeaderView = SearchKeywordTableHeaderView()
    private let searchKeywordTableFooterView = SearchKeywordTableFooterView()
    
    private let searchKeywordTableHeaderViewModel = SearchKeywordTableHeaderViewModel()
    private let searchKeywordTableFooterViewModel = SearchKeywordTableFooterViewModel()
    private var searchAppResultsViewModel: SearchAppResultsTableViewModel
    private var recentSearchKeywordViewModel = {
        let searchKeywordRepository = RealmSearchKeywordRepository()
        let viewModel = RecentSearchKeywordTableViewModel(
            recentSearchKeywordUsecase: .init(searchKeywordRepository: searchKeywordRepository),
            appSearchUsecase: .init(searchKeywordRepository: searchKeywordRepository))
        return viewModel
    }()
    
    private var searchKeywordSaving: SearhKeywordSaving {
        return recentSearchKeywordViewModel.isActivateSavingButton ? .active : .deactive
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SearchAppResultsTableViewModel) {
        self.searchAppResultsViewModel = viewModel
        super.init(style: .plain)
    }
    
    func showRecentSearchKeywordTableView() {
        tableView.dataSource = recentSearchKeywordViewModel
        tableView.delegate = recentSearchKeywordViewModel
        refreshSearchKeywordTableView()
    }
    
    func refreshSearchKeywordTableView() {
        Task {
            await recentSearchKeywordViewModel.fetchLatestData()
            await MainActor.run(body: {
                self.tableView.tableHeaderView?.isHidden = false
                switch self.searchKeywordSaving {
                case .active:
                    self.tableView.tableFooterView?.isHidden = false
                case .deactive:
                    self.tableView.tableFooterView?.isHidden = true
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func scrollToTop() {
        guard tableView.numberOfRows(inSection: 0) != 0 else {
            return
        }
        
        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
    }
    
    private func configureView() {
        view.backgroundColor = Design.backgroundColor
    }
    
    private func configureTableView() {
        tableView.register(cellWithClass: SearchAppTableViewCell.self)
        tableView.register(cellWithClass: RecentSearchKeywordTableViewCell.self)
        
        searchAppResultsViewModel.appDetailViewPresenter = self
        recentSearchKeywordViewModel.appDetailViewPresenter = self
        recentSearchKeywordViewModel.searchAppResultTableViewUpdater = self
        
        searchKeywordTableHeaderView.frame = .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: 75))
        tableView.tableHeaderView = searchKeywordTableHeaderView
        searchKeywordTableHeaderView.recentKeywordSavingUpdater = self
        searchKeywordTableHeaderView.bind(searchKeywordTableHeaderViewModel)
        
        searchKeywordTableFooterView.frame = .init(
            origin: .zero,
            size: .init(width: view.bounds.width, height: 60))
        tableView.tableFooterView = searchKeywordTableFooterView
        searchKeywordTableFooterView.searchKeywordTableViewUpdater = self
        searchKeywordTableFooterView.bind(searchKeywordTableFooterViewModel)
    }
    
}

extension SearchAppResultsViewController: AppDetailViewPresenter {
    
    func pushAppDetailView(of app: AppDetail) {
        delegate?.pushAppDetailView(app)
    }
    
}

extension SearchAppResultsViewController: SearchAppResultTableViewUpdater {
    
    func updateSearchAppResultTableView(with searchApps: [AppDetail]) {
        hideFooterAndHeaderView()
        scrollToTop()
        searchAppResultsViewModel = SearchAppResultsTableViewModel(
            searchAppDetails: searchApps)
        searchAppResultsViewModel.appDetailViewPresenter = self
        tableView.dataSource = searchAppResultsViewModel
        tableView.delegate = searchAppResultsViewModel
        tableView.reloadData()
    }
    
    private func hideFooterAndHeaderView() {
        tableView.tableHeaderView?.isHidden = true
        tableView.tableFooterView?.isHidden = true
    }
    
    func presentAlert(_ alertViewModel: AlertViewModel) {
        let alertController = UIAlertController(
            title: alertViewModel.alertController.title,
            message: alertViewModel.alertController.message,
            preferredStyle: alertViewModel.alertController.preferredStyle.value)
        if let alertActions = alertViewModel.alertActions {
            alertActions.forEach { actionViewModel in
                let action = UIAlertAction(
                    title: actionViewModel.title,
                    style: actionViewModel.style.value)
                alertController.addAction(action)
            }
        }
        
        present(alertController, animated: false)
    }
    
}

extension SearchAppResultsViewController: SearchKeywordSavingUpdater {
    
    func didChangedVaule(to isOn: Bool) {
        refreshSearchKeywordTableView()
    }
    
}

extension SearchAppResultsViewController: SearchKeywordTableViewUpdater {
    
    func allSearchKeywordDidDeleted() {
        refreshSearchKeywordTableView()
    }
    
}

private enum Design {
    
    static let backgroundColor: UIColor = .systemBackground
    
}

