# Sample Data

To help you get started quickly with [`zq`](https://github.com/mccanne/zq), this repository contains small sample sets of [Zeek](https://www.zeek.org/) data. There are three different log formats available, all representing events based on the same network traffic:

| Directory | Format |
|-----------|--------|
| [zeek-default/](zeek-default) | [Zeek default output format](https://docs.zeek.org/en/stable/examples/logs/) |
| [zeek-ndjson/](zeek-ndjson) | [ Newline-delimited JSON (NDJSON)](http://ndjson.org/), as output by the Zeek package for [JSON Streaming Logs](https://github.com/corelight/json-streaming-logs) |
| [zson/](zson) | [ZSON](https://github.com/mccanne/zq/blob/master/pkg/zson/docs/spec.md), the default output format of [`zq`](https://github.com/mccanne/zq) |

The examples in the [`zq`](https://github.com/mccanne/zq) documentation are based on this sample data.

# Origin/License

This sample data set was generated from a subset of the [packet capture archives](https://archive.wrccdc.org/pcaps/) that are distributed by the [WRCCDC](https://www.wrccdc.org/).

This sample data is [licensed](LICENSE) under a Creative Commons Attribution-ShareAlike 4.0 International License, as it is built upon the WRCCDC PCAP data that is distributed under the same license.

# Acknowledgement

We would like to express our thanks to the WRCCDC for generously making their packet capture archives available to the public and for commercial use. The terabytes of "real world" data has been invaluable to us in testing the foundations of `zq` at scale.

# Creation

The data set was made from the several PCAP files in the [2018](https://archive.wrccdc.org/pcaps/2018/) set. [Zeek v3.0.0](https://github.com/zeek/zeek/releases/tag/v3.0.0) was used in its default configuration with the only change being the addition/enabling of the [JSON Streaming Logs](https://github.com/corelight/json-streaming-logs) package. The packet captures were then processed via the command-line:

```
# zeek -r wrccdc.2018-03-24.101533000000000.pcap -r wrccdc.2018-03-24.101551000000000.pcap -r wrccdc.2018-03-24.101610000000000.pcap -r wrccdc.2018-03-24.101629000000000.pcap -r wrccdc.2018-03-24.101737000000000.pcap -r wrccdc.2018-03-24.101939000000000.pcap -r wrccdc.2018-03-24.102051000000000.pcap -r wrccdc.2018-03-24.102126000000000.pcap -r wrccdc.2018-03-24.102233000000000.pcap -r wrccdc.2018-03-24.102443000000000.pcap -r wrccdc.2018-03-24.102602000000000.pcap -r wrccdc.2018-03-24.102643000000000.pcap -r wrccdc.2018-03-24.102717000000000.pcap -r wrccdc.2018-03-24.102733000000000.pcap -r wrccdc.2018-03-24.102747000000000.pcap -r wrccdc.2018-03-24.102831000000000.pcap -r wrccdc.2018-03-24.102920000000000.pcap -r wrccdc.2018-03-24.103009000000000.pcap -r wrccdc.2018-03-24.103049000000000.pcap -r wrccdc.2018-03-24.103117000000000.pcap -r wrccdc.2018-03-24.103152000000000.pcap -r wrccdc.2018-03-24.103210000000000.pcap -r wrccdc.2018-03-24.103224000000000.pcap -r wrccdc.2018-03-24.103256000000000.pcap -r wrccdc.2018-03-24.103420000000000.pcap -r wrccdc.2018-03-24.103630000000000.pcap local
```

This produced the logs in Zeek default and NDJSON formats. As ZSON is not yet output directly by Zeek, the ZSON-format logs were created by sending each Zeek default log through `zq` (e.g., `zq conn.log > conn.ndjson`).
