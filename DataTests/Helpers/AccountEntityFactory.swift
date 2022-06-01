import Foundation
import Domain

func makeAccountEntity() -> AccountEntity {
    return AccountEntity(
        id: "any_id",
        name: "any_name",
        email: "any_email", 
        password: "any_password"
    )
}

