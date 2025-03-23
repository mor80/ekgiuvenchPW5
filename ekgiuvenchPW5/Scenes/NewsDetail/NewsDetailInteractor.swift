import Foundation

final class NewsDetailInteractor: NewsDetailInteractorProtocol {
    var article: Article?
    
    init(article: Article) {
        self.article = article
    }
}
