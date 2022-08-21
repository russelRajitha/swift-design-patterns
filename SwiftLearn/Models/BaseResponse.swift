import Foundation

struct BaseResponse<DataType: Codable>: Codable {
    let message: String
    let status: String
    let data: DataType
    let errors: [String: [String]]

    static func parseResponse(_ dynamicType: DataType.Type, response: Data) -> BaseResponse? {
        do {
            let responseData = try JSONDecoder().decode(BaseResponse.self, from: response)
            return responseData
        } catch {
            return nil
        }
    }
}

struct BaseObjectType: Codable {

}

struct Errors: Codable {

}


