import Foundation

public protocol AddAccount {
    func add(
        data: AddAccountDTO,
        completion: @escaping (Result<AccountEntity, Error>) -> Void
    )
}

public struct AddAccountDTO {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
}
