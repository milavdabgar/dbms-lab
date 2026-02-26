# Practical 13: Entity-Relationship Diagrams and Normalization

This practical focuses on database design theory: ER diagrams and normalization (up to 3NF).

## Overview

**Objectives:**
1. Design E-R diagrams for database management systems
2. Convert ER diagrams to relational schema
3. Apply normalization techniques (1NF, 2NF, 3NF)
4. Reduce data redundancy and improve database efficiency

## Part 1: Entity-Relationship (ER) Diagrams

### ER Diagram Components

#### 1. Entity
A real-world object or concept (person, place, thing, event).

- **Notation:** Rectangle
- **Example:** Student, Course, Professor

#### 2. Attribute
Properties or characteristics of an entity.

- **Simple Attribute:** Cannot be subdivided (e.g., Age)
- **Composite Attribute:** Can be subdivided (e.g., Name → First Name, Last Name)
- **Derived Attribute:** Calculated from other attributes (e.g., Age from Birth Date)
- **Multivalued Attribute:** Can have multiple values (e.g., Phone Numbers)
- **Key Attribute:** Uniquely identifies entity (underlined)

**Notation:**
- Simple: Oval
- Composite: Oval with connected sub-ovals
- Multivalued: Double oval
- Derived: Dashed oval

#### 3. Relationship
Association between two or more entities.

**Notation:** Diamond

#### 4. Cardinality
Number of entity instances participating in a relationship.

| Cardinality | Notation | Example |
|-------------|----------|---------|
| One-to-One (1:1) | 1:1 | Employee ↔ Office |
| One-to-Many (1:N) | 1:N | Department → Employees |
| Many-to-One (N:1) | N:1 | Employees ← Manager |
| Many-to-Many (M:N) | M:N | Students ↔ Courses |

#### 5. Participation
Defines whether all entity instances must participate in a relationship.

- **Total Participation:** Every entity must participate (double line)
- **Partial Participation:** Some entities may not participate (single line)

## Part 2: Sample ER Diagram - University Database

### Entities and Attributes

**STUDENT**
- student_id (PK)
- first_name
- last_name
- email
- date_of_birth
- enrollment_date

**COURSE**
- course_id (PK)
- course_code
- course_name
- credits
- department

**FACULTY**
- faculty_id (PK)
- first_name
- last_name
- email
- department
- hire_date

**ENROLLMENT** (Associative Entity)
- student_id (FK)
- course_id (FK)
- semester
- year
- grade

**ASSIGNMENT** (Associative Entity)
- faculty_id (FK)
- course_id (FK)
- semester
- year

### Relationships

1. **STUDENT enrolls_in COURSE** (M:N)
   - Resolved through ENROLLMENT entity
   - A student can enroll in many courses
   - A course can have many students

2. **FACULTY teaches COURSE** (M:N)
   - Resolved through ASSIGNMENT entity
   - A faculty can teach many courses
   - A course can be taught by many faculty (different semesters)

3. **FACULTY advises STUDENT** (1:N)
   - A faculty can advise many students
   - A student has one advisor

### ER Diagram (Text Representation)

```
┌─────────┐               ┌────────────┐               ┌────────┐
│ STUDENT │───enrolls_in──│ ENROLLMENT │──for_course───│ COURSE │
└─────────┘      M:N      └────────────┘      M:N      └────────┘
     │                                                        │
     │ M                                                    N │
     │ advised_by                                     taught_by
     │                                                        │
     ▼ 1                                                    M ▼
┌─────────┐                                          ┌────────────┐
│ FACULTY │──────────────teaches─────────────────────│ ASSIGNMENT │
└─────────┘                                          └────────────┘
```

### Relational Schema (Tables)

```sql
CREATE TABLE students (
    student_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    date_of_birth DATE,
    enrollment_date DATE,
    advisor_id NUMBER,
    FOREIGN KEY (advisor_id) REFERENCES faculty(faculty_id)
);

CREATE TABLE faculty (
    faculty_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100) UNIQUE,
    department VARCHAR2(50),
    hire_date DATE
);

CREATE TABLE courses (
    course_id NUMBER PRIMARY KEY,
    course_code VARCHAR2(20) UNIQUE,
    course_name VARCHAR2(100),
    credits NUMBER,
    department VARCHAR2(50)
);

CREATE TABLE enrollments (
    student_id NUMBER,
    course_id NUMBER,
    semester VARCHAR2(10),
    year NUMBER,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE assignments (
    faculty_id NUMBER,
    course_id NUMBER,
    semester VARCHAR2(10),
    year NUMBER,
    PRIMARY KEY (faculty_id, course_id, semester, year),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

## Part 3: Normalization

### What is Normalization?

**Normalization** is the process of organizing data to:
- Minimize redundancy
- Eliminate insertion, update, and deletion anomalies
- Ensure data integrity
- Improve query performance

### Data Anomalies

**1. Insertion Anomaly:** Cannot insert data without other required data
**2. Deletion Anomaly:** Deleting a row causes unintended loss of other data
**3. Update Anomaly:** Updating one row requires updating multiple rows

### First Normal Form (1NF)

**Rules:**
1. Each column contains atomic (indivisible) values
2. Each row is unique
3. No repeating groups or arrays

**Example - NOT in 1NF:**
```
STUDENT_COURSES
┌────────────┬─────────────┬──────────────────────────┐
│ StudentID  │ StudentName │ Courses                  │
├────────────┼─────────────┼──────────────────────────┤
│ 101        │ John        │ Math, Physics, Chemistry │
│ 102        │ Jane        │ Biology, Math            │
└────────────┴─────────────┴──────────────────────────┘
```

**Converted to 1NF:**
```
STUDENT_COURSES
┌────────────┬─────────────┬───────────┐
│ StudentID  │ StudentName │ Course    │
├────────────┼─────────────┼───────────┤
│ 101        │ John        │ Math      │
│ 101        │ John        │ Physics   │
│ 101        │ John        │ Chemistry │
│ 102        │ Jane        │ Biology   │
│ 102        │ Jane        │ Math      │
└────────────┴─────────────┴───────────┘
```

### Second Normal Form (2NF)

**Rules:**
1. Must be in 1NF
2. No partial dependencies (all non-key attributes must depend on the entire primary key)

**Example - In 1NF but NOT in 2NF:**
```
ENROLLMENT (Composite PK: StudentID + CourseID)
┌────────────┬──────────┬─────────────┬─────────────┬────────┐
│ StudentID  │ CourseID │ StudentName │ CourseName  │ Grade  │
├────────────┼──────────┼─────────────┼─────────────┼────────┤
│ 101        │ CS101    │ John        │ Programming │ A      │
│ 101        │ CS102    │ John        │ Database    │ B+     │
└────────────┴──────────┴─────────────┴─────────────┴────────┘
```

**Problem:** StudentName depends only on StudentID (partial dependency)  
**Problem:** CourseName depends only on CourseID (partial dependency)

**Converted to 2NF:**
```
STUDENTS
┌────────────┬─────────────┐
│ StudentID  │ StudentName │
├────────────┼─────────────┤
│ 101        │ John        │
└────────────┴─────────────┘

COURSES
┌──────────┬─────────────┐
│ CourseID │ CourseName  │
├──────────┼─────────────┤
│ CS101    │ Programming │
│ CS102    │ Database    │
└──────────┴─────────────┘

ENROLLMENT
┌────────────┬──────────┬────────┐
│ StudentID  │ CourseID │ Grade  │
├────────────┼──────────┼────────┤
│ 101        │ CS101    │ A      │
│ 101        │ CS102    │ B+     │
└────────────┴──────────┴────────┘
```

### Third Normal Form (3NF)

**Rules:**
1. Must be in 2NF
2. No transitive dependencies (non-key attributes must not depend on other non-key attributes)

**Example - In 2NF but NOT in 3NF:**
```
STUDENTS
┌────────────┬─────────────┬────────────┬─────────────────┐
│ StudentID  │ StudentName │ DeptCode   │ DeptName        │
├────────────┼─────────────┼────────────┼─────────────────┤
│ 101        │ John        │ CS         │ Computer Science│
│ 102        │ Jane        │ CS         │ Computer Science│
│ 103        │ Bob         │ EE         │ Electrical Eng  │
└────────────┴─────────────┴────────────┴─────────────────┘
```

**Problem:** DeptName depends on DeptCode (transitive dependency)  
StudentID → DeptCode → DeptName

**Converted to 3NF:**
```
STUDENTS
┌────────────┬─────────────┬────────────┐
│ StudentID  │ StudentName │ DeptCode   │
├────────────┼─────────────┼────────────┤
│ 101        │ John        │ CS         │
│ 102        │ Jane        │ CS         │
│ 103        │ Bob         │ EE         │
└────────────┴─────────────┴────────────┘

DEPARTMENTS
┌────────────┬─────────────────┐
│ DeptCode   │ DeptName        │
├────────────┼─────────────────┤
│ CS         │ Computer Science│
│ EE         │ Electrical Eng  │
└────────────┴─────────────────┘
```

## Part 4: Library Management System Example

### Initial Design (Unnormalized)

```
LIBRARY
┌────────┬───────────┬────────────┬────────────┬───────────┬────────────┬─────────────┐
│ BookID │ Title     │ Authors    │ Publisher  │ MemberID  │ MemberName │ BorrowDate  │
├────────┼───────────┼────────────┼────────────┼───────────┼────────────┼─────────────┤
│ B001   │ Database  │ Elmasri,   │ Pearson    │ M101      │ John       │ 2024-01-15  │
│        │ Systems   │ Navathe    │            │           │            │             │
└────────┴───────────┴────────────┴────────────┴───────────┴────────────┴─────────────┘
```

### After Normalization (3NF)

**BOOKS:**
```sql
CREATE TABLE books (
    book_id VARCHAR2(10) PRIMARY KEY,
    title VARCHAR2(200),
    publisher_id NUMBER,
    publication_year NUMBER,
    isbn VARCHAR2(20) UNIQUE,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);
```

**AUTHORS:**
```sql
CREATE TABLE authors (
    author_id NUMBER PRIMARY KEY,
    author_name VARCHAR2(100),
    country VARCHAR2(50)
);
```

**BOOK_AUTHORS** (M:N relationship):
```sql
CREATE TABLE book_authors (
    book_id VARCHAR2(10),
    author_id NUMBER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
```

**PUBLISHERS:**
```sql
CREATE TABLE publishers (
    publisher_id NUMBER PRIMARY KEY,
    publisher_name VARCHAR2(100),
    address VARCHAR2(200)
);
```

**MEMBERS:**
```sql
CREATE TABLE members (
    member_id VARCHAR2(10) PRIMARY KEY,
    member_name VARCHAR2(100),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    registration_date DATE
);
```

**BORROWINGS:**
```sql
CREATE TABLE borrowings (
    borrowing_id NUMBER PRIMARY KEY,
    book_id VARCHAR2(10),
    member_id VARCHAR2(10),
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
```

**BRANCHES:**
```sql
CREATE TABLE branches (
    branch_id NUMBER PRIMARY KEY,
    branch_name VARCHAR2(100),
    address VARCHAR2(200),
    phone VARCHAR2(20)
);
```

**BOOK_COPIES:**
```sql
CREATE TABLE book_copies (
    copy_id NUMBER PRIMARY KEY,
    book_id VARCHAR2(10),
    branch_id NUMBER,
    status VARCHAR2(20), -- Available, Borrowed, Maintenance
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);
```

## Summary

### Normalization Benefits

✅ **Reduced Redundancy:** Same data not stored multiple times  
✅ **Data Integrity:** Updates affect only one place  
✅ **Eliminates Anomalies:** No insertion, deletion, or update problems  
✅ **Efficient Storage:** Less disk space required  
✅ **Easier Maintenance:** Changes in one table don't cascade unnecessarily  

### When to Denormalize

Sometimes, for performance reasons, controlled denormalization is acceptable:
- Read-heavy applications
- Data warehousing
- Reporting databases
- When joins become too expensive

### Higher Normal Forms

- **BCNF (Boyce-Codd Normal Form):** Stricter version of 3NF
- **4NF:** Eliminates multivalued dependencies
- **5NF:** Eliminates join dependencies

Most applications only need up to 3NF for practical purposes.

## Lab Manual Exercises

1. **University Database (Completed Above)**
   - Design ER diagram
   - Normalize to 3NF
   
2. **Library Management System (Completed Above)**
   - Design ER diagram
   - Normalize to 3NF

## Tools for ER Diagrams

- **Draw.io:** Free online diagramming tool
- **Lucidchart:** Professional diagramming software
- **MySQL Workbench:** Database design tool with ER modeling
- **Oracle SQL Developer Data Modeler:** Oracle's free ER tool
- **ERDPlus:** Simple online ER diagram tool

## References

- Elmasri & Navathe: "Fundamentals of Database Systems"
- Date, C.J.: "An Introduction to Database Systems"
- GeeksforGeeks: Database Normalization
- W3Schools: SQL Tutorial

---

**Note:** This practical is primarily theoretical. Implement the normalized schemas in SQL using Practicals 3-4 as templates.
