import UIKit
import SDWebImage

class StoriesController: UITableViewController {
    
    var storyViewModels = [StoryViewModel]()
    let cellId = "StoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        fetchData()
    }
    
    fileprivate func fetchData() {        
        DataManager.shared.fetchStories { (stories, isOfflineMode, error) in
            if let error = error {
                print("Failed to fetch stories:", error)
                self.showNoStoriesForOfflineModeAlert()
                return
            }
            
            self.storyViewModels = stories?.map({return StoryViewModel(story: $0)}) ?? []
            if isOfflineMode {
                self.navigationItem.title = "Saved Stories"
            } else {
                self.navigationItem.title = "Stories"
            }
            self.tableView.reloadData()
        }
    }
    
    func showNoStoriesForOfflineModeAlert() {
        let alert = UIAlertController(title: "Ops!", message: "Connect to internet to save some Stories for offline mode.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StoryCell
        let storyViewModel = storyViewModels[indexPath.row]
        cell.title.text = storyViewModel.title
        cell.author.text = storyViewModel.author
        let placeholderImage = UIImage.init(named: "Placeholder")
        cell.coverImage!.sd_setImage(with: URL(string: storyViewModel.coverImage), placeholderImage: placeholderImage)
        
        return cell
    }
    
    fileprivate func setupTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = UIColor.lightGray
        tableView.backgroundColor = .wattpadDefaultColor
        tableView.rowHeight = 200
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Stories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .wattpadDefaultColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .wattpadDefaultColor
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.mainTextColor]
        navigationController?.navigationBar.titleTextAttributes =  [.foregroundColor: UIColor.white]
    }
    
}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
