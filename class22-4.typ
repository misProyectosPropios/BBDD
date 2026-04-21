#import "macros.typ": *

Buscar para la próxima clase
+ Transaction manager 
+ Scheduler 
+ Data manager
  + Recovery manager 
  + Cache manager 

Cap. 17, 18 
#line 
Issues to address:
+ Data must be protected in the face of a system failure
+ Data must not be corrupted simply because several error-free queries or database modifications are being done at once. 


Technique for resilience: 
+ log
  + Records securely history of database changes 
  + Undo/redo actions 

== Things that could go wrong

=== Failure modes 

==== Erroneous data entry 

Write constraints and triggers that detect data beliveed to be erroneous

==== Media fialures

Local failure of disk (only some bits). Detected by parity checks 

Head crashes, all disk unreadable
+ RAID shcemes. Lost disk may be restored
+ Mantian an archive. Copy of database, distributed among several sites 

==== Catastrophic failure 

Media holding database completely destroyed
+ explossions

Solutions: archiving and redundant

==== System failure 

System failures are problems that cause the state of a transaction to be lost

typical erros:
+ Power loss
+ Software erros 

Solution. logs all database changes in separte nonvolatile log and redundancy of that info. 

=== more about transactions 

The transaction is the unit of execution of database operations. 

Begins with: as soon opreatins on database are executed and end with "COMMIT" or "ROLLBACK"

Must:
+ atomically: all or nothing 

Transaction manager job. transactions are executed correctly.
+ issuing signas to log manager. necessay information in the form of "log records" can be stored on the log.


Assuring that concurrently executing transactiosn do not interfere with each other in ways that introduce errors 

he log manager maintains the log. It must deal with the buffer manager, 
since space for the log initially appears in main-memory buffers, and at certain 
times these buffers must be copied to disk

===  Correct Execution of Transactions

Database compose of "elements": value that can be accessed or modified by transactions 

Usually are one or more of:
+ Relations 
+ Disk blocks or pages 
+ Individuals tuples or objects 

*Database State*: value for each of its elements.

The *Correctness Principle*: If a transaction executes in the absence of any other transactions or system errors, and it starts with the database in a consistent state, then the database is also in a consistent state when the transaction ends.

+ Transaction atomic
+ Execute simultaneously precaution

=== Operations of transactions

There address spaces that interact in important way 
+ Space of disk blocks holding database elements
+ Virutal or main memory managed by buffer manager 
+ Local address space of transaction 

Read database element:
+ Brought to main memory buffer/s. Content of buffer can be read by transaction into its own address space 

Writing:
+ Created the new value in its own space. 
+ Value copied to appropiate buffer 

Buffer may or not be copied to disk immediately. That's responsability of buffer manager. 

Primitives:
+ INPUT(X): copy disk block containing database element X to memory buffer 
+ READ(x,t) copy database element X to transaction local variable t.
+ WRITE(X, t): copy value of local variable t to database element X in memory buffer 
+ OUTPUT(X): copy block containingX from its buffer to disk 

constraints
+ Databse element no larger than single block.
+ READ and WRITE issued by transactions 
+ OUTPUT and INPUT issued by buffer manager 


== Undo logging 

log is a file of log records, each telling something about what some transaction has done

Undoing the effects of transactions that may not have completed before the crash

=== Log Records

Log as file opened for appending only. 

*log manager job* of recording in the log each important event.

Logs: 

+ \<START \>: transaction T has begun.
+ \<COMMIT\>: Transaction T has completed successfully and will make no 
more changes to database elements. All changes should appear on disk, but we cannot be sure when we sure it that it's already there. 
+ \<ABORT\>: Transaciton T could not complete successfully
+ \<T, X, v\>: transaction T has changed database element X and its former value was v.

=== Undo-Logging Rules

+ If transaction T modifies database element X , then the log record of the form < T ,X ,v> must be written to disk before the new value of X is written to disk.
+ If a transaction commits, then its COMMIT log record must be written to 
disk only after all database elements changed by the transaction have 
been written to disk, but as soon thereafter as possible

And summarizing the rules before: transactions materal must be written to disk in following order: 

- The log records indicating changed database elements. (each element individdually)
- The changed database elements themselves. (each element individdually)
- The COMMIT log record.

The essential pol￾icy for undo logging is that we don't write the \<COMMIT T\> record until 
the OUTPUT actions for T are completed.

If there's start and not commit log. Transaction must be undone. We don't know when or what was stored. 