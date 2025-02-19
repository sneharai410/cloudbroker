class Cloudlet < ApplicationRecord

    enum workload_type: {
        cpu_intensive: 'cpu_intensive',
        storage_intensive: 'storage_intensive',
        io_intensive: 'io_intensive',
        other: 'other'
      }
      
end
