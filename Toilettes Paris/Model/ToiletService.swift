import CoreLocation
import Alamofire
import MapKit
import UIKit
import Foundation

class ToiletService {
    
    static var shared = ToiletService()
    
    private var session: Alamofire.Session
    
    private init() {
        self.session = Alamofire.Session(configuration: .default)
    }
    
    init(session: Alamofire.Session) {
        self.session = session
    }
    
    func loadAll(callback: @escaping (Bool ,[Toilet]?) -> Void) {

        let baseUrl = URL(string: "https://opendata.paris.fr/api/records/1.0/search/?dataset=sanisettesparis&q=&rows=615&facet=type&facet=statut&facet=horaire&facet=acces_pmr")!
        
        self.session.request(baseUrl).responseDecodable(of: ToiletAPIResponse.self) { response in
            switch response.result {
            case .success(let toiletResponse):

                var toilets = [Toilet]()
                toiletResponse.records.forEach { element in
                    let toilet = Toilet(
                        address: element.fields.adresse ?? "Inconnue",
                        hourly: element.fields.horaire ?? "Pas d'horaires",
                        accessibility: element.fields.acces_pmr ?? "Oui",
                        latitude: element.fields.geo_point_2d?.first ?? 0,
                        longitude: element.fields.geo_point_2d?.last ?? 0
                    )
                    toilets.append(toilet)
                }
                callback(true, toilets)
            case .failure(_):
                print("Il y a eu une erreur lors de la récupération")
                callback(false, nil)
            }
        }
    }
}
