
import UIKit

class RoleSelectTableViewController: UITableViewController {
    var elements = ["PikachuTwo.png","cutty.png","elephant.png","mouse.png"]
    
    @IBAction func BackPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CustomCellOne"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomCellOne
        cell.Roleimge.image = UIImage(named: elements[indexPath.row])
        
        
        
        
        
        return cell
    }
    //    func buttonClicked(sender:UIButton) {
    //        let buttonRow = sender.tag
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RoleSegue", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            
            let navigationController = segue.destination as! UINavigationController
            let MapViewController = navigationController.topViewController as! MapViewController
        MapViewController.delegate = self as? PassValueDelegate
            let aa = sender as! NSIndexPath
        
            MapViewController.imgeNameIndex = aa.row
        
        
            
            
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


