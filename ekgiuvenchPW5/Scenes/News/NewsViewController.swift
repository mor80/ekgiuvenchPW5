import UIKit

final class NewsViewController: UIViewController, NewsViewProtocol {
    var presenter: NewsPresenterProtocol!
    
    private let tableView = UITableView()
    private var articles: [Article] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Новости"
        
        setupTableView()
        setupActivityIndicator()
        
        presenter.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    // MARK: - NewsViewProtocol
    func showArticles(_ articles: [Article]) {
        self.articles = articles
        tableView.reloadData()
    }
    
    func showError(_ error: String) {
        print("Error: \(error)")
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        let article = articles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectArticle(at: indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] _, _, completion in
            guard let self else { return }
            let article = self.articles[indexPath.row]
            let shareText = article.articleUrl?.absoluteString ?? "No link"
            let activityVC = UIActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
            self.present(activityVC, animated: true)
            completion(true)
        }
        shareAction.backgroundColor = .systemBlue
        
        let config = UISwipeActionsConfiguration(actions: [shareAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
