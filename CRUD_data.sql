USE quanlydiemthi;

/*
 Bài 2: Cập nhật dữ liệu [10 điểm]:
- Sửa tên sinh viên có mã `S004` thành “Đỗ Đức Mạnh”.
 */
UPDATE student
SET studentName = 'Đỗ Đức Mạnh'
WHERE studentId = 'S004';
SELECT *
FROM student;

--  Sửa tên và hệ số môn học có mã `MH05` thành “NgoạiNgữ” và hệ số là 1.
UPDATE subject
SET subjectName ='Ngoại Ngữ',
    priority=1
WHERE subjectId = 'MH05';
SELECT *
FROM subject;


-- Cập nhật lại điểm của học sinh có mã `S009` thành (MH01 : 8.5, MH02 : 7,MH03 : 5.5, MH04 : 6,MH05 : 9).
UPDATE mark
SET point = CASE subjectId
                WHEN 'MH01' THEN 8.5
                WHEN 'MH02' THEN 7
                WHEN 'MH03' THEN 5.5
                WHEN 'MH04' THEN 6
                WHEN 'MH05' THEN 9
                ELSE point
    END
WHERE studentId = 'S009';
SELECT *
FROM mark;

/*
 3. Xoá dữ liệu[10 điểm]:
- Xoá toàn bộ thông tin của học sinh có mã `S010` bao gồm điểm thi ở bảng MARK và thông tin học sinh
này ở bảng STUDENT.
 */
DELETE
FROM mark
WHERE studentId = 'S010';
DELETE
FROM student
WHERE studentId = 'S010';


/*
 Bài 3: Truy vấn dữ liệu [25 điểm]:
1. Lấy ra tất cả thông tin của sinh viên trong bảng Student . [4 điểm]
2. Hiển thị tên và mã môn học của những môn có hệ số bằng 1. [4 điểm]
3. Hiển thị thông tin học sinh bào gồm: mã học sinh, tên học sinh, tuổi (bằng năm hiện tại trừ
năm sinh) , giới tính (hiển thị nam hoặc nữ) và quê quán của tất cả học sinh. [4 điểm]
4. Hiển thị thông tin bao gồm: tên học sinh, tên môn học , điểm thi của tất cả học sinh của môn
Toán và sắp xếp theo điểm giảm dần. [4 điểm]
5. Thống kê số lượng học sinh theo giới tính ở trong bảng (Gồm 2 cột: giới tính và số lượng).
[4 điểm]
6. Tính tổng điểm và điểm trung bình của các môn học theo từng học sinh (yêu cầu sử dụng hàm
để tính toán) , bảng gồm mã học sinh, tên hoc sinh, tổng điểm và điểm trung bình. [5 điểm]
 */

SELECT s.studentId   AS "Mã sinh viên",
       s.studentName AS "Họ và Tên",
       s.birthday,
       CASE
           WHEN s.gender = 1 THEN 'Nam'
           ELSE 'Nữ'
           END       AS "Giới tính",
       s.address     AS "Địa chỉ",
       s.phoneNumber AS "Số điện thoại"
FROM student s;


SELECT sb.subjectId   AS "Mã môn học",
       sb.subjectName AS "Tên Môn học"
FROM subject sb
WHERE priority = 1;

/*
 Hiển thị thông tin học sinh bào gồm: mã học sinh, tên học sinh, tuổi (bằng năm hiện tại trừ
năm sinh) , giới tính (hiển thị nam hoặc nữ) và quê quán của tất cả học sinh. [4 điểm]
 */
SELECT s.studentId                           AS "Mã sinh viên",
       s.studentName                         AS "Họ và Tên",
       YEAR(CURRENT_DATE) - YEAR(s.birthday) AS "Tuổi",
       CASE
           WHEN s.gender = 1 THEN 'Nam'
           ELSE 'Nữ'
           END                               AS "Giới tính",
       s.address                             AS "Quê quán"
FROM student s;


/*
 4. Hiển thị thông tin bao gồm: tên học sinh, tên môn học , điểm thi của tất cả học sinh của môn
Toán và sắp xếp theo điểm giảm dần. [4 điểm]
 */
SELECT s.studentName  AS "Tên học sinh",
       sb.subjectName AS "Tên môn học",
       m.point        AS "Điểm thi"
FROM student s
         JOIN mark m ON s.studentId = m.studentId
         JOIN subject sb ON m.subjectId = sb.subjectId
WHERE sb.subjectName = 'Toán'
ORDER BY m.point DESC;

/*
 5. Thống kê số lượng học sinh theo giới tính ở trong bảng (Gồm 2 cột: giới tính và số lượng).
[4 điểm]
 */
SELECT CASE
           WHEN gender = 1 THEN 'Nam'
           ELSE 'Nữ'
           END  AS "Giới tính",
       COUNT(*) AS "Số lượng"
FROM student
GROUP BY gender;

/*
 6. Tính tổng điểm và điểm trung bình của các môn học theo từng học sinh (yêu cầu sử dụng hàm
để tính toán) , bảng gồm mã học sinh, tên hoc sinh, tổng điểm và điểm trung bình. [5 điểm]
 */
SELECT s.studentId   AS "Mã học sinh",
       s.studentName AS "Tên học sinh",
       SUM(m.point)  AS "Tổng điểm",
       AVG(m.point)  AS "Điểm trung bình"
FROM student s
         LEFT JOIN mark m ON s.studentId = m.studentId
GROUP BY s.studentId, s.studentName;


/*
 Bài 4: Tạo View, Index, Procedure [20 điểm]:
 */

/*
 1. Tạo VIEW có tên STUDENT_VIEW lấy thông tin sinh viên bao gồm : mã học sinh, tên học
sinh, giới tính , quê quán . [3 điểm]
 */
CREATE VIEW STUDENT_VIEW AS
SELECT studentId   AS "Mã học sinh",
       studentName AS "Tên học sinh",
       CASE
           WHEN gender = 1 THEN 'Nam'
           ELSE 'Nữ'
           END     AS "Giới tính",
       address     AS "Quê quán"
FROM student;

/*
 2. Tạo VIEW có tên AVERAGE_MARK_VIEW lấy thông tin gồm:mã học sinh, tên học sinh,
điểm trung bình các môn học . [3 điểm]
 */
CREATE VIEW AVERAGE_MARK_VIEW AS
SELECT s.studentId   AS "Mã học sinh",
       s.studentName AS "Tên học sinh",
       AVG(m.point)  AS "Điểm trung bình các môn học"
FROM student s
         LEFT JOIN mark m ON s.studentId = m.studentId
GROUP BY s.studentId, s.studentName;

/*
 3. Đánh Index cho trường `phoneNumber` của bảng STUDENT. [2 điểm]
 */
CREATE INDEX index_phoneNumber ON student (phoneNumber);

/*
 4. Tạo các PROCEDURE sau:
- Tạo PROC_INSERTSTUDENT dùng để thêm mới 1 học sinh bao gồm tất cả
thông tin học sinh đó. [4 điểm]
 */

DELIMITER &&
CREATE PROCEDURE PROC_INSERTSTUDENT(
    IN in_studentId VARCHAR(4),
    IN in_studentName VARCHAR(100),
    IN in_birthday DATE,
    IN in_gender BIT(1),
    IN in_address TEXT,
    IN in_phoneNumber VARCHAR(45)
)
BEGIN
    INSERT INTO student(studentId, studentName, birthday, gender, address, phoneNumber)
    VALUES (in_studentId, in_studentName, in_birthday, in_gender, in_address, in_phoneNumber);
END;
&&
DELIMITER ;

-- Tạo PROC_UPDATESUBJECT dùng để cập nhật tên môn học theo mã môn học.

DELIMITER &&
CREATE PROCEDURE PROC_UPDATESUBJECT(
    IN in_subjectId VARCHAR(4),
    IN in_newSubjectName VARCHAR(100)
)
BEGIN
    UPDATE subject
    SET subjectName = in_newSubjectName
    WHERE subjectId = in_subjectId;
END;
&&
DELIMITER ;

/*
 - Tạo PROC_DELETEMARK dùng để xoá toàn bộ điểm các môn học theo mã học
sinh và trả về số bản ghi đã xóa.
 */

DELIMITER &&
CREATE PROCEDURE PROC_DELETEMARK(
    IN in_studentId VARCHAR(4),
    OUT out_deletedCount INT
)
BEGIN
    DECLARE deleteCount INT;

    DELETE
    FROM mark
    WHERE studentId = in_studentId;

    SET deleteCount = ROW_COUNT();
    SET out_deletedCount = deleteCount;
END;
&&
DELIMITER ;