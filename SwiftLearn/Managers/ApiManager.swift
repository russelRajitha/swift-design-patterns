import Foundation

struct Constants {
    static let baseURL = "http://localhost:2500"
}

struct APIError: Error {
    var message: String?
    var errors: [String: [String]]?

    init(message: String?, errors: [String: [String]]?) {
        self.errors = errors
        self.errors = errors
    }
}

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case FILE
    case DELETE
}

class ApiManager {
    static let shared = ApiManager()

    private func createRequest(with url: String?, type: HTTPMethod, params: [String: String]?, files: [String: Data]?, completion: @escaping (URLRequest) -> Void) {
        var request = URLRequest(url: URL(string: Constants.baseURL + (url ?? ""))!)
        switch (type) {
            case .FILE:
                request.httpMethod = HTTPMethod.POST.rawValue
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let httpBody = NSMutableData()
                if let attachments = files {
                    for (index, item) in attachments {
                        httpBody.append(FileHelpers.convertFileData(fieldName: index,
                                fileName: "imagename-\(index).png",
                                mimeType: "image/png",
                                fileData: item,
                                using: boundary))
                    }
                }
                if let fields = params {
                    for (key, value) in fields {
                        httpBody.appendString(FileHelpers.convertFormField(named: key, value: value, using: boundary))
                    }
                }
                httpBody.appendString("--\(boundary)--")
                request.httpBody = httpBody as Data
                break
            default:
                request.httpMethod = type.rawValue
                break
        }
        request.timeoutInterval = 30
        completion(request)
    }

    public func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        createRequest(with: "/users", type: .GET, params: nil, files: nil) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError(message: error?.localizedDescription, errors: nil)))
                    return
                }
                let u = BaseResponse.parseResponse([User].self, response: data)
                guard let u = u, u.status == "success" else {
                    completion(.failure(APIError(message: u?.message, errors: u?.errors)))
                    return
                }
                completion(.success(u.data))
            }
            task.resume()
        }
    }

    public func createUser(imageData: Data, imageDataFieldName: [String], formFields: [String: String], completion: @escaping (Result<BaseObjectType, APIError>) -> Void) {
        createRequest(with: "/user", type: .FILE, params: formFields, files: ["avatar": imageData]) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError(message: nil, errors: nil)))
                    return
                }
                let u = BaseResponse.parseResponse(BaseObjectType.self, response: data)
                guard let u = u, u.status == "success" else {
                    completion(.failure(APIError(message: nil, errors: nil)))
                    return
                }
                completion(.success(u.data))
            }
            task.resume()
        }

    }
}
