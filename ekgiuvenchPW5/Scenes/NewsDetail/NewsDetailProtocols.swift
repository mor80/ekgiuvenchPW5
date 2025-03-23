import Foundation

protocol NewsDetailViewProtocol: AnyObject {
    func loadURL(_ url: URL)
}

protocol NewsDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol NewsDetailInteractorProtocol: AnyObject {
    var article: Article? { get }
}

protocol NewsDetailRouterProtocol: AnyObject {
}
