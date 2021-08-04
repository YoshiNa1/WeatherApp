
import Foundation
import ObjectMapper

struct OneCallObject : Mappable {
	var lat : Double?
	var lon : Double?
	var timezone : String?
	var timezone_offset : Int?
	var current : Current?
	var daily : [Daily]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		lat <- map["lat"]
		lon <- map["lon"]
		timezone <- map["timezone"]
		timezone_offset <- map["timezone_offset"]
		current <- map["current"]
		daily <- map["daily"]
	}

}
