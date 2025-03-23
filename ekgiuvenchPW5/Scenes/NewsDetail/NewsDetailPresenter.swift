import Foundation

final class NewsDetailPresenter: NewsDetailPresenterProtocol {
    private weak var view: NewsDetailViewProtocol?
    private let interactor: NewsDetailInteractorProtocol
    private let router: NewsDetailRouterProtocol
    
    init(
        view: NewsDetailViewProtocol,
        interactor: NewsDetailInteractorProtocol,
        router: NewsDetailRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        guard let url = interactor.article?.articleUrl else { return }
        view?.loadURL(url)
    }
}
