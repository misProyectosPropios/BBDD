#import "macros.typ": *

Estudiar:
- API Rest 
- Modelo Relacional
- Algebra Relacional
- Operaciones
- Propiedades de las operaciones 

#line

= Data model

it's a notation for describing data or Information
Consist in
- structure of the data
- Operations on the data: queries and modifications on the database
- Constrains on the data: make the data has some meaning, knowing something that it's represents

== important data models

- relation model:
- Semi-structured data model: XML

= Relation model

Based on tables (relations). It's as it was an array of C struct, but they are not stored as them
Operations:  table oriented. know something about all of things in a table 
Constraints: doens't allow in some components some values 

== semi Semi-structured

it's a tree of graphs. Represent data hierachically nested tagged elements.

operations: follow paths in a tree

Constraints: 
- data type of values associated with a tag.
- which data could be nested to a given tag.

== Other data models

Object orintation models

. values can have structure
- Relations can have associated methods

== Comparisons between data models

we want it to be fast. in that case, we preffered relational model

= Relational Model

Represent data using relations: two-dimensions table

== Attributes 

Names of columns in a relation. They appear at the top of a table. Describes meaning of the column below.

== Schemas

Name of a relation and the set of attributes.
Attributes in a schema it's a set. But to talk about relations we need some standard, so we treat it like lists. 

#ask()[why? I don't see the benefits]

== Tuples 

Rows of a relation. Tuples has one _*component*_ for each attribute of the relation

== Domains

each component should be atomic #arrow must be of some type. Cannot be a record structure like array, set, etc.

The order in which we mention the attributes it's irrelevant.

== Relation instances

a database changes over time. It has added, updated or deleted tuples. And, rarely the schema could change. An instence it's in some time the version of the database. 

== keys of relations

Set of attributes forms a key #iff we do not allow two tuple in the relation in all the attributes of the key.

= Defining relation schema in SQL

SQl consists in: Data Definition and Data manipulation (for queries)

There are three kinds of relations:

- Stored relations (tables). The ones we use commonly.
- Views: relations defined by a computation. They are constructed when needed.
- Temporary tables: constructed by SQL language processor when it performs its job executing queries and data modifications

```sql  
  CREATE TABLE name (
    attribute_name   type
  );
```

== Data types

- STRING 
  - CHAR: fixed length string 
  - VARCHAR: fixed length string up to n characters. 
Difference it's just implementation dependent 

- Bit strings
  - BIT:  bit strings of length n
  - BIT VARYING (n):  bit strings of length up to n

- Boolean:
  - BOOLEAN: can take
    - True
    - False
    - Unknown

- INT / INTEGER: number
- SHORTINT
Difference its implementation dependent

- DATE
- TIME

- FLOAT / REAL
- DOUBLE (more precission)
- DECIMAL: decimal number that takes up to n decimal digits


== Modifying relation schema

```sql DROP TABLE table_name```


ALTER TABLE 

Has two options: 

- ADD 
- DROP
```sql ALTER TABLE table_name option attribute```

== Default Values

When creating ```sql DEFAULT value```

== Declaring keys

- PRIMARY KEY 
- UNIQUE: if the key consists in more than one attribute 

= Algebraic Query language

It's useful because it's less powerfull than common languages

== What's an algebra?

operator and atomic operands

relation algebra: atomic operands are
- variables
- constants

== Operators 

- Set operations: 
  - union
  - intersection
  - Difference
- Selection of some tuples
- Proyection of some columns
- Operations to combine two relations
  - Cartesian Product
  - Joins
- Renaming of attributes. Doesn't affect tuples, but to a schema

=== Set operations

union $R union S$
Intersection $R inter S$
Difference $R - S$

+ R and S must have schemas with identical set of attributes. And types (domains) for each attribute must have the same in  R and s
+ Colums R and S must be ordered before, so the order is same for both relations

=== Proyection

Produce from a relation R a new relation  that has only some of R's columns

=== Selection

Produces a new relation with a  subset of R's tuples. the tuples are those who satisfy some condition $C$.

=== Cartesian Product 

Makes the cartesian product. Everyone meets everyone (talking about tuples)

=== Natural Joins

Given two relations we don't want all combinations, only pair tuples that match in some way $R natJoin S$. We join them by the attributes that are common to each one. All rows generated are called: _joined tuples_

If there are multiple rows that have the same values in both, it gives all combinations taking all the rows

=== Theta Joins

it's less restrictive than natural joins, giving us actually a way to take the tuples that we want.

+ Take the cartesian product
+ Select from the product only those tuples that satisfy the condition C

=== Combining Operations to Form Queries

Put the result of some operation to another operation.

=== Renaming attributes

To make it easier in some queries it's useful to change the name of the attributes

=== Relationships Among Operations

$ R inter S = R - (R - S) $

$ R natJoin_C S = sigma_C (R times S) $

The natural join of $R$ and $S$ can be expressed by starting with the product
$R times S$. We then apply the selection operator with a condition $C$ of the form

$ R.A_1 = S.A_1 " AND " R.A_2 = S.A_2 " AND " dots " AND " R.A_n = S.A_n $

$R natJoin S = pi_L (sigma_C (R times S))$

= Constraints on Relations

restrict the data that may be stored in a database

== Relational Algebra as a Constraint Language

- $R = empty$: There are no tuple in the result of R 
- $R subset.eq $ Every tuple in $R$ must be also in $S$

=== Referential Integrity Constraints

A value appearing in one context also appears in another, related context

$pi_A (R) subset.eq pi_B (S)$ (some attribute A and B)
=== Key Constraints

If an attribute (like name) is a Key, then every name must be unique. This implies that if two rows have the same name, they must be the exact same row (i.e., they must have the same address).

Using the notation above, it's possible to define precisely the constraints for keys.

+ Self-Product
+ Filter for Violations: Use Selection ($sigma$)
+ the result of this search must be the Empty Set (∅).

$ sigma_(text("MS1")."name" = text("MS2")."name" and text("MS1")."address" != text("MS2")."address") (text("MS1") times "MS2") = nothing $


