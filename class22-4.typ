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

Two cases: 
+ Transaction with commit record seen. Do nothing. Must not be undone 
+ T incomplete transaction or aborted transaction. Recovery manager must change the value of X in database to V.

Recovering Crashes are idempotent.

=== Checkpointing

Problem: we do not keep ALL history logs, only the last ones. But since when? Checkpointing

- Stop accepting new transactions.
- Wait until all currently active transactions commit or abort and have 
written a COMMIT or ABORT record on the log.
- Flush the log to disk.
- Write a log record <CKPT>, and flush the log again.
- Resume accepting transactions.

=== Nonquiescent Checkpointing

 allows new transactions to enter the 
system during the checkpoint

Steps:

+ Write log record \<Start CKPT (T1, ...) Tk\> and flush log 
+ Wait unitl all of T1, ... Tk commit or abort.
When all of T1, ..., Tk have completed, write \<END CKPT\> and flush log

== Redo Logging 

Redo vs undo logging
+ While undo logging cancels the effect of incomplete transactions and ig￾nores committed ones during recovery, redo logging ignores incomplete  transactions and repeats the changes made by committed transactions
+ While undo logging requires us to write changed database elements to  disk before the COMMIT log record reaches disk, redo logging requires that  the COMMIT record appear on disk before any changed values reach disk
+  old values of changed database elements are exactly what we  need to recover when the undo rules U\ and U2 are followed, to recover  using redo logging, we need the new values instead.

Write ahead logging rule 

Order:
+ The log records indicating changed database elements.
+ The COMMIT log record.
+ The changed database elements themselves

*Order of Redo matters* (from eariliest to latest)



Recover using redo 

+ Identify committed transactions 
+ Scan log forward from beginning
  + For each log record 
    + If T is not commited transaction: nothing 
    + If T is commited transaction, write value v for database element X.
== Undo / redo loggin 

=== Rules 

update log record that we write when a database element changes value has four components. Record < T ,X ,v,w > means that transaction T changed the value of database element X; its former value was v, and its new value is w

- before modifying database element. Update record < T, X, v, W >
- < COMMIT T> log  record can precede or follow any of the changes to the database elements on 
disk.

=== Recovery 

+ Redo all the committed transactions in the order earliest-first, and
+ Undo all the incomplete transactions in the order latest-first.

=== Checkpointing

+ Write a < START CKPT (T1, .. . , Tk)> record to the log, where T1,... , Tk are all the active transactions, and flush the log.
+ Write to disk all the buffers that are dirty; i.e., they contain one or more 
changed database elements. Unlike redo logging, we flush all dirty buffers, not just those written by committed transactions.
+  Write an < END CKPT > record to the log, and flush the log

== Protecting Against M edia Failures

=== The archive 

Archiving: copy of database separate from database itself. 

TO mantain it the most same as the original, we could use logs and send them when created 

+ Full dump: entire database copied
+ Incremental dump: only those database elmeent changed, after _full dump_

 === Nonquiescent Archiving

 nonquiescent dump copies the database elements in some fixed order, 
possibly while those elements are being changed by executing transactions.


+ Write a log record < START DUMP>
+ Perform a checkpoint appropriate for whichever logging method is being used.
+ Perform a full or incremental dump of the data disk(s), as desired, making sure that the copy of the data has reached the secure, remote site.
+ Make sure that enough of the log has been copied to the secure, remote site that at least the prefix of the log up to and including the checkpoint in item (2) will survive a media failure of the database.
+ Write a log record < END DUMP>.

=== Recovery Using an Archive and Log

+ Restore the database from the archive.
  + Find the most recent full dump and reconstruct the database from it (i.e., copy the archive into the database).
  + If there are later incremental dumps, modify the database according to each, earliest first.
+ Modify the database using the surviving log. Use the method of recovery appropriate to the log method being used.

= Concurrency control

Transaction manager and scheduler 
Scheduler: regulate of timing of indiviaul steps of different transactions. 

serializability is stronger: Conflict-serializability (used)

== Serial and serializable schedules 
=== Schedules 


schedule is a sequence of the important actions taken by one or more trans￾actions

=== Serial Schedules 

Schedule serial if its actions consist of all the actions of one transaction, then all the actions of another transaction, and so on. No mixing of the actions is allowed.

schedule S is serializable if there is a serial 
schedule S' such that for every initial database state, the effects of S and S'
are the same

=== The Effect of Transaction Semantics

Any database element A that a transaction T writes is given a value that depends on the database state in such a way that no arithmetic coincidences occur

=== Notation for Transactions and Schedules

- Actions are:
  - R_T(X): reads database element X 
  - W_T(X): writes database element X
- Transaction T_i sequence of actions with subscript i
- Schedule S of set of transaction T is a sequence of actions in which for each transaction Ti in T , the actions of Ti appear in S in the same order that they appear in the definition of Tj itself.

== Conflic serializability

It's based on the idea of a conflict: a pair of consecutive actions in a schedule such that, if their order is interchanged, then the behavior of at least one of the transactions involved can change.

=== Conflicts 

Any two actions of different transactions may 
be swapped unless:
+ They involve the same database element, and
+  At least one is a write

*Conflict-equivalent* if they can be turned one 
into the other by a sequence of nonconflicting swaps of adjacent actions. 

=== Precedence Graphs and a Test for Conflict-Serializability

T1 takes precedence over T2 if there are actions such that: 

+ Ai is ahead of A2 in S,
+ Both A \ and A2 involve the same database element, and
+ At least one of A\ and A2 is a write action

Use this precedence as a graph. 
Nodes: transactions of schedule S 


==== Not necessary

Case: Wi(Y); wi(X); w2(Y); w2(X); w^X);
And this schedule: wi(Y); w2 (Y); w2 (X); Wi(X); w3 (X);

We construct precedence graph and ask is there are any cycles. 
+ Acyclic: S is conflict serializable 
+ Cyclic: not 


== Enforcing Serializability by Locks

Scheudler: uses locks to prevent unserializable behavior. 

=== Locks
Transactions must request and release locks

Notation:
+ u_l(X): unlock 
+ l_u(X): lock

Use of locks proper
- Consistency of Transactions:
  + ransaction can only read or write an element if it previously was granted a lock on that element and hasn't yet released the lock.
  + transaction locks an element, it must later unlock that element
+ Legality of schedules: Locks must have their intended meaning: no two transactions may have locked the same element without one having first released the lock

=== The Locking Scheduler

Scheduler job: grant requests if and only if the 
request will result in a legal schedule

Scheduler only modifies this relation Locks (element, transaction),

=== Two-Phase Locking (2PL)

Guarantee that a legal schedule of consistent transactions is conflict￾serializable

+ In every transaction, all lock actions precede all unlock actions.

Locks are obtained and seconds pahse: locks are relinquised. 

== Locking System s W ith Several Lock M odes

=== Shared and Exclusive Locks

+ sl_i(X) transaction T_i request a shared lock on database element X 
+ xl_i(X) for T_i request an exclusive lock on X

Requiriments 
+ Consistency of transactions: ransaction may not write without holding an exclusive lock, and you may not read without holding some lock. 
  + A read action ri(X) must be preceded by sli(X) or xk(X), with no intervening Ui(X).
  + A write action Wi(X) must be preceded by xli(X), with no interven￾ing Ui{X).
+ Two phase locking of transactions: Locking must precede unlocking
+ Legality of schedules:  element may either be locked exclusively by one transaction or by several in shared mode, but not both
  + xl_i(X): appears in schedule: cannot be following xl_j or sl_j for some j other than i wihtout an u_i(X)
  + sl_i(X) appears in schedule then there cannot be following xl_j(X) for j  $!=$ i without intervening u_i(X)

=== Compatibility Matrices
A convenient way to describe lock-management policies. It has a row and column for each lock mode. The rows correspond to a lock that is already held on an element X by another transaction, and the columns correspond to the mode of a lock on X that is requested.

=== Upgrading Locks

Problems with multiple shared locks, causing a deadlock.

=== Update Locks

Fix problem with Update lock.
 update lock uli(X) gives transaction T j only the privi￾lege to read X , not to write X

Only update lock can be updated to write lock later. 
Read lock doesn't. 

Can grant update lock on X when there are update locks. Prevents additionals locks of any kind when there's an update lock on X. 

=== Increment locks 

Operate on database only by incrementing or decrementing stored values. Tehy commute with each other. (a + b) = b + a

== Architecture Scheduler 
Principles 
+ Transactions do not request locks or cannot be relied upon to do so 
+ Transactions do not release locks 

Mantains a lock table. 