#import "macros.typ": *

Aprender sobre:
+ ACID
+ Transacciones

Además, voy a leer el capítulo 4 para ir adelantando

#line 

Las bases de datos están en casi todos los sitios web.

El poder viene de DBMS (database managment system)

They are useful for: creating and managing large  amounts of data efficiently and allowing it to persist over long periods of time, 


= The Evolution of Database System s

DBMS expected to:
+ Allow users to create new databases and specify their schemas, using data-definition language
+ Give users the ability to query the data (question about data) and modify data, using data-manipulation language.
+ Support the storage of very large amounts of data over a large period of time
+ Enable durability, recovery of database in face of failure, erros of many kind or intentional misuse
+Control access to data from many users at once, without allowing unex￾pected interactions among users (isolation) and without actions on the data to be performed partially but not completely (atomicity)


== Early Database Management Systems

First commertial DBMS
+ Late 1960's. Evolved from file systems. Do not guarantee that data cannot be lost if it's not backed up
+ Do not support data-manipulation language.
+ Used in: 
   + Banking systems
   + Airline reservation systems 
   +

== Relational Database Systems

Paper of Codd proposed:\
#h(2em)Database systems should present the user with a view of data organized as tables called relations

- Programmers should not be concerned for the way the data is stored 

=== Smaller and Smaller Systems


Apparition of XML \
Large collections of small documents can serve as a database, and the methods of querying and manipulating them are different

=== Bigger and Bigger Systems

Need to store more and more information. Pentabytes of information. 
Example: google, satelites information, Peer-to-peer file-sharing systems 

=== Information integration
Many distributed information to tell the same thing:

Solution: 
+ creation of data warehouses, where information from many legacy databases is copied periodically,  with the appropriate translation, to a central database.
+ Middleware: sup￾port an integrated model of the data of the various databases, while translating between this model and the actual models used by each databas

== Overview of a Database Management System

two distinct sources of commands to the DBMS:

+ Conventional users and application programs that ask for data or modify data.
+ A database administrator: a person or persons responsible for the structure or schema of the database.

=== DDL (Data Definition Language)

schema-altering data-definition language (DDL) commands are parsed by a DDL processor and passed to the execution engine, which then goes through the index/file/record manager to alter the metadata, that is, the schema information for the database

=== Answering the Query

query parsed and compiled by: *_query compiler_*

To perform to answer the query is passed to the *_execution engine_*
This _*requests*_ small pieces of data _*to: resource manager*_. This knows about: data files, format and size of records and index files.

Request passed to: _*buffer manager*_. Bring appropriate portions of data where it is kept permanently

=== Transaction Processing
Queries and DML actions grouped into _*transacitons*_:

Units that must be _*executed atomically*_ and in _*isolation*_
Durable:  
+ concurrency-control manager or scheduler: ensures atomicity and isolation.
+ logging and recovery manager, responsible for the durability of transactions.

=== Storage and Buffer Management

Data in: _*secondary storage*_. Usually, it control storage on the disk directly.
+ The storage manager keeps track of the location of files on the disk and obtains the block or blocks containing a file on request from 
+ The buffer manager is responsible for partitioning the available main memory into buffers.

Information that may be needed.
+ Data: contents of database itself
+ metadata: database schema. Describes schema 
+ Log records: information about recent changes.
+ Statistics: information gathered and stored by DBMS
+ Indexes: data structures to access efficiently to the memory.

=== Transaction Processing

_*transaction manager*_ therefore accepts transaction commands from an application.  Tells when transactions begin and end

Transaction processor steps:

+ Logging: assure durability: writes the log in buffers and negotiates with the buffer manager to make sure that  buffers are written to disk
+ Concurrency control: the scheduler (concurrency-control manager) must assure that the individual actions of multiple transactions are executed in such an order that the net effect is the same as if the transactions had in fact executed in their entirety, one-at-a-time
+ Deadlock resolution:The transaction manager has the responsibility to intervene and cancel (“roll￾back” or “abort”) one or more transactions to let the others proceed.

ACID: 
+ Atomicity: all-or-nothing execution of trans￾action
+ Consistency:  consistency constraints, or expectations about relationships among  data elements
+ isolation:  each transaction must appear to be executed as if no other transaction is executing at the same  time
+ Durability: the effect on the database of a transaction must never be lost, once the transaction  has completed

== The Query Processor

+ The query compiler: translates the query into an internal form called a query plan.
  + Query parser: tree structure from the textual form of the query.
  + Query preprocessor: semantic checks on the query and performing some tree transformations
  + Query optimizer: transforms the initial query plan into the best available sequence of operations on the actual data.
+ Execution engine: executing each of  the steps in the chosen query plan

End of Chapter 1

= Concurrency Control (Chapter 18)