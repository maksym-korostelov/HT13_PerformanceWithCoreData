import Foundation
import CoreData

enum CoreDataService {
    // MARK: JSON
    static func downloadData() {
        let url = URL(string: Constants.json100mb)
        debugPrint("\(Date()) loading started")
        
        let task = URLSession.shared.downloadTask(with: url!) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                let jsonDictionary = CoreDataService.parseJsonData((CoreDataService.getJSON(urlToRequest: tempLocalUrl.absoluteString)))
                
                let taskContext = CoreDataStack.persistentContainer.newBackgroundContext()
                taskContext.performAndWait { [weak taskContext] in
                    debugPrint("\(Date()) save to CoreData started")
                    guard let taskContext = taskContext else { return }
                    CoreDataService.saveBigJsonData(dictionary: jsonDictionary, context: taskContext)
                    
                    try? taskContext.save()
                    debugPrint("\(Date()) save to CoreData finished")
                }
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    static func getJSON(urlToRequest: String) -> Data {
        return try! Data(contentsOf: URL(string: urlToRequest)!)
    }
    
    static func parseJsonData(_ data: Data) -> [String: Any] {
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            
            guard let jsonArray = jsonResponse as? [String: Any] else {
                return [:]
            }
            
            return jsonArray
        } catch let parsingError {
            debugPrint("Error", parsingError)
        }
        return [:]
    }
    
    static func saveBigJsonData(
        dictionary: [String: Any],
        context: NSManagedObjectContext) {
        
        dictionary.forEach { key, value in
            if let childDictionary = value as? [String: Any] {
                saveBigJsonData(dictionary: childDictionary, context: context)
            } else if let value = value as? String {
                let bigJsonKeyValue = BigJsonKeyValue(context: context)
                
                bigJsonKeyValue.key = key
                bigJsonKeyValue.value = value
            }
        }
    }
    
    // MARK: image
    static func loadFromInternet(completion: @escaping (Data)->Void) {
        let url = URL(string: Constants.image70mb)
        debugPrint("\(Date()) loading started")
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            debugPrint("\(Date()) loading finished")
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            let taskContext = CoreDataStack.persistentContainer.newBackgroundContext()
            taskContext.performAndWait { [weak taskContext] in
                guard let taskContext = taskContext else { return }
                
                debugPrint("\(Date()) save to CoreData started")
                let bigImageEntity = BigImageEntityHolder(context: taskContext)
                bigImageEntity.bigImage = data
                try? taskContext.save()
                debugPrint("\(Date()) save to CoreData finished")
            }
            
            completion(data)
        }).resume()
    }
    
    static func loadFromCoreData(completion: @escaping (Data)->Void) {
        CoreDataStack.persistentContainer.performBackgroundTask { backgroundContext in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BigImageEntityHolder")
            
            var imageDataHolder: BigImageEntityHolder?
            do {
                imageDataHolder = try backgroundContext.fetch(fetchRequest).last as? BigImageEntityHolder
            } catch {
                
            }
            
            guard let data = imageDataHolder?.bigImage else { return }
            
            completion(data)
        }
    }
}
