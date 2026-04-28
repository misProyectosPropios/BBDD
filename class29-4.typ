#import "macros.typ": *
Buscar para la próxima clase:
+ Plan de ejecucion: 
  + Qué es,
  + Como se decide cual es, 
  + Como se ejecuta.

Cap 15, 16

#line 

_query processor_ is the group of components of a DBMS that turns user queries and data-modification commands into a sequence of database operations and executes those operations

= Preview of Query Compilation

Three steps:
+ parsing: creation of parse tree for query 
+ Query optimization: 
  + Query rewrite: parse tree converted to initial query plan. Then transformed into another equivalente plan  (logical query plan)
  + Physical plan generation. 


For the query optimization we need to decide: algebraically equivalent forms, what algorithm should we use to implement that operation and how should operations pass data from one to the other.


== Introduction to Physical-Query-Plan Operators

=== Scanning tables 

Most basic thing in physical query plan: 
+ Basic: Read entire contetns of relation R.
+ Variation:  involves simple predicate. We read only those tuples of the relation R that satisfies predicate.

Approaches:
+ _Table scan_: blocks containing tuples of R are known to the system and it's possible to get the blocks one by one.
+ _Index scan_: Use index to get all tuples of R. We can use it to get all the tuples that have particular values. 

=== Sorting while scanning tables 

May include ```ORDER BY```. SOme approaches required one or both arguments to be sorted relations 

*Sort scan*: takes relation R and specification of attributes on which sort is to be made and produces R in that sorted order.


=== The Computation M odel for Physical Operators

+ Arguemnts of any operator on disk, result of operator is left in main memory.

+ Result of a part of query often is not written to disk.

===  Parameters for Measuring Costs

Statistics / Parameters express cost of operator. 

+ Number of buffers used for a query 
+ Number of tuples in R. $T(R)$
+ Number of blocks needed to hold all tuples of R. $B(R)$
+ Number of distinct values that appear in a column of a relation. $V(R,a)$


===  I/O Cost for Scan operators #label("scan-io")

Number of I/O needed:
+ Table-scan
  + Relation R clustered: B 
  + Relaiton not clustered, R distributed among tuples of other relations. Table Scan: T 
+ Index scan:
  + Many fewer than B(R). More I/O than examining entire index. 

=== Iterators for Implementation of Physical Operators

Operations: 
+ Open Initializes data structures needed to perform the operations.
+ GetNext. Returns next tuple in result and adjusts data structures as necessary.
+ Close: ends iterations after all tuples have benn obtained.

== One-Pass algorithms 

Execute each of individual steps
+ Sorting based 
+ Hash based
+ Index based 

ALogrithms for operators in degress of difficulty and cost 
+ One pass: read data only once from disk.
+ Two pass: reading data a first time from disk, process, write all to disk and read a second time for further processing. Too large to fit in main memory, but not largest.
+ Three or more passed. Wihtout limit of size of data. Generalization of two pass 

Operators:
+ Tuple at a time, unary operations (selection and projection). Not entire R. Read block at a time, use main memory buffer and prodoce output.
+ Full relation, unary operations. Seiing all or most of tuples in memory at once. Size M (main memory buffers available)
+ Full relations. BInary operations. At least one arguments to be limited to size M to use one-pass algorithm


=== One pass algorithms for tuple at a time operations 

+ Read blocks 
+ Perfomr operation on each tuple 
+ Move selected tuples to output buffer 

Disk I/O requirements as in #link("scan-io")

=== One-Pass Algorithms for Unary, Full-Relation Operation

+ Duplicate elimination
  + Read each block of R one at a time and decide wheter we saw it or not the tuple 
  + Need: keep in memory one copy of every tuple we have seen. 
+ Grouping:
  + Min MAX : store the value so far found 
  + COUNT: add one for each tuple of the group seen 
  + SUM(a). add the value 
  + AVG. Mantain 2 accumulaitons: count of number of tuples and sum of a-values of these tuples.

Then produce output for each group
+ We cannot produce output until the last tuple is seen.

=== One-Pass Algorithms for Binary Operations

+ Set union ($R union S$)
  + S into M-1 buffers
  + Build search structure. 
  + Copy all S into output 
  + For each tuple t of R 
    + If it's not in S, write to output 
    + Otherwise no 
+ Set intersection 
  + S into M-1 buffers
  + Build search structure  (key = tuple )
  + Read each block of R and for each tuple t
    + If t is in S, copy t to output 
    + If not, ignore 
+ Set difference 
  + R is larger relation 
  + Read S into M - 1 buffers 
  + Build search structure with full tuples as key
+ Bag intersection 
  + S into M-1 buffers. Each distinct tuple a count. Copies of tuple t not stored individually.  
  + Read each block of R 
  + For each tuple t of R see whetet t occurs in S 
    + If not, ignore t 
    + If yes, output t and decrement count by 1. 
      + If t appears in S, but with count 0, ignore it
+ Bag difference 
  + Read tuples of S into main memory and count number of occurrences 
  + For each tuple t in R 
    + See if it occurs in s
      + If true, decrement associated count 
  + Copy in main memory all tuples whose count is positive 
+ Product: 
  + S into M-1 buffers
  + For each tuple t of R 
    + Concatenate t with each tuple of S in main memory 
+ Natural Join 
  +  Read all tuples of S and form them into search structure with attributes Y (intersection between them) as search key
  + Read each block of R. 
  + For each tuple t of R 
    + Find tuples of S that agree with t on all attributes of Y 
    + Form a tuple by joining it wiht y and move the resulitng tuple to output.

== Nested-Loop Joins

One and a halp passes. A variation will be read once and the other will be read many

=== Tuple based nested loop join

```
FOR each tuple s in S DO
  FOR each tuple r in R DO
    IF r and s join to make a tuple t then 
      output t;
``` 

=== Iterator for tuple based nested loop join 

Allows us to avoid storing intermediate relations on disk in some sitautions. 

=== BLOCK Based nested loop join algorithm 

+ Organizing access to both argument relations by blocks, and
+ Using as much main memory as we can to store tuples belonging to the relation 5, the relation of the outer loop.


#todo 



== Two-Pass Algorithms Based on Sorting

+ It's usually  enough. 
+ Generlization it's easy

=== Two-Phase, Multiway Merge-Sort

+ Phase 1. Fill M buffers iwth tuples form R and sort them. Write sorted sublist to secondary storeage
+ Phase 2: Merge sorted sublists 


Merge sorted sublists into one sorted list:
+ Smallest key among first remianing elements of all lists. 
+ Smallest element to first available position of output block 
+ If output blokc full write to disk and reinitialize same buffer in main memory 
+ If block was just taken is exahusted of records, read next block. If no blocks remian, leave its buffer empty.

=== Duplicate Elimination Using Sorting

In the way it sorts, when $t$ is wrote in the output, it drops the top if it's the same as _t_

=== Grouping and Aggregation Using Sorting

+ Read the tuples of R into memory
+ One main buffer for each sublist and load the first block of each sublist into its buffer 
+ Loop: Find  least value of sort key present among first avaialbe tuples.
  + Prepare to compute all aggregates on list L. 
  + Examine each of tuples with sort key v 
  + Buffer becomes empty, replace it with next block form same sublist 

=== Sort-based union algorithm (R and S)

+ Created sorted sublists from R and S 
+ Use 1 main memory buffer for each sublist of R and S. 
+ Repeatedly find the first remaining tuple t among all the buffers. Copy t to the output, and remove from the buffers all copies of t

=== Sort-Based Intersection and Difference


Repeatedly consider the tuple t at least in the sorted order among all tuples remaining. Produce output as follows and then remove lal copies of t from the input buffers.

=== A Simple Sort-Based Join Algorithm

+ Sort R and S using 2PMMS
+ Merge sorted R and S


== Two-Pass Algorithm s Based on Hashing

Hash all tuples of the argument using hash key. . We reduce the size of operands using a factor equal to number of buckets.

=== Partiioning relations by hashing 

h hash function. 
Associate one buffer with each bucket. 
Bucket copied to appropriate buffer. 

=== Hash based algorithm for duplicate 

```
initialize M-l buckets using M-l empty buffers;
FOR each block b of relation R DO BEGIN 
  read block b into the Mth buffer;
  FOR each tuple t in b DO BEGIN
    IF the buffer for bucket h(t) has no room for t THEN 
      BEGIN
        copy the buffer to disk;
        initialize a new empty block in that buffer;
      END;
    copy t to the buffer for bucket h(t);
  END;
END;
FOR each bucket DO
  IF the buffer for this bucket is not empty THEN 
    Write the buffer to disk;
```


=== Hash-Based Grouping and Aggregation

=== Saving Some Disk I/O's

Hash S, Choose to keep m of the k buckets in main memory. 


== Index-Based Algorithms

=== Clustering and NonClustering indexes 

Clustering indexes: indexes on an attribute or attributes such that all tuples with fixed value for search key of this index appear on roughly as can hold them.

=== Index based selection 

=== Index-Based Algorithms

#todo 

=== Joins Using a Sorted Index 
#todo 


== Buffer Management

Task: central task of making main-memory buffers avaialbe to process 

Allow proceses to get the memory they need, minimizaing delay and unsatisfiable requests. 

=== Buffer Management Architecture

+ The buffer manager control memory directly, 
+  allocate in virtual memory, allowing the operating system to decide which buffers are actually in main memory at any time and which are in the “swap space” on disk that the operating system manages

We assume that there is a fied-size buffer pool


=== Buffer Management Strategies

What block to throw out.
+ LRU (least recently used)
+ FIFO 
+ Clock algorithm 
  #image("assets/image-2.png")
+ System Control: query processor give advice to buffer manager to avoid some mistaked that would occur with strict policy. 

=== The Relationship Between Physical Operator Selection and Buffer Management

Can the algorithm adapt to changes in valud of M 
+ When expected M buffers are not avialbable. How does the buffer replacement strategy used impact the number of I/O's performed


== Algorithms Using More Than Two Passes

Generalization of 2 pass Algorithms

=== Multipass sort based algorithm

Simple recursive approach
+ M main memory to sort relation R (clustered)

Basis: R fits in M blocks, read R into amin memory, sort and write sorted relation to disk.

Induction: R does not fin into main memory, partiition blocks holding R. Sort all $R_i$, merge M sorted sublists.

=== Multipass Hash-Based Algorithms

Basis: unary operation: relation fits in M buffers, read it into memory and perform operion. BInary operaiton: either relation in M-1 buffers, perform 
Induction: No relation fits in main memory. Hash each relation into M-1 buckets, perform the operation on each bucket or corresponding pair of buckets and accumulate output

===  Performance of Multipass Hash-Based Algorithms

#todo

= Query compiler