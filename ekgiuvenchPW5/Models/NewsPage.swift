import UIKit
import Foundation

struct NewsPage: Decodable {
    var news: [Article]?
    var requestId: String?
    
    init() {
    }
    
    init(news: [Article]?, requestId: String?) {
        self.news = news?.map { article in
            var article = article
            article.requestId = requestId
            return article
        }
        self.requestId = requestId
    }
}
