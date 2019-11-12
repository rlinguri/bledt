//
// File:      BatchManager
// Module:    Entities
// Package:   bledt
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.4
//

/// Manages batches of samples
class BatchManager {
    
    // MARK: - Instance Properties
    
    /// The data we need to create batches of samples from
    let data: Data
    
    /// The generated samples
    var samples: [Sample]
    
    /// The generated batches
    var batches: [Batch]
    
    // MARK: - Instance Methods
    
    /// Initialize the BatchManager instance
    ///
    /// - Parameter data: The data we need to create batches of samples from
    init(data: Data) {
        self.data = data
        self.samples = []
        self.batches = []
        self.parseSamples()
        self.parseBatches()
    }
    
    /// Procedure to generate Samples
    private func parseSamples() {
        
        // make sure we can create a string from the data, so we can work with it
        if let text = String(data: data, encoding: .utf8) {
            
            // split the string into 40 character substrings
            let lines = text.split(separator: "\n")
            
            // iterate over all substrings
            for line in lines {
                
                // make sure we only create valid samples
                if line.count == 40 {
                    let sample = Sample(subsequence: line)
                    samples.append(sample)
                }
            }
        }
    }

    /// Procedure to generate Batches
    private func parseBatches() {
        
        // Start by clearing out any data
        self.batches = []
        
        // Initialize the first sequence to 0
        var batchSeq: Int = 0
        
        // start with a last sequence less than zero
        var lastSampleSeq: Int = -1
        
        // temp array of samples for the first batch
        var batchSamples: [Sample] = []
        
        // Itrerate over all samples
        for sample in samples {
            
            // see if we need to start a new batch
            if sample.seq < lastSampleSeq {
                let batch = Batch(seq: batchSeq, data: batchSamples)
                batches.append(batch)
                batchSamples = [sample]
                batchSeq += 1
            } else {
                // batch is not complete
                batchSamples.append(sample)
            }
            
            // update the last sample sequence
            lastSampleSeq = sample.seq
        }

        // finish up and add the last batch
        let batch = Batch(seq: batchSeq, data: batchSamples)
        self.batches.append(batch)
        
    }
    
}
