//
//  MasterViewController.swift
//  SpotlightBsp
//
//  Created by Christian Bleske on 01.03.16.
//  Copyright © 2016 Christian Bleske. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

struct Zitat {
    var text: String
    var urheber: String
}

class MasterViewController: UITableViewController {

    let zitate = [
        Zitat(text:"Heimisch in der Welt wird man nur durch Arbeit. Wer nicht arbeitet, ist heimatlos.", urheber: "Berthold Auerbach"),
        Zitat(text:"Gib blind, nimm sehend.", urheber:"Dt. Sprichwort"),
        Zitat(text:"Die kürzesten Wörter, nämlich 'ja' und 'nein' erfordern das meiste Nachdenken.", urheber:"Pythagoras von Samos"),
        Zitat(text:"Es gehört oft mehr Mut dazu, seine Meinung zu ändern, als ihr treu zu bleiben.",urheber:"Friedrich Hebbel")]
    
    var detailViewController: DetailViewController? = nil
    var restoreZitat: Zitat?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        var searchableItems: [CSSearchableItem] = []
        for zitat in zitate {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            
            attributeSet.title = zitat.text
            attributeSet.contentDescription = zitat.urheber
            
            var keywords = zitat.text.components(separatedBy: " ")
            keywords.append(zitat.urheber)
            attributeSet.keywords = keywords
            
            let item = CSSearchableItem(uniqueIdentifier: zitat.text, domainIdentifier: "Zitate", attributeSet: attributeSet)
            searchableItems.append(item)
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showZitat" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let zitat = zitate[(indexPath as NSIndexPath).row] as Zitat
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = zitat
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zitate.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = zitate[(indexPath as NSIndexPath).row] as Zitat
        cell.textLabel!.text = object.text
        return cell
    }
    
   override func restoreUserActivityState(_ activity: NSUserActivity) {
        
        if let stext = activity.userInfo?["text"] as? String,
            let urheber = activity.userInfo?["urheber"] as? String {
              let zitat = Zitat(text: stext, urheber:urheber )
              self.restoreZitat = zitat
              self.performSegue(withIdentifier: "showZitat", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Fehler", message: "Informationen konnten nicht gelesen werden:\n\(activity.userInfo)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Hinweis", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

