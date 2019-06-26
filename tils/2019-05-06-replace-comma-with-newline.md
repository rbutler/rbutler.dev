---
layout: til
title:  "Replace commas with newlines"
tags: []
---
During data mangling, I often want to take a list of IDs from one query and use it as a filter in another. Sometimes I cannot do this in a join, like when I am going across distinct databases.

There are three quick ways to get the data in the format I want

Say I have a file `test` that looks like:
```
3634371
5049801
4452738
```

### sed

``` shell
➜  rbutler ~ $ sed -i.bak -n -e 'H;${x;s/\n/, /g;p;}' file
➜  rbutler ~ $ cat file
, 3634371, 5049801, 4452738
```

This performs an in-place replace, but leaves a leading `,`.

### awk

```shell
➜  rbutler ~ $ awk -v ORS=',' '1' file
3634371,5049801,4452738,%
```

This does not replace inline, but leaves a trailing `,`.

### tr
```sheill
➜  rbutler ~ $ tr '\n' ,  < file
3634371,5049801,4452738,%
```

By far the easiest solution, but continues to leave a trailing `,`.


The trailing `,` can be removed by reversing the string and using the `cut` command
```sheill
➜  rbutler ~ $ tr '\n' ,  < file | rev | cut -c 2- | rev
3634371,5049801,4452738
```
