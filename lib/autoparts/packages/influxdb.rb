# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class InfluxDB < Package
      name 'influxdb'
      version '0.5.0'
      description 'InfluxDB: An open-source distributed time series database'
      # we are using a precompiled version of influxdb
      source_url 'http://s3.amazonaws.com/influxdb/influxdb-0.5.0.amd64.tar.gz'
      source_sha1 'fa85c0ef67c44a0cec1330b296b9a5bb4569d8da'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('build') do
          bin_path.mkpath
          execute "cp", "influxdb", bin_path
          execute "cp", "influxdb-benchmark", bin_path
          execute "mv", "admin", influxdb_admin_path
        end
      end

      def post_install
        # create necessary directories
        influxdb_log_path
        influxdb_raft_path
        influxdb_storage_path
        influxdb_wal_path

        unless influxdb_config_path.exist?
          File.open(influxdb_config_path, 'w') { |f| f.write influxdb_config }
        end
      end

      def purge
        FileUtils.rm_rf(Path.etc + "influxdb")
        FileUtils.rm_rf(Path.var + "influxdb")
      end

      def start
        args = [
          "--start", "--quiet", "--oknodo", "--background",
          "--pidfile", influxdb_pid_file_path,
          "--exec", influxdb_path,
          "--",
          "-pidfile", influxdb_pid_file_path,
          "-config", influxdb_config_path,
          "> /dev/null 2>> #{influxdb_log_path}/log.txt &"
        ]
        execute "start-stop-daemon", *args
      end

      def stop
        if influxdb_pid_file_path.exist?
          pid = File.read(influxdb_pid_file_path).strip.to_i
          Process.kill "TERM", pid if pid
          influxdb_pid_file_path.unlink
        end
      end

      def running?
        if influxdb_pid_file_path.exist?
          pid = File.read(influxdb_pid_file_path).strip
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(influxdb_path.basename.to_s)
            return true
          end
        end
        false
      end

      def influxdb_path
        bin_path + "influxdb"
      end

      def influxdb_pid_file_path
        path = Path.var + name
        path.mkpath
        path + "influxdb.pid"
      end

      def tips
        <<-EOS.unindent
          To start the influxdb server:
            $ parts start influxdb

          To stop the Apache server:
            $ parts stop influxdb

          InfluxDB config is located at:
            $ #{influxdb_config_path}
        EOS
      end

      def influxdb_config_path
        path = Path.etc + name
        path.mkpath
        path + "config.toml"
      end

      def influxdb_log_path
        path = Path.var + name + "log"
        path.mkpath unless path.exist?
        path
      end

      def influxdb_admin_path
        prefix_path + "admin"
      end

      def influxdb_raft_path
        path = Path.var + name + "data" + "raft"
        path.mkpath unless path.exist?
        path
      end

      def influxdb_storage_path
        path = Path.var + name + "data" + "db"
        path.mkpath unless path.exist?
        path
      end

      def influxdb_wal_path
        path = Path.var + name + "data" + "wal"
        path.mkpath unless path.exist?
        path
      end

      def influxdb_config
        <<-EOS.unindent
        # Welcome to the InfluxDB configuration file.

        # If hostname (on the OS) doesn't return a name that can be resolved by the other
        # systems in the cluster, you'll have to set the hostname to an IP or something
        # that can be resolved here.
        # hostname = ""

        bind-address = "0.0.0.0"

        [logging]
        # logging level can be one of "debug", "info", "warn" or "error"
        level  = "debug"
        file   = "#{influxdb_log_path + "log.txt"}"         # stdout to log to standard out

        # Configure the admin server
        [admin]
        port   = 8083              # binding is disabled if the port isn't set
        assets = "#{influxdb_admin_path}"

        # Configure the http api
        [api]
        port     = 8086    # binding is disabled if the port isn't set
        # ssl-port = 8084    # Ssl support is enabled if you set a port and cert
        # ssl-cert = /path/to/cert.pem

        [input_plugins]

          # Configure the graphite api
          [input_plugins.graphite]
          enabled = false
          # port = 2003
          # database = ""  # store graphite data in this database

        # Raft configuration
        [raft]
        # The raft port should be open between all servers in a cluster.
        # However, this port shouldn't be accessible from the internet.

        port = 8090

        # Where the raft logs are stored. The user running InfluxDB will need read/write access.
        dir  = "#{influxdb_raft_path}"

        # election-timeout = "1s"

        [storage]
        dir = "#{influxdb_storage_path}"
        # How many requests to potentially buffer in memory. If the buffer gets filled then writes
        # will still be logged and once the local storage has caught up (or compacted) the writes
        # will be replayed from the WAL
        write-buffer-size = 10000

        [cluster]
        # A comma separated list of servers to seed
        # this server. this is only relevant when the
        # server is joining a new cluster. Otherwise
        # the server will use the list of known servers
        # prior to shutting down. Any server can be pointed to
        # as a seed. It will find the Raft leader automatically.

        # Here's an example. Note that the port on the host is the same as the raft port.
        # seed-servers = ["hosta:8090","hostb:8090"]

        # Replication happens over a TCP connection with a Protobuf protocol.
        # This port should be reachable between all servers in a cluster.
        # However, this port shouldn't be accessible from the internet.

        protobuf_port = 8099
        protobuf_timeout = "2s" # the write timeout on the protobuf conn any duration parseable by time.ParseDuration
        protobuf_heartbeat = "200ms" # the heartbeat interval between the servers. must be parseable by time.ParseDuration

        # How many write requests to potentially buffer in memory per server. If the buffer gets filled then writes
        # will still be logged and once the server has caught up (or come back online) the writes
        # will be replayed from the WAL
        write-buffer-size = 10000

        # When queries get distributed out, the go in parallel. However, the responses must be sent in time order.
        # This setting determines how many responses can be buffered in memory per shard before data starts gettind dropped.
        query-shard-buffer-size = 1000

        [leveldb]

        # Maximum mmap open files, this will affect the virtual memory used by
        # the process
        max-open-files = 40

        # LRU cache size, LRU is used by leveldb to store contents of the
        # uncompressed sstables. You can use `m` or `g` prefix for megabytes
        # and gigabytes, respectively.
        lru-cache-size = "200m"

        # The default setting on this is 0, which means unlimited. Set this to something if you want to
        # limit the max number of open files. max-open-files is per shard so this * that will be max.
        max-open-shards = 0

        # The default setting is 100. This option tells how many points will be fetched from LevelDb before
        # they get flushed into backend.
        point-batch-size = 100

        # These options specify how data is sharded across the cluster. There are two
        # shard configurations that have the same knobs: short term and long term.
        # Any series that begins with a capital letter like Exceptions will be written
        # into the long term storage. Any series beginning with a lower case letter
        # like exceptions will be written into short term. The idea being that you
        # can write high precision data into short term and drop it after a couple
        # of days. Meanwhile, continuous queries can run downsampling on the short term
        # data and write into the long term area.
        [sharding]
          # how many servers in the cluster should have a copy of each shard.
          # this will give you high availability and scalability on queries
          replication-factor = 1

          [sharding.short-term]
          # each shard will have this period of time. Note that it's best to have
          # group by time() intervals on all queries be < than this setting. If they are
          # then the aggregate is calculated locally. Otherwise, all that data gets sent
          # over the network when doing a query.
          duration = "7d"

          # split will determine how many shards to split each duration into. For example,
          # if we created a shard for 2014-02-10 and split was set to 2. Then two shards
          # would be created that have the data for 2014-02-10. By default, data will
          # be split into those two shards deterministically by hashing the (database, serise)
          # tuple. That means that data for a given series will be written to a single shard
          # making querying efficient. That can be overridden with the next option.
          split = 1

          # You can override the split behavior to have the data for series that match a
          # given regex be randomly distributed across the shards for a given interval.
          # You can use this if you have a hot spot for a given time series writing more
          # data than a single server can handle. Most people won't have to resort to this
          # option. Also note that using this option means that queries will have to send
          # all data over the network so they won't be as efficient.
          # split-random = "/^hf.*/"

          [sharding.long-term]
          duration = "30d"
          split = 1
          # split-random = "/^Hf.*/"

        [wal]

        dir   = "#{influxdb_wal_path}"
        flush-after = 0 # the number of writes after which wal will be flushed, 0 for flushing on every write
        bookmark-after = 0 # the number of writes after which a bookmark will be created

        # the number of writes after which an index entry is created pointing
        # to the offset of the first request, default to 1k
        index-after = 1000

        # the number of requests per one log file, if new requests came in a
        # new log file will be created
        requests-per-logfile = 10000
        EOS
      end
    end
  end
end
