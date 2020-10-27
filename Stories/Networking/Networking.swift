import Foundation

class Networking: NSObject {
static let shared = Networking()
    
    func fetchStories(completion: @escaping (Data?, Error?) -> ()) {
        let urlString = "https://www.wattpad.com/api/v3/stories?offset=0&limit=10&fields=stories(id,title,cover,user)&filter=new"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            if let error = error {
                completion(nil, error)
                print("Failed to fetch stories:", error)
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }.resume()
    }
}
