import Foundation

final class NewsPresenter: NewsPresenterProtocol {
    private weak var view: NewsViewProtocol?
    private let interactor: NewsInteractorProtocol
    private let router: NewsRouterProtocol
    
    init(
        view: NewsViewProtocol,
        interactor: NewsInteractorProtocol,
        router: NewsRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.fetchArticles()
        
        // Симулируем задержку, чтобы показать, как обновляем данные
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            self.view?.hideLoadingIndicator()
            self.view?.showArticles(self.interactor.articles)
        }
    }
    
    func didSelectArticle(at index: Int) {
        let articles = interactor.articles
        guard index < articles.count else { return }
        let article = articles[index]
        router.showDetail(for: article)
    }
}
