
 /********* A. BASIC QUERY *********/
-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by id;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by gender;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by birthday;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by scholarship;
-- 2. Môn học có tên bắt đầu bằng chữ 'T'

 select name from subject
 where subject.name like 'T%';

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
select name from student
 where student.name like '%i';
 -- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
  select name from faculty
 where faculty.name like '_n%';

-- 5. Sinh viên trong tên có từ 'Thị'
select name from student
 where student.name like '%Thị%';

-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
 select name from student
 where student.name between'A%' and 'M%';

-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
 select  name, scholarship, faculty_id from student
 where student.scholarship > 100000
 order by student.faculty_id desc;
-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
  select  name, scholarship, hometown from student
 where student.scholarship > 150000 and student.hometown ='Hà N?i';
-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
   select  name, scholarship, hometown,birthday from student
 where  student.birthday >= TO_DATE('01/01/1991', 'dd/mm/yyyy')
AND student.birthday <= TO_DATE('05/06/1992','dd/mm/yyyy');
-- 10. Những sinh viên có học bổng từ 80000 đến 150000
  select  name, scholarship, faculty_id from student 
 where student.scholarship>80000 and student.scholarship<150000;
-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
 select  name,lesson_quantity from subject
 where subject.lesson_quantity>30 and subject.lesson_quantity <45;
 
 /********* B. CALCULATION QUERY *********/
-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
  select scholarship, faculty_id,gender,id,name,
 case when student.scholarship>500000 then 'Học bổng cao'
      when student.scholarship<500000 then 'Mức trung bình'
      end scholarship
from student;
-- 2. Tính tổng số sinh viên của toàn trường
select count(1) total_student from student;
-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ..
select count(1) total_gender, gender from student
group by gender;
-- 4. Tính tổng số sinh viên từng khoa
select faculty.name faculty, count(1) total_faculty
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 5. Tính tổng số sinh viên của từng môn học
select subject.name , count(1) total_student from exam_management emt , subject
where emt.subject_id = subject.id
group by subject.name;
-- 6. Tính số lượng môn học mà sinh viên đã học
select student_id, count(distinct subject_id) total_subject from exam_management group by student_id;
-- 7. Tổng số học bổng của mỗi khoa
select faculty.name , count(1) total_faculty from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 8. Cho biết học bổng cao nhất của mỗi khoa
select faculty.name , count(1) total_faculty , max(scholarship) from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
select faculty.name, 
    count(case when gender = 'Nam' then 1 else 0 end) total_male,
    count(case when gender = 'N?' then 1 else 0 end) total_female
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
select to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY')) age, count(student.id) student_number 
from student 
group by to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY'));
-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
select count(1) , hometown from student
group by hometown
having count(1)>1;
-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
select student.name, subject_id, count(number_of_exam_taking) number_of_exam_taking
from exam_management emt,student
where student.id= emt.student_id
group by student.name, subject_id
having count(number_of_exam_taking) >= 2;
-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0
select avg(mark), student.name from exam_management emt, student
where student.id= emt.student_id
group by student.name
having avg(mark)>7;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1
select s.name, count(e.subject_id)  failed_subject
from student s
join exam_management e on s.id = e.student_id
where e.number_of_exam_taking = 1 and e.mark < 4
group by s.name
having count(e.subject_id) >= 2;
-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
select faculty.name, count(gender) student_count
from student, faculty
where student.faculty_id = faculty.id
    and gender = 'Nam'
group by faculty.name
having count(gender) >= 2;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
select f.name , count(scholarship)  total_faculty from student s, faculty f
where s.faculty_id= f.id and scholarship between 200000 and 300000
group by f.name
having count(scholarship)>=2;
-- 17. Cho biết sinh viên nào có học bổng cao nhất
select * 
from student
where scholarship = (select max(scholarship) from student);

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
select student.name, hometown, birthday 
from student
where to_char(birthday, 'MM') = '02' 
    and hometown = 'Hà Nội';


-- 2. Sinh viên có tuổi lớn hơn 20
select s.name, to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.birthday, 'YYYY')) age
from student s
where to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.birthday, 'YYYY')) > 30;

-- 3. Sinh viên sinh vào mùa xuân năm 1990
select s.name ,s.birthday from student s
where TO_CHAR(s.birthday,'YYYY') = 1990 and TO_CHAR(s.birthday,'MM') in ('01','02','03');


/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
select f.name name_faculty , s.name name_sutdent from student s join faculty f 
on f.id = s.faculty_id 
where f.name in ('Anh - Văn' , 'Vật lý');
-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN select f.name name_faculty , s.name name_sutdent from student s join faculty f 
select f.name name_faculty , s.name name_sutdent, s.gender from student s join faculty f 
on f.id = s.faculty_id 
where f.name in ('Anh - Văn' , 'Tin học')  and s.gender='Nam';
-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
