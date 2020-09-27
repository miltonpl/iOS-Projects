
import UIKit

//User of json decoder
// the Json decoder from json to data/classes
//To make sence you data from a bites
//Data Serialization
//Data Deserialization


class ServiceManager {
//    Check how to do this in Objective C
//    Type  property use: static
    static let manager = ServiceManager()
//    it can be istatiated inside that class (private)
    private init() {}
    //Class that is user to get data from the server
 
     
    func request(url: URL, completionHandler: @escaping(Any?, Error?) -> Void) {

        //URLSession reques the information
        //Server gets the request and responds
        //Network Session that apple user URL Sesssion
//        We can user data task for downloading a big file
        //we can use background task 
       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        //HTPPResponse form URLSession
        
            //The data is comming in bites so we need to convert
//        HTTPResponse and HTPPRequest
        guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 ), let data = data else {
            DispatchQueue.main.async { completionHandler(nil, error) }
                return
            }
            DispatchQueue.main.async { completionHandler(data, nil) }
            //mutableleaves that can be present in string
        }
        task.resume()
        //in order to execute your task we need the taked to resume()
    }

    /**
            
           200 - 299  -Success
           300 - 399
           404 NOT Found
           500 Internal Server
           **/
    
    
    func callRequest(withUrl url: URL,  completionHandler: @escaping(Any?, Error?) -> Void) {
       
        let task  = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //The data is comming in bites so we need to convert
            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 ), let data = data else {
                //main process
            DispatchQueue.main.async{
                    //Closure defined in func CallRequest
                    completionHandler(nil, error)
                }
                
                return
            }
            DispatchQueue.main.async{
                //Closure defined in func CallRequest
                completionHandler(data, nil)
                
            }
            //mutableleaves that can be present in string
        }
        
        //we need to call task resume in order to call the service
        task.resume()
        
    }

}

// primary key -> identical
// foreign key will for some other table
//a pointer to each table
/*
 Normalization is the process of organizing data in a database. This includes creating tables and establishing relationships between those tables according to rules designed both to protect the data and to make the database more flexible by eliminating redundancy and inconsistent dependency.
 */
