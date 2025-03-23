import UIKit

final class NewsRouter: NewsRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let router = NewsRouter()
        let view = NewsViewController()
        let interactor = NewsInteractor()
        let presenter = NewsPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func showDetail(for article: Article) {
        let detailModule = NewsDetailRouter.createModule(article: article)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
}
