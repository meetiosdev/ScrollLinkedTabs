//
//  APILogger.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 11/07/25.
//

import Foundation
import OSLog

/// A utility class responsible for logging API request and response details with unique identifiers.
/// Uses Apple's OSLog for better performance and integration with Console.app
final class APILogger {
    
    // MARK: - Properties
    
    private static let logger = Logger(subsystem: "com.segmentlinkedtabs.api", category: "network")
    private static let isLogEnabled = true // Can be controlled via environment or build configuration
    
    // MARK: - Request Logging
    
    /// Logs the API request details.
    /// - Parameters:
    ///   - url: The full URL of the request.
    ///   - method: HTTP method.
    ///   - headers: Request headers.
    ///   - body: Request body data.
    /// - Returns: The UUID associated with this request log.
    @discardableResult
    static func logRequest(
        url: String,
        method: String,
        headers: [String: String]?,
        body: Data? = nil
    ) -> String {
        let requestId = UUID().uuidString.prefix(8)
        
        guard isLogEnabled else { return String(requestId) }
        
        let logMessage = """
        🌐 API REQUEST [\(requestId)]
        📍 URL: \(url)
        🔄 Method: \(method)
        📋 Headers: \(headers?.prettyPrintedJSONString ?? "{}")
        📦 Body: \(body?.jsonString ?? "nil")
        """
        
        logger.info("\(logMessage)")
        printConsoleOutput(logMessage, type: .request)
        
        return String(requestId)
    }
    
    // MARK: - Response Logging
    
    /// Logs the API response.
    /// - Parameters:
    ///   - requestId: The ID matching the request.
    ///   - data: Raw response data.
    ///   - statusCode: HTTP status code.
    ///   - responseTime: Time taken for the request in seconds.
    static func logResponse(
        requestId: String,
        data: Data?,
        statusCode: Int?,
        responseTime: TimeInterval? = nil
    ) {
        guard isLogEnabled else { return }
        
        let status = statusCode.map { "(\($0))" } ?? ""
        let timeString = responseTime.map { String(format: "%.2fs", $0) } ?? ""
        let responseString = data?.jsonString ?? "nil"
        
        let logMessage = """
        ✅ API RESPONSE [\(requestId)] \(status) \(timeString)
        📥 Response Data: \(responseString)
        """
        
        logger.info("\(logMessage)")
        printConsoleOutput(logMessage, type: .response)
    }
    
    // MARK: - Error Logging
    
    /// Logs an API error.
    /// - Parameters:
    ///   - requestId: The ID matching the request.
    ///   - data: Raw response data.
    ///   - statusCode: HTTP status code.
    ///   - error: The error that occurred.
    ///   - responseTime: Time taken for the request in seconds.
    /// - Returns: A formatted NSError for the calling code.
    static func logError(
        requestId: String,
        data: Data?,
        statusCode: Int?,
        error: Error,
        responseTime: TimeInterval? = nil
    ) -> NSError {
        
        guard isLogEnabled else {
            let fallbackMessage = "Something went wrong. Please try again."
            return NSError(
                domain: "APILoggerErrorDomain",
                code: statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: fallbackMessage]
            )
        }
        
        let status = statusCode.map { "(\($0))" } ?? ""
        let timeString = responseTime.map { String(format: "%.2fs", $0) } ?? ""
        let responseString = data?.jsonString ?? "nil"
        
        // Try to extract API error message from response
        var errorDescription = error.localizedDescription
        if let data = data {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                errorDescription = apiError.message
            }
        }
        
        let logMessage = """
        ❌ API ERROR [\(requestId)] \(status) \(timeString)
        📥 Response Data: \(responseString)
        💥 Error: \(errorDescription)
        """
        
        logger.error("\(logMessage)")
        printConsoleOutput(logMessage, type: .error)
        
        return NSError(
            domain: "APILoggerErrorDomain",
            code: statusCode ?? -1,
            userInfo: [NSLocalizedDescriptionKey: errorDescription]
        )
    }
}

// MARK: - Supporting Types

private extension APILogger {
    
    enum LogType {
        case request, response, error
        
        var emoji: String {
            switch self {
            case .request: return "🌐"
            case .response: return "✅"
            case .error: return "❌"
            }
        }
        
        var color: String {
            switch self {
            case .request: return "\u{001B}[34m" // Blue
            case .response: return "\u{001B}[32m" // Green
            case .error: return "\u{001B}[31m" // Red
            }
        }
    }
    
    static func printConsoleOutput(_ message: String, type: LogType) {
        let resetColor = "\u{001B}[0m"
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let output = "\(type.color)\(timestamp) \(type.emoji) \(message)\(resetColor)"
        print(output)
    }
}

// MARK: - API Error Response

private struct APIErrorResponse: Codable {
    let success: Bool
    let message: String
}

// MARK: - Extensions

private extension DateFormatter {
    static let logTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}

private extension Dictionary where Key == String, Value == String {
    var prettyPrintedJSONString: String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }
}

private extension Data {
    var jsonString: String {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
              let string = String(data: data, encoding: .utf8) else {
            return String(data: self, encoding: .utf8) ?? "Unable to decode data"
        }
        return string
    }
} 