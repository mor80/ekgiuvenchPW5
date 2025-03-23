import Foundation

struct SeldonNewsEndpoint: Endpoint {
    var path: String
    var rubricId: String
    var pageSize: String
    var pageIndex: String
    
    var compositePath: String {
        return path
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json"]
    }
    
    var paremetrs: [String : String]? {
        [
            "rubricId": rubricId,
            "pageSize": pageSize,
            "pageIndex": pageIndex
        ]
    }
}
