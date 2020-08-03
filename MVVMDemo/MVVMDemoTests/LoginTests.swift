
import XCTest
@testable import MVVMDemo

class LoginTests: XCTestCase {
    
    var validUserViewModel: UserViewModel!
    var invalidUserViewModel: UserViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = User(username: "dattpatel", password: "swift")
        validUserViewModel = UserViewModel(user: user)
        
        invalidUserViewModel = UserViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testUsername() {
        XCTAssertEqual(validUserViewModel.username.value, "dattpatel")
    }
    
    func testPassword() {
        XCTAssertEqual(validUserViewModel.password.value, "swift")
    }
    
    func testProtectedUsernameLong() {
        XCTAssertEqual(validUserViewModel.protectedUsername, "******tel")
    }
    
    func testProtectedUsernameShort() {
        validUserViewModel = UserViewModel(user: User(username: "dp", password: "swift"))
        XCTAssertEqual(validUserViewModel.protectedUsername, "dp")
    }
    
    func testUpdateUsername() {
        validUserViewModel.updateUsername("aaamsha")
        XCTAssertEqual(validUserViewModel.username.value, "aaamsha")
    }
    
    func testUpdatePassword() {
        validUserViewModel.updatePassword("vicki")
        XCTAssertEqual(validUserViewModel.password.value, "vicki")
    }
    
    func testValidateNoUserOrPassword() {
        let validation = invalidUserViewModel.validate()
        
        if case .Invalid(let message) = validation {
            XCTAssertEqual(message, "Username and password are required.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateNoPassword() {
        invalidUserViewModel = UserViewModel(user: User(username: "dattpatel", password: ""))
        let validation = invalidUserViewModel.validate()
        
        if case .Invalid(let message) = validation {
            XCTAssertEqual(message, "Username and password are required.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateShortUsername() {
        invalidUserViewModel = UserViewModel(user: User(username: "dp", password: "swift"))
        let validation = invalidUserViewModel.validate()
        
        if case .Invalid(let message) = validation {
            XCTAssertEqual(message, "Username needs to be at least 4 characters long.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateShortPassword() {
        invalidUserViewModel = UserViewModel(user: User(username: "dattpatel", password: "sw"))
        let validation = invalidUserViewModel.validate()
        
        if case .Invalid(let message) = validation {
            XCTAssertEqual(message, "Password needs to be at least 5 characters long.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateValidUser() {
        let validation = validUserViewModel.validate()
        
        if case .Valid = validation {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testLoginSuccess() {
        validUserViewModel.login { errorString in
            XCTAssert(errorString == nil)
        }
    }
    
    func testLoginFailure() {
        invalidUserViewModel.login { errorString in
            XCTAssertEqual(errorString, "Invalid credentials.")
        }
    }
}

