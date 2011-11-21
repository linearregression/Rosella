---
layout: rosella
title: Rosella Query
---

## Overview

The Rosella Query library is a library for performing higher-order functions
on aggregate data. Aggregates are things like arrays and hashes, where an
object contains many related child objects. The Rosella Query library is based
in no small part on ideas from the .NET System.Linq library, although many of
the routine names are changed and the interfaces have been modified to suit
the capabilities of the Parrot Virtual Machine.

## Concepts

### Queryables and Streams

The Query library has two major types of objects: Queryables and Streams. A
Queryable is an eager object which performs higher-order routines on an
existing in-memory aggregate. For instance, a Queryable can operate on an
existing Array object, perform operations on the contents, and return a new
Array. A Stream uses an iterator approach to operate lazily on a source, and
executes stages in order, one data item at a time.

Calling the "map" method on a Queryable Array will perform the mapping in a
tight loop and return a fresh new array. Calling the map method on an Array
Stream will return the Stream with that mapping integrated into the fetch
logic. Every access of an item on the Stream reads a new item from the Array
and performs the mapping on that item only. All other consumers of the stream
will not know that any mappings have been applied to it, and the data source
(the Array) will be read lazily.

Queryables tend to work best with in-memory objects which are Arrays or
Hashes. They are eager and relatively quick, using type-specific optimizations
for different operations where possible. The downside is that most operations
return a new PMC, such as a new hash or a new array to hold the results.
Queryables will try to preserve semantics of the input type. For instance,
creating a Queryable for an Array object will typically return results in an
array format. Queryables with Hash data will typically return results as
Hashes. Methods such as `.to_array()`, `.to_hash()`, `.sort()` or `.fold()`
will modify the storage type.

Streams tend to work best with objects which are lazy and iterable. For
instance, the lines of text in a very large file may be best read one at a
time instead of reading the whole contents of a file into a large blob of
in-memory text and attempting to work with it all at once. Lines of input from
a Pipe from a long-lived subprocess, or a network Socket might not be limited
in number, and attempting to read all data into a single blob may hang the
program. Using a Stream over these sources ensures that lines would be read
individually and only on demand. Streams always treat data as sequential and
array-like. Streams also tend to be one-way structures. Once you read data
from the stream you can't typically un-read it. You can push values back onto
the stream, but those values are not propagated back to the original data
iterator.

Streams maintain an output cache so that stages which read data from the
source but do not return that data to the user do not lose data. For instance,
performing a `.count()` operation on a stream does not make data disappear.
The source iterator will be exhausted, but the result data will be stored
in the output hash to be read later. Subsequent reads from the stream will
return data from the output cache directly.

### Functions and Predicates

The Query library takes two types of function objects for it's routines:
regular functions and predicates. This is mostly a difference in terminology.
A function is one that takes one or more data values and is expected to return
another data value. A Predicate is a function that is expected to take one or
more data values and return a boolean. Typically the boolean value is an
answer to the question "Does this value belong in the result set?". For
example, the `.filter()` method on Queryable and Stream takes a predicate
which returns true if the data should be included, and false if the data
should be excluded. The `.count()` method takes an optional predicate which,
if provided, returns the count of items in the Queryable for which the
predicate returns true.

### Map, Filter, and Fold

Map, Filter, and Fold are the classic higher-order functions. They have
well-known behaviors and can be combined together in powerful ways.

Map iterates over the data, producing a new item in the results set for each
element in the input set. The result of a Map operation on a Queryable is
always the same type of aggregate (array or hash) as the input data. Maps on
Streams return a sequence of the mapped values. It will also always have
the same number of elements. In the case of a hash aggregate, the output hash
has the same keys.

Filter iterates over the data, only copying items which satisfy a predicate
into the result set. The result of a Filter operation on a Queryable is the
same type as the input aggregate (array or hash), although it will typically
have fewer entries. In an array result the surviving elements are moved
forward and indices are not preserved. In a hash result, the surviving
elements have the same keys. If Filter is used on a scalar, the result will
either be the scalar itself (if it passes the filter) or null. If the original
scalar data is null, the two results are indistinguishable. For Streams, a
filter operation will return the current data if it matches the predicate, or
it will pull a new piece of data from the source until it does.

Fold (also known as "Reduce") iterates over the input data, combining the
elements together into a single result. The result of a Fold is always a
scalar. For Streams, the Fold operation is eager and will read all remaining
data from the source.

### Take and Skip

Take and skip reduce a set by a specified number, starting at the beginning
of the aggregate. In the case of Take, only the first N items are stored in
the results set. If N is larger than the aggregate, all items are included in
the result. In Skip, we skip the first N items and return all the rest. Both
of these methods can take a predicate. If provided, the predicate is used with
a filter-like operation to reduce the input set first, before the items are
counted and partitioned.

For array aggregates, result sets are calculated in order. So `.take(3)` will
return a new array with items 0, 1, and 2 from the input data. Likewise, Skip
will return items from the end of the array. For hash aggregates, there is no
idea of ordering. The take and skip routines use iterators, and dutifully take
or skip items from the iterator in the order they are presented. Where the
iterator does not preserve order, the result sets may appear to be randomly
selected.

`.skip(0)` always returns a complete copy of the input data. `.take(0)` always
returns an empty aggregate (or null, for scalars). For Scalar data, Take with
any positive number returns the scalar itself, while Skip with any value
greater than 1 returns null.

For Streams, the Take operation acts like a limit for the number of items
retrieved. Once the maximum number of items have been taken, no more data will
be read from the source. The skip operation is likewise lazy. It immediately
reads through the first N items from the source and discards them. It then
returns all subsequent items unaltered.

### Count, Any, Single, and First

Count returns a count of elements in the aggregate. Count can take an optional
predicate and will return the number of items which match that predicate if
provided. In Streams, Count is eager and will read all remaining data from the
source, storing data items in the output cache of the stream.

Any returns true if there are any items in the aggregate, or any items which
match an optional predicate. This behavior is intended to be as lazy as
possible. In Streams, Any is lazy. It reads items from the source until the
predicate is satisfied, storing values in the output cache.

Single expects an aggregate with exactly one element. Single returns that
element, as a Scalar Queryable. If the aggregate has zero elements or more
than 1, an exception is thrown. Single is not provided on Streams.

First returns the first item in the aggregate, or the first item which
matches an optional predicate. As with the note above about skip and take,
hash aggregates are not expected to be ordered and the notion of "first" may
be nonsensical. If the aggregate is empty, First throws an exception. There
is a variant called `.first_or_default` which returns a default value (null,
unless specified otherwise) if the aggregate is empty. First and
first_or_default are not provided on Streams. Use something like `.take(1)` to
simulate the effect.

### to_array and to_hash

The Queryable object can convert between hash and array types, or remap the
items in a hash to new positions.

The `to_array` method returns an array Queryable. Where the input data is an
array, `to_array` returns a copy of it. Where the input data is a hash,
`to_array` returns an array of the values of the hash (in the order returned
by the hash iterator). Hash keys are lost irretrievably.

The `to_hash` method returns a hash Queryable. It takes a function to be used
for generating the hash key from the data item. The key generator function
only takes the data item as input, not the key for an existing hash. Old hash
keys are lost irretrievably.

### data, next, execute and unwrap_first

There are two methods for pulling data out of a Queryable without wrapping it
back into another queryable. The first, `.data()` returns the complete data
object reference from the Queryable. The second, `.unwrap_first` is a method
on Provider only and is not accessable through Queryable. It returns the first
item from an aggregate, such as the first item in an array, or the first item
from a hash iterator.

For Streams there are several methods for retrieving results. The `.data()`
method completely iterates the stream, returning an array of results. The
`.execute()` method does the same thing except it returns no results and
stores values in the output cache of the Stream. The `.next()` item retrieves
the next single value from the stream. Notice that calling `.next()` may
draw several items from the source iterable or none at all. For instance, if
the stream has items in the output cache, the values will be read from there
without reading from the source iterator. If a stage in the stream caches
intermediate values, data may come from there without drawing from previous
streams at all. Likewise, a filter operation may have to pull several items
from the source until a suitable value is found which satisfies the predicate.

You can clear all stages in a Stream with the `.clear_stages()` method.

## Namespaces

### Rosella.Query

The `Rosella.Query` namespace provides some utility functions. The
`as_queryable` function takes an aggregate or other data and wraps it in a
`Rosella.Query.Queryable` object. The `as_stream` function takes an iterable
value and returns a `Rosella.Query.Stream` object. These methods should be
used instead of calling constructors on Stream or Queryable directly.

## Classes

### Query.Provider

`Rosella.Query.Provider` is an abstract base class for query providers. Each
provider handles querys for a specific type of object. This class outlines the
interface and provides a few common method implementations. Do not use this
class directly. Use a subclass instead.

Providers typically do not have state, so the few types provided by the Query
library by default are singletons. Custom implementations do not need to be
singletons, however.

### Query.Provider.Array

`Rosella.Query.Provider.Array` is a query provider for arrays and array-like
structures. In uses integer-based indexing to operate on arrays in order.

### Query.Provider.Hash

`Rosella.Query.Provider.Hash` is a query provider for hashes and hash-like
objects. It uses string-key indexing to operate on hashes. Notice that hashes
are not expected to be ordered, so querys on hashes are not necessarily
ordered or deterministic between program runs.

### Query.Provider.Scalar

`Rosella.Query.Provider.Scalar` provides query behavior for data which is not
an array or a hash. This is a degenerate form of the other providers, and
always operates under the assumption that the data is exactly one element.
The `.count()` method always returns 1, `.take()` always returns the element
itself, `.skip` usually returns null, etc.

### Query.Queryable

`Rosella.Query.Queryable` is a wrapper type which adds a variety of methods
to a data aggregate and associates it with a query provider. Almost all
methods on Queryable return another Queryable with the results set, so
operations can be neatly chained together.

Methods on Queryable always return a new Queryable object.

Queryable is the preferred interface for using the Query library, although
providers can be used directly if desired. Providers do typically provide a
more flexible, if more verbose, interface.

The best way to get a Queryable for your data is to use the
`Rosella.Query.as_queryable` function.

The `.data()` method returns the data object stored inside the Queryable.

### Query.Queryable.InPlace

Unlike Queryable, `Rosella.Query.Queryable.InPlace` always returns itself
from each method. This preserves the same chaining behavior as Queryable, but
removes the overhead of generating extra Queryable objects for each stage.

### Query.Stage

Streams consist of a list of `Rosella.Query.Stage` objects, subclasses of
which implement the various behaviors on Stream. Stages form a linked list,
with each stage drawing values from the previous stage and returning updated
values to the subsequent stage.

The first stage is called `Rosella.Query.Stage.Source`, and performs simple
iteration on the input data source.

Every stage implements the `.next()` method. This method returns two values.
The first is a boolean flag that says whether the data is valid. The second
value is the data itself. An invalid data (the first return value is false)
represents the end of the Stream. Once a stage returns an invalid data, that
stage should not be asked for any more data.

### Query.Stream

A `Rosella.Query.Stream` object is like a Queryable in many ways and shares
many methods in common with them. In some cases, the two types could be used
interchangably and will produce identical results. Internally, the semantics
between the two are significantly different and in many situations the two
will have markedly different behaviors.

## Examples

### Winxed

    var rosella = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("query");

This example, from the test suite, uses `.map`, `.filter` and `.fold`. It uses
map to square each entry. Then it uses filter to select only the odd squares.
Finally, it uses fold to sum all the squares together. The sum of 1 + 9 + 25
+ 49 + 81 = 165.

    var data = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    int sum = Rosella.Query.as_queryable(data)
        .map(function(int i) { return i * i; })
        .filter(function(int j) { return j % 2; })
        .fold(function(int s, int i) { ret s + i; })
        .data();
    say(sum); # 165

### NQP-rx

    my $rosella := pir::load_bytecode__ps("rosella/core.pbc");
    Rosella::initialize_rosella("filesystem");

Same sum-of-odd-squares example from above, in NQP-rx:

    my @data := [1, 2, 3, 4, 5, 6, 7, 8, 9];
    my $sum := Rosella::Query::as_queryable(@data, 1).map(
        -> $i { $i * $i; }
    ).filter(
        -> $j { $j % 2; }
    ).fold(
        -> $s, $i { $s + $i; }
    ).data;
    pir::say($sum); # 165

## Users

* The Rosella Harness library uses the Query library, specifically Streams,
in executing tests and parsing through the output.
* The Rosella Template library uses streams of tokens for parsing template
text