import Foundation

final class NewsInteractor: NewsInteractorProtocol, NewsDataStore {

    // MARK: - Constants
    private enum Constants {
        static let baseURL = "https://news.myseldon.com"
        static let endpointPath = "/api/Section"
        static let rubricId = "4"
        static let pageSize = "10"
        static let pageIndex = "1"
    }

    private let networkWorker: NetworkingLogic
    var articles: [Article] = []

    init() {
        self.networkWorker = BaseURLWorker(baseURL: Constants.baseURL)
    }

    func fetchArticles() {
        let endpoint = SeldonNewsEndpoint(
            path: Constants.endpointPath,
            rubricId: Constants.rubricId,
            pageSize: Constants.pageSize,
            pageIndex: Constants.pageIndex
        )

        let request = Request(endpoint: endpoint, method: .get)

        networkWorker.execute(with: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Ошибка сети: \(error.localizedDescription)")
            case .success(let serverResponse):
                guard let data = serverResponse.data else { return }
                do {
                    let newsPage = try JSONDecoder().decode(NewsPage.self, from: data)
                    let articles = newsPage.news ?? []
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
