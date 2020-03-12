//
//  TableViewController.swift
//  HT13_PerformanceWithCoreData
//
//  Created by Maksym Korostelov on 3/11/20.
//  Copyright © 2020 Maksym Korostelov. All rights reserved.
//

import UIKit
import CoreData

class JsonTableViewController: UITableViewController {
    
    @IBOutlet var tableViewJson: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<BigJsonKeyValue> = {
        let fetchRequest = NSFetchRequest<BigJsonKeyValue>(entityName:"BigJsonKeyValue")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "key", ascending:true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.persistentContainer.viewContext,
            sectionNameKeyPath: #keyPath(BigJsonKeyValue.key), cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func downloadData(_ sender: UIBarButtonItem) {
        CoreDataService.downloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections![section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let keyValue = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = keyValue.value
        return cell
    }
}

extension JsonTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
