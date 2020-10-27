import UIKit
import Reachability

class DataManager: NSObject {
    static let shared = DataManager()
    static let saveJsonKey = "pathForSavedJSON"
    let reachability = try! Reachability()
    
    func fetchStories(completion: @escaping ([Story]?, Bool, Error?) -> ()) {
        
        reachability.whenUnreachable = { _ in
            self.fetchLocalJson { (stories, error) in
                guard let stories = stories else { return }
                if stories.isEmpty {
                    completion(nil, true, error)
                } else {
                    DispatchQueue.main.async {
                        completion(stories, true, nil)
                    }
                }
            }
        }
        reachability.whenReachable = { _ in
            self.fetchFromNetworking { (stories, error) in
                guard let stories = stories else { return }
                if stories.isEmpty {
                    completion(nil, false, error)
                } else {
                    DispatchQueue.main.async {
                        completion(stories, false, nil)
                    }
                }
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func save(jsonData: Data, completion: @escaping (Error?) -> ()) {
        let cacheFileName = "results"
        do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = directory.appendingPathComponent(cacheFileName)
            try jsonData.write(to: fileURL, options: .atomic)
            let defaults = UserDefaults.standard
            defaults.set(fileURL, forKey: DataManager.saveJsonKey)
            completion(nil)
        } catch let error {
                completion(error)
        }
    }
    
    private func fetchLocalJson(completion: @escaping ([Story]?, Error?) -> ()) {
        let defaults = UserDefaults.standard
        let fileUrl = defaults.url(forKey: DataManager.saveJsonKey)
        do {
            let jsonData = try Data(contentsOf: fileUrl!, options: [])
            let results = try JSONDecoder().decode(Result.self, from: jsonData)
            let stories = results.stories
            DispatchQueue.main.async {
                completion(stories, nil)
            }
        } catch {
            print(error)
        }
    }

    private func fetchFromNetworking(completion: @escaping ([Story]?, Error?) -> ()){
        Networking.shared.fetchStories { (data, error) in
            guard let data = data else { return }
            self.save(jsonData: data) { (error) in
                if error == nil {
                    do {
                        let results = try JSONDecoder().decode(Result.self, from: data)
                        let stories = results.stories
                        DispatchQueue.main.async {
                            completion(stories, nil)
                        }
                    } catch let jsonError {
                        print("Failed to decode:", jsonError)
                    }
                }
            }
        }

    }

}
