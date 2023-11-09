CREATE DATABASE IF NOT EXISTS quanlydiemthi;
USE quanlydiemthi;


CREATE TABLE subject
(
    subjectId  VARCHAR(4) PRIMARY KEY NOT NULL,
    subjectName VARCHAR(45)            NOT NULL,
    priority INT(11) NOT NULL
);

CREATE TABLE student
(
    studentId  VARCHAR(4) PRIMARY KEY NOT NULL,
    studentName VARCHAR(100)    NOT NULL,
    birthday DATE NOT NULL ,
    gender BIT(1) NOT NULL ,
    address TEXT NOT NULL ,
    phoneNumber VARCHAR(45)
);

CREATE TABLE mark
(
    subjectId      VARCHAR(4) NOT NULL ,
    studentId     VARCHAR(4) NOT NULL ,
    point    FLOAT(11) NOT NULL
);

-- TẠO KHÓA PHỤ CHO BẢNG mark
ALTER TABLE mark ADD CONSTRAINT pk_subject_student PRIMARY KEY (subjectId,studentId);
ALTER TABLE mark ADD CONSTRAINT fk_subject FOREIGN KEY (subjectId) REFERENCES subject (subjectId);
ALTER TABLE mark ADD CONSTRAINT fk_student FOREIGN KEY (studentId) REFERENCES student (studentId);