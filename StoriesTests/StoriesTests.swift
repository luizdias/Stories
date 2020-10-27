import XCTest
@testable import Stories

class StoriesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStoryViewModel() {
        let user = User(name: "Test User", avatar: "", fullname: "User Full Name")
        let story = Story(id: "0", title: "Sample Title" , cover: "", user: user)
        let storyViewModel = StoryViewModel(story: story)
        
        XCTAssertEqual(story.title, storyViewModel.title)
        XCTAssertEqual("By \(story.user.name)", storyViewModel.author)
    }
    
    func testStoryViewModelForEmptyAuthor() {
        let user = User(name: "", avatar: "", fullname: "")
        let story = Story(id: "0", title: "Sample Title" , cover: "", user: user)
        let storyViewModel = StoryViewModel(story: story)
        
        XCTAssertEqual(story.title, storyViewModel.title)
        XCTAssertEqual("Unknown author", storyViewModel.author)
    }
    
}
