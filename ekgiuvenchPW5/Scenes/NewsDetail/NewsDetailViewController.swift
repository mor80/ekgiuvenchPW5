import UIKit
import WebKit

final class NewsDetailViewController: UIViewController, NewsDetailViewProtocol {
    
    var presenter: NewsDetailPresenterProtocol!
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Подробности"
        
        setupWebView()
        presenter.viewDidLoad()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinLeft(to: view.leadingAnchor)
        webView.pinRight(to: view.trailingAnchor)
        webView.pinBottom(to: view.bottomAnchor)
    }
    
    // MARK: - NewsDetailViewProtocol
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
