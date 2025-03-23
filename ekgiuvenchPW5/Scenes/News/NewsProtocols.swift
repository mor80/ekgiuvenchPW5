import UIKit

// MARK: - View
protocol NewsViewProtocol: AnyObject {
    func showArticles(_ articles: [Article])
    func showError(_ error: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

// MARK: - Presenter
protocol NewsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectArticle(at index: Int)
}

// MARK: - Interactor
protocol NewsInteractorProtocol: AnyObject {
    func fetchArticles()
    var articles: [Article] { get }
}

protocol NewsDataStore {
    var articles: [Article] { get set }
}

// MARK: - Router
protocol NewsRouterProtocol: AnyObject {
    func showDetail(for article: Article)
}
