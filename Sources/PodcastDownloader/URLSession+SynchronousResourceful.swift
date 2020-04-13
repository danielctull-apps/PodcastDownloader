
import Foundation
import Resourceful

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {

    func download(_ resource: Resource<Data>) throws -> URL {

        var result: Result<URL, URLError>?
        let semaphore = DispatchSemaphore(value: 0)

        _ = performDownload(request: resource.request) { urlResult in
            result = urlResult.map { $0.0 }
            semaphore.signal()
        }

        semaphore.wait()

        guard let unwrapped = result else { throw NoResponseError() }

        switch unwrapped {
        case let .failure(error): throw error
        case let .success(value): return value
        }
    }


    // This is the private function from the Resourceful library.
    private func performDownload(
        request: URLRequest,
        completion: @escaping (Result<(URL, URLResponse), URLError>) -> Void
    ) -> URLSessionDownloadTask {

        let task = downloadTask(with: request) { data, response, error in

            guard let data = data, let response = response else {
                let error = (error as? URLError) ?? URLError(.unknown)
                completion(.failure(error))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
        return task
    }
}

extension URLSession {

    struct NoResponseError: Error {}

    /// Synchronously perfoms the network request and returns the value.
    ///
    /// - Parameter resource: The resource to retrieve.
    /// - Throws: An error thrown.
    /// - Returns: The value of the resource.
    func get<Value>(_ resource: Resource<Value>) throws -> Value {

        let semaphore = DispatchSemaphore(value: 0)

        var result: Result<Value, Error>?

        _ = perform(request: resource.request) { dataResult in
            result = Result { try resource.transform(dataResult.get()) }
            semaphore.signal()
        }

        semaphore.wait()

        guard let unwrapped = result else { throw NoResponseError() }

        switch unwrapped {
        case let .failure(error): throw error
        case let .success(value): return value
        }
    }

    // This is the private function from the Resourceful library.
    private func perform(
        request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), URLError>) -> Void
    ) -> URLSessionDataTask {

        let task = dataTask(with: request) { data, response, error in

            guard let data = data, let response = response else {
                let error = (error as? URLError) ?? URLError(.unknown)
                completion(.failure(error))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
        return task
    }
}
