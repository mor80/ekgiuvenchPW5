import Foundation

final class NewsInteractor: NewsInteractorProtocol, NewsDataStore {
    private let networkWorker: NetworkingLogic
    
    var articles: [Article] = []
    
    init() {
        self.networkWorker = BaseURLWorker(baseURL: "https://news.myseldon.com")
    }
    
    func fetchArticles() {
        let endpoint = SeldonNewsEndpoint(
            path: "/api/Section",
            rubricId: "4", // или другой
            pageSize: "10",
            pageIndex: "1"
        )
        
        let request = Request(
            endpoint: endpoint,
            method: .get
        )
        
        networkWorker.execute(with: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Ошибка сети: \(error.localizedDescription)")
            case .success(let serverResponse):
                guard let data = serverResponse.data else { return }
                do {
                    // Парсим NewsPage
                    let newsPage = try JSONDecoder().decode(NewsPage.self, from: data)
                    let articles = newsPage.news ?? []
                    // Записываем в self.articles
                    DispatchQueue.main.async {
                        self?.articles = articles
                    }
                } catch {
                    print("Ошибка парсинга: \(error.localizedDescription)")
                }
            }
        }
    }
}
