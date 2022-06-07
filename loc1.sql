
 /********* A. BASIC QUERY *********/
-- 1. Li?t k� danh s�ch sinh vi�n s?p x?p theo th? t?:
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by id;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by gender;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by birthday;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by scholarship;
-- 2. M�n h?c c� t�n b?t ??u b?ng ch? 'T'

 select name from subject
 where subject.name like 'T%';

-- 3. Sinh vi�n c� ch? c�i cu?i c�ng trong t�n l� 'i'
select name from student
 where student.name like '%i';
 -- 4. Nh?ng khoa c� k� t? th? hai c?a t�n khoa c� ch?a ch? 'n'
  select name from faculty
 where faculty.name like '_n%';

-- 5. Sinh vi�n trong t�n c� t? 'Th?'
select name from student
 where student.name like '%Th?%';

-- 6. Sinh vi�n c� k� t? ??u ti�n c?a t�n n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? t�n sinh vi�n
 select name from student
 where student.name between'A%' and 'M%';

-- 7. Sinh vi�n c� h?c b?ng l?n h?n 100000, s?p x?p theo m� khoa gi?m d?n
 select  name, scholarship, faculty_id from student
 where student.scholarship > 100000
 order by student.faculty_id desc;
 -- 8. Sinh vi�n c� h?c b?ng t? 150000 tr? l�n v� sinh ? H� N?i
  select  name, scholarship, hometown from student
 where student.scholarship > 150000 and student.hometown ='H� N?i';
-- 9. Nh?ng sinh vi�n c� ng�y sinh t? ng�y 01/01/1991 ??n ng�y 05/06/1992
   select  name, scholarship, hometown,birthday from student
 where  student.birthday >= TO_DATE('01/01/1991', 'dd/mm/yyyy')
AND student.birthday <= TO_DATE('05/06/1992','dd/mm/yyyy');
-- 10. Nh?ng sinh vi�n c� h?c b?ng t? 80000 ??n 150000
  select  name, scholarship, faculty_id from student 
 where student.scholarship>80000 and student.scholarship<150000;
-- 11. Nh?ng m�n h?c c� s? ti?t l?n h?n 30 v� nh? h?n 45
 select  name,lesson_quantity from subject
 where subject.lesson_quantity>30 and subject.lesson_quantity <45;
 
 /********* B. CALCULATION QUERY *********/
 1--Cho bi?t th�ng tin v? m?c h?c b?ng c?a c�c sinh vi�n, g?m: M� sinh vi�n, Gi?i t�nh, M� 
  select scholarship, faculty_id,gender,id,name,
 case when student.scholarship>500000 then 'H?c b?ng cao'
      when student.scholarship<500000 then 'M?c trung b�nh'
      end scholarship
from student;
-- 2. T�nh t?ng s? sinh vi�n c?a to�n tr??ng
select count(1) total_student from student;
-- 3. T�nh t?ng s? sinh vi�n nam v� t?ng s? sinh vi�n n?.
select count(1) total_gender, gender from student
group by gender;
-- 4. T�nh t?ng s? sinh vi�n t?ng khoa
select faculty.name faculty, count(1) total_faculty
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 5. T�nh t?ng s? sinh vi�n c?a t?ng m�n h?c
select subject.name , count(1) total_student from exam_management emt , subject
where emt.subject_id = subject.id
group by subject.name;
-- 6. T�nh s? l??ng m�n h?c m� sinh vi�n ?� h?c
select student_id, count(distinct subject_id) total_subject from exam_management group by student_id;
-- 7. S? l??ng h?c b?ng c?a m?i khoa
select faculty.name , count(1) total_faculty from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 8. Cho bi?t h?c b?ng cao nh?t c?a m?i khoa
select faculty.name , count(1) total_faculty , max(scholarship) from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 9. Cho bi?t t?ng s? sinh vi�n nam v� t?ng s? sinh vi�n n? c?a m?i khoa
select faculty.name, 
    count(case when gender = 'Nam' then 1 else 0 end) total_male,
    count(case when gender = 'N?' then 1 else 0 end) total_female
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 10. Cho bi?t s? l??ng sinh vi�n theo t?ng ?? tu?i
select to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY')) age, count(student.id) student_number 
from student 
group by to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY'));
-- 11. Cho bi?t nh?ng n?i n�o c� �t nh?t 2 sinh vi�n ?ang theo h?c t?i tr??ng
select count(1) , hometown from student
group by hometown
having count(1)>1;
-- 12. Cho bi?t nh?ng sinh vi�n thi l?i �t nh?t 2 l?n
select student.name, subject_id, count(number_of_exam_taking) number_of_exam_taking
from exam_management emt,student
where student.id= emt.student_id
group by student.name, subject_id
having count(number_of_exam_taking) >= 2;
-- 13. Cho bi?t nh?ng sinh vi�n nam c� ?i?m trung b�nh l?n 1 tr�n 7.0 
select avg(mark), student.name from exam_management emt, student
where student.id= emt.student_id
group by student.name
having avg(mark)>7;

-- 14. Cho bi?t danh s�ch c�c sinh vi�n r?t �t nh?t 2 m�n ? l?n thi 1
select s.name, count(e.subject_id) failed_subject
from student s
join exam_management e on s.id = e.student_id
where e.number_of_exam_taking = 1 and e.mark < 4
group by s.name
having count(e.subject_id) >= 2
-- 15. Cho bi?t danh s�ch nh?ng khoa c� nhi?u h?n 2 sinh vi�n n?
select faculty.name, count(gender) student_count
from student, faculty
where student.faculty_id = faculty.id
    and gender = 'N?'
group by faculty.name
having count(gender) > 2;
-- 16. Cho bi?t nh?ng khoa c� 2 sinh vi�n ??t h?c b?ng t? 200000 ??n 300000
select faculty_id, count(student.id) student_number
from student
where scholarship between 200000 and 300000
group by faculty_id
having count(id) = 2;
-- 17. Cho bi?t sinh vi�n n�o c� h?c b?ng cao nh?t
select * 
from student
where scholarship = (select max(scholarship) from student);

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh vi�n c� n?i sinh ? H� N?i v� sinh v�o th�ng 02
select student.name, hometown, bithday 
from student
where to_char(bithday, 'MM') = '02' 
    and hometown = 'H� N?i';


-- 2. Sinh vi�n c� tu?i l?n h?n 30 
select s.name, to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.bithday, 'YYYY')) age
from student s
where to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.bithday, 'YYYY')) > 30;


