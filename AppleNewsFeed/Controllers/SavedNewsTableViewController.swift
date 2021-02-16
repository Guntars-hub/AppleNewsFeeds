//
//  SavedNewsTableViewController.swift
//  AplleNewsFeed
//
//  Created by Arkadijs Makarenko on 15/02/2021.
//

import UIKit
import CoreData


class SavedNewsTableViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        //load
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //load
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do{
            savedItems = try (context?.fetch(request))!
        }catch{
            //alert
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    #warning("//saveData()")
    //saveData()
    func saveData(){
        do {
            try self.context?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        //loadData()
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }

        let item = savedItems[indexPath.row]
        
        if let image = UIImage(data: item.image!){
            cell.newsImageView.image = image
        }
        
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0

        return cell
    }
    
    #warning("//height")
    //height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //
    

    
    // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
      let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete?", preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
          
          let item = self.savedItems[indexPath.row]
          
          self.context?.delete(item)
          self.saveData()
          
          
      }))
      self.present(alert, animated: true)
  }
}
 
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     let currentTrack = savedItems.remove(at: fromIndexPath.row)
     savedItems.insert(currentTrack, at: to.row)
 }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    #warning("//didSelectatrowat")
//didSelectatrowat
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(identifier: "webViewController")  as? WebViewController else {
            return
        }
        vc.urlString = savedItems[indexPath.row].url ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
