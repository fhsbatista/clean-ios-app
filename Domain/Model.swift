import Foundation

public protocol DTO: Encodable {}

public extension DTO {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
