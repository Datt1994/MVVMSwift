

import Foundation

enum UserValidationState {
    case Valid
    case Invalid(String)
}

class UserViewModel {
    private let minUsernameLength = 4
    private let minPasswordLength = 5
    private let codeRefreshTime = 5.0
    private var user = User() {
        didSet {
            username.value = user.username
            password.value = user.password
        }
    }
    
    var username: Box<String> = Box("")
    
    var password: Box<String> = Box("")
    
    var protectedUsername: String {
        let characters = username.value
        
        if characters.count >= minUsernameLength {
            var displayName = [Character]()
            for (index, character) in characters.enumerated() {
                if index > characters.count - minUsernameLength {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }
        
        return characters
    }
    
    var accessCode: Box<String?> = Box(nil)
    
    init(user: User = User()) {
        self.user = user
        username.value = user.username
        password.value = user.password
        startAccessCodeTimer()
    }
}

// MARK: Public Methods
extension UserViewModel {
    func updateUsername(_ username: String) {
        user.username = username
    }
    
    func updatePassword(_ password: String) {
        user.password = password
    }
    
    func validate() -> UserValidationState {
        if user.username.isEmpty || user.password.isEmpty {
            return .Invalid("Username and password are required.")
        }
        
        if user.username.count < minUsernameLength {
            return .Invalid("Username needs to be at least \(minUsernameLength) characters long.")
        }
        
        if user.password.count < minPasswordLength {
            return .Invalid("Password needs to be at least \(minPasswordLength) characters long.")
        }
        
        return .Valid
    }
    
    func login(completion: (_ errorString: String?) -> Void) {
        LoginService.loginWithUsername(user.username, password: user.password) { success in
            if success {
                completion(nil)
            } else {
                completion("Invalid credentials.")
            }
        }
    }
}

// MARK: - Private Methods
private extension UserViewModel {
    func startAccessCodeTimer() {
        accessCode.value = LoginService.generateAccessCode()
        
        dispatchAfter(codeRefreshTime) { [weak self] in 
            self?.startAccessCodeTimer()
        }
    }
}
