# Educational Sample Data

To allow for "real world" query examples in the
[Zed language documentation](https://github.com/brimdata/zed/blob/main/docs/language/README.md),
below this directory are a handful of small sample data sets regarding
schools in the state of California and their published
[SAT](https://en.wikipedia.org/wiki/SAT) test scores.

# Usage

To follow along with the examples, clone this repo and execute queries from
within the [`zson/`](zson) subdirectory.

```
# git clone --depth=1 https://github.com/brimdata/zed-sample-data.git
# cd edu/zson
```

# Origin/Acknowledgement

This sample data originated as an SQLite database from the
[Public Affairs Data Journalism](http://2016.padjo.org/tutorials/sqlite-data-starterpacks/)
website at Stanford. We would like to express our thanks to them for having
made this data publicly available.

# Creation

As Zed does not yet have an SQLite reader ([zed/2844](https://github.com/brimdata/zed/issues/2844)),
the ZSON data ultimately used in the examples was generated using
additional tools.

After having downloaded the [original database](http://2016.padjo.org/files/data/starterpack/cde-schools/cdeschools.sqlite)
to the [`sqlite/`](sqlite) directory, an SQLite tool was used to convert two
of its tables to separate JSON files.

```
sqlite3 -json sqlite/cdeschools.sqlite "select * from schools;" > json/schools.json
sqlite3 -json sqlite/cdeschools.sqlite "select * from satscores;" > json/testscores.json
```

As the CSV/JSON formats lack rich data typing information, Zed shaper scripts
located in this directory were then used to apply ideal data types and trim
unneeded fields. The shaped and sorted data was then stored as ZSON.

```
zq -z -i json -I shape-schools.zed '| sort School' json/schools.json > zson/schools.zson
zq -z -i json -I shape-testcores.zed '| sort sname' json/testscores.json > zson/testscores.zson
```

Finally, as some Zed language examples required IP address network data, the
data set was augmented by doing a one-time DNS lookup of the websites from the
school data to create a third data source that captures an IP address at
which each site was once hosted.

```
for hostname in $(zq -f text 'by Website' zson/schools.zson | sed 's/^http:\/\///' | sed 's/\/.*$//' | sort | uniq | grep -v "\-" | less)
do
  addr=$(dig +noall +answer $hostname | grep "\tA\t" | awk '{ print $5 }' | head -1)
  if [ -n "$addr" ]; then
    echo "{\"Website\":\"$hostname\",addr:$addr}"
  fi
done
```
