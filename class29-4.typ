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
+ Table-scan}
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

Disk I/O requirements as in #link("scan-io")  I/O Cost for Scan operators 