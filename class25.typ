#import "macros.typ": *

Buscar para la próxima clase
+ Clave normal
+ Candidata
+ Superclave
+ Clave principal 
+ Dependencia funcional

#line

= *functional dependencies*: 
== Definition 
It's a generalization of the  idea of a key for a relation

Más formalmente:
Una dependencia funcional en una relacion $R$ es una proposición de la forma

"Si dos tuplas $R$ son iguales atributo a atributo (tienen los mismos valores en cada componente para cada atributo $A_1, A_2, dots.h, A_m$, entonces deben de _agree_ en otra lista de atributo $B_1, B_2, dots.h, B_m$"

Debemos ver que con los atributos podemos obtener uno y solo uno de cada una de todas las instancia si seguimos con los mismos atributos para obtener tal.

$ A_1 A_2  fd B_1 $ 

Quiere decir que todas las instancias de $A_1 A_2$, entonces $B_1$ debería de tener un único avlor posible


== Superkey

A set of attributes that contains a key is called a *superkey*, short for _“superset 
of a key”_.

== Clave candidata

Es una superclave minimal

== Clave Primaria

Es una clave candidata elegida por el diseñador para identificar la celda

== Key
An set of attributes it's a key $K$ #iff $K$ functionally determines all other attributes in the table. If you $K$ I can identify the entire tuple

== Closure Functional Dependency

It's given some root in a graph. Compute all the dependencys.
Then repeat until there's no node added. It's the union of all the nodes in the graph.

== Trivial dependencies

$ A_1 fd A_1 $

== Transitive rule

$ A_1 fd B_1 and B_1 fd C_1 then A_1 fd C_1 $

== Augmentation

$ A_1, dots A_n fd B_1, dots, B_m then A_1, dots A_n C_1 dots, C_k fd B_1, dots, B_m C_1 dots, C_k $

= Projecting a Set of Functional Dependencies.

Given
+ A relation $R$
+ A second relation $R_1$ (by proyection $R_1 = pi_{L}(R)$)
+ Set of functional dependencies that hold in R
+ Compute the closre

Algorithm

For every possible subset of attributes X that exists in your new table S:

+ *Compute the Closure* ($X^+$)
+ *Intersect with the New Table*: Find the intersection of that closure with the attributes in your new table S. $Y = X^+ inter S$
+ *Form the New Dependency*: For every attribute A in Y, if A is not already in X, then $X fd A$ is a functional dependency that holds in the new table.
+ *Simplify*


= Avoid redundancy: Normal forms

We want to avoid anomalies in the DDBB because:
- Redundancy: Information repeated. It could cost or be extremaly giant a database if it's not designed correctly
- Update anomalies: we could change the content in one tuple  and no in another and it could lead to inconsisteny
- Deletion anomalies: Set of vales becomes empty we could lose Information

== Descomposition
Descomposition of a relation R into S and T without redundancy
 + ${A_i,A_2, dots ,A_n} = {B_1, B_2, dots , B_m} union {C_1, C_2 , dots , C_k}$
 + $S = pi_{B_1, B_2, dots, B_m} (R)$
 + $T = pi_{C_1, C_2, dots, C_k} (R)$

 == Boyce-Codd Normal form
 
 A relation R is in BCNF #iff whenever there is a nontrivial FD $A_1 A_2 dots A_n -> B_1 B_2 dots B_m$ for R, it is the case that ${A_1, A_2, dots , A_n}$ is  a superkey for R.


#quote[
  Equivalent the left side of every nontrivial FD must contain a key
]

== Descomposition into BCNF


+ Check whether $R$ is in BCNF. If so, nothing more needs to be done.  Return ${R}$ as the answer
+ If there are BCNF violations, let one be $X fd Y$. Use Algorithm 3.7 to compute $X^+$. Choose $R_1 = R^+$ as one relation schema and let $R_2$ have attributes $X$ and those attributes of $R$ that are not in $X^+$.
+ Use Algorithm 3.12 to compute the sets of FD’s for $R_1$ and $R_2$, let these be $S_1$ and $S_2$, respectively
+ Descompose $R_1$ and $R_2$ again and again until they are BCNF

- Algorithm 3.7: Closure test
- Algorithm 3.12: Projecting a Set of Functional 


== Consequences of Descomposition

+ Elimination of anomalies
+ Recoverability of Information
+ Preservati

= Formas normales

Una Forma Normal (FN) es un conjunto de reglas o "estándares de calidad" que aplicamos al diseño de una base de datos para asegurar que esté organizada de la manera más eficiente posible.

== 1st Normal Form

- *Unique Identifies*: we can identify each tuple by some set of components.
- *Atomic values*: components represent unique things. Not many
- Each *column name* must be *unique*
- There must be *no repeating groups*

== 2nd Normal Form

All data should depend on the whole primary key

== 3rd Normal Form

The primary key must define all Non Key columns and Non-Key columns must not depend on any other non-key


Formalmente

Whenever $A_1 A_2 dots A_n fd  B_1 B_2 dots B_m$ is a nontrivial FD, either
${A_1 A_2 dots A_n}$ is a superkey, or those of $B_1 B_2 dots B_m$ that are not among the $A's$, are 
each a member of some key (not necessarily the same key).

== BCNF

Arriba

== Diferencia entre BCNF y 3NF

Es que permite dependencias funcionales hacia claves candidatas (primitivas)

Ejemplo: médico, paciente, especialidad

= MVD (Multivalued dependency)

It's is a statement about some rela￾tion R that when you fix the values for one set of attributes, then the values in 
certain other attributes are independent of the values of all the other attributes in the relation

$A_1, A_2, dots A_n mvd B_1, B_2, dots B_m$

For each pair of tuples t and u of relation R that agree on all the $A's$, we can find in $R$ some tuple _v_ that agrees:
+ With both t and u on the $A's$,
+ With t on the $B's$, and
+ With u on all attributes of R that axe not among the $A's$ or $B's$.