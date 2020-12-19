import UIKit
import Foundation

func pullNewMovies(genre: String, number: Int, completion: @escaping ([String: Any]) -> ()) {
    if let url = URL(string: "https://api.reelgood.com/v3.0/content/roulette/netflix?availability=onAnySource&content_kind=both&nocache=true&region=us") {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err ?? "Error")
                completion([" ": " "])
            }
            guard let data = data else { return }
            
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(json)
                    //                        if (json["message"] as? String == "Not Found") {
                    //                            completion(f[alse)
                    //                        } else {
                    //                            completion(true)
                    //                        }
                    
                }
            } catch _ {
                completion([" ": " "])
            }
        }.resume()
    }
}

for i in 0...10 {
    pullNewMovies(genre: "", number: 0, completion: { yuh in
        
        print(yuh)
    })
}
