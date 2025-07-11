//
//  DataJSONExtensions.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 11/07/25.
//

/// Utility extensions for common data types, enhancing functionality with type-safe, reusable methods.
import Foundation

/// Extension for Data to provide JSON string conversion.
extension Data {
    /// A pretty-printed JSON string representation of the data.
    /// Returns a formatted JSON string if successful, or a descriptive error message if conversion fails.
    var json: String {
        // Serialize JSON data to a JSON object
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self) else {
            return "Error: Invalid JSON data"
        }
        
        // Convert JSON object to pretty-printed data
        guard let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) else {
            return "Error: Failed to serialize JSON object"
        }
        
        // Convert pretty-printed data to string
        guard let prettyString = String(data: prettyData, encoding: .utf8) else {
            return "Error: Failed to encode JSON to string"
        }
        
        return prettyString
    }
}
