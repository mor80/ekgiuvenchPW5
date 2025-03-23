import UIKit

final class NewsDetailRouter: NewsDetailRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(article: Article) -> UIViewController {
        let router = NewsDetailRouter()
        let interactor = NewsDetailInteractor(article: article)
        let view = NewsDetailViewController()
        let presenter = NewsDetailPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}
