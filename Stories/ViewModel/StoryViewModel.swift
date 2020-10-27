import UIKit

struct StoryViewModel {
    let id: String
    let title: String
    let author: String
    let coverImage: String
    
    init(story: Story) {
        self.id = story.id
        self.title = story.title
        self.coverImage = story.cover
        
        if (story.user.name != "") {
            author = "By \(story.user.name)"
        } else {
            author = "Unknown author"
        }
    }
}
