
 /********* A. BASIC QUERY *********/
-- 1. Li?t kê danh sách sinh viên s?p x?p theo th? t?:
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by id;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by gender;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by birthday;
select id , name , gender,birthday,hometown,scholarship ,faculty_id from student
order by scholarship;
-- 2. Môn h?c có tên b?t ??u b?ng ch? 'T'

 select name from subject
 where subject.name like 'T%';

-- 3. Sinh viên có ch? cái cu?i cùng trong tên là 'i'
select name from student
 where student.name like '%i';
 -- 4. Nh?ng khoa có ký t? th? hai c?a tên khoa có ch?a ch? 'n'
  select name from faculty
 where faculty.name like '_n%';

-- 5. Sinh viên trong tên có t? 'Th?'
select name from student
 where student.name like '%Th?%';

-- 6. Sinh viên có ký t? ??u tiên c?a tên n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? tên sinh viên
 select name from student
 where student.name between'A%' and 'M%';

-- 7. Sinh viên có h?c b?ng l?n h?n 100000, s?p x?p theo mã khoa gi?m d?n
 select  name, scholarship, faculty_id from student
 where student.scholarship > 100000
 order by student.faculty_id desc;
 -- 8. Sinh viên có h?c b?ng t? 150000 tr? lên và sinh ? Hà N?i
  select  name, scholarship, hometown from student
 where student.scholarship > 150000 and student.hometown ='Hà N?i';
-- 9. Nh?ng sinh viên có ngày sinh t? ngày 01/01/1991 ??n ngày 05/06/1992
   select  name, scholarship, hometown,birthday from student
 where  student.birthday >= TO_DATE('01/01/1991', 'dd/mm/yyyy')
AND student.birthday <= TO_DATE('05/06/1992','dd/mm/yyyy');
-- 10. Nh?ng sinh viên có h?c b?ng t? 80000 ??n 150000
  select  name, scholarship, faculty_id from student 
 where student.scholarship>80000 and student.scholarship<150000;
-- 11. Nh?ng môn h?c có s? ti?t l?n h?n 30 và nh? h?n 45
 select  name,lesson_quantity from subject
 where subject.lesson_quantity>30 and subject.lesson_quantity <45;
 
 /********* B. CALCULATION QUERY *********/
 1--Cho bi?t thông tin v? m?c h?c b?ng c?a các sinh viên, g?m: Mã sinh viên, Gi?i tính, Mã 
  select scholarship, faculty_id,gender,id,name,
 case when student.scholarship>500000 then 'H?c b?ng cao'
      when student.scholarship<500000 then 'M?c trung bình'
      end scholarship
from student;
-- 2. Tính t?ng s? sinh viên c?a toàn tr??ng
select count(1) total_student from student;
-- 3. Tính t?ng s? sinh viên nam và t?ng s? sinh viên n?.
select count(1) total_gender, gender from student
group by gender;
-- 4. Tính t?ng s? sinh viên t?ng khoa
select faculty.name faculty, count(1) total_faculty
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 5. Tính t?ng s? sinh viên c?a t?ng môn h?c
select subject.name , count(1) total_student from exam_management emt , subject
where emt.subject_id = subject.id
group by subject.name;
-- 6. Tính s? l??ng môn h?c mà sinh viên ?ã h?c
select student_id, count(distinct subject_id) total_subject from exam_management group by student_id;
-- 7. S? l??ng h?c b?ng c?a m?i khoa
select faculty.name , count(1) total_faculty from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 8. Cho bi?t h?c b?ng cao nh?t c?a m?i khoa
select faculty.name , count(1) total_faculty , max(scholarship) from student, faculty
where faculty.id = student.faculty_id
group by faculty.name;
-- 9. Cho bi?t t?ng s? sinh viên nam và t?ng s? sinh viên n? c?a m?i khoa
select faculty.name, 
    count(case when gender = 'Nam' then 1 else 0 end) total_male,
    count(case when gender = 'N?' then 1 else 0 end) total_female
from student, faculty
where student.faculty_id = faculty.id
group by faculty.name;
-- 10. Cho bi?t s? l??ng sinh viên theo t?ng ?? tu?i
select to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY')) age, count(student.id) student_number 
from student 
group by to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(birthday, 'YYYY'));
-- 11. Cho bi?t nh?ng n?i nào có ít nh?t 2 sinh viên ?ang theo h?c t?i tr??ng
select count(1) , hometown from student
group by hometown
having count(1)>1;
-- 12. Cho bi?t nh?ng sinh viên thi l?i ít nh?t 2 l?n
select student.name, subject_id, count(number_of_exam_taking) number_of_exam_taking
from exam_management emt,student
where student.id= emt.student_id
group by student.name, subject_id
having count(number_of_exam_taking) >= 2;
-- 13. Cho bi?t nh?ng sinh viên nam có ?i?m trung bình l?n 1 trên 7.0 
select avg(mark), student.name from exam_management emt, student
where student.id= emt.student_id
group by student.name
having avg(mark)>7;

-- 14. Cho bi?t danh sách các sinh viên r?t ít nh?t 2 môn ? l?n thi 1
select s.name, count(e.subject_id) failed_subject
from student s
join exam_management e on s.id = e.student_id
where e.number_of_exam_taking = 1 and e.mark < 4
group by s.name
having count(e.subject_id) >= 2
-- 15. Cho bi?t danh sách nh?ng khoa có nhi?u h?n 2 sinh viên n?
select faculty.name, count(gender) student_count
from student, faculty
where student.faculty_id = faculty.id
    and gender = 'N?'
group by faculty.name
having count(gender) > 2;
-- 16. Cho bi?t nh?ng khoa có 2 sinh viên ??t h?c b?ng t? 200000 ??n 300000
select faculty_id, count(student.id) student_number
from student
where scholarship between 200000 and 300000
group by faculty_id
having count(id) = 2;
-- 17. Cho bi?t sinh viên nào có h?c b?ng cao nh?t
select * 
from student
where scholarship = (select max(scholarship) from student);

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có n?i sinh ? Hà N?i và sinh vào tháng 02
select student.name, hometown, bithday 
from student
where to_char(bithday, 'MM') = '02' 
    and hometown = 'Hà N?i';


-- 2. Sinh viên có tu?i l?n h?n 30 
select s.name, to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.bithday, 'YYYY')) age
from student s
where to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(s.bithday, 'YYYY')) > 30;


