/* database yaratma komutu */

create database <DATABASE_NAME>


/* veri tipleri */

INT
DECIMAL 
VARCHAR
BLOB
DATE
TIMESTAMP

/*Tablo yaratma*/

CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20), --VARCHAR() içerisindeki sayı kaç karakter barındıracağını belirtir.
	major VARCHAR(20)
);

CREATE TABLE student (
	student_id INT,
	name VARCHAR(20),
	major VARCHAR(20),
	PRIMARY KEY(student_id) -- primary key tanımlamanın diğer bir yolu bu şekildedir.
);

DESCRIBE student -- student tablosundaki alanları veri tiplerini yani ayrıntıları verir.

DROP TABLE student -- student tablosunu silen komuttur. DESCRIBE komutu çalıştırılırsa böyle bir tablo yok uyarısı verir.

ALTER TABLE student ADD gpa DECIMAL; -- student tablosuna gpa isimli bir kolon ekler ve bunun tipi DECIMAL.

ALTER TABLE student DROP COLUMN gpa; -- bu komutla student tablosundaki gpa kolonu silinir.


/* DATA INSERT */

INSERT INTO student VALUES(
	1,		   -- student_id
	'Jack',    -- name
	'Biology'  -- major
); -- string veriler tek tırnakla yazılır


SELECT * FROM student; -- buradaki * student tablosundaki tüm veriyi işaret eder.

INSERT INTO student(student_id, name) VALUES(3, 'Claire') -- eğer tabloya tüm kolonlar olmadan veri kaydedilecekse bu şekilde yapılır.


CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20), NOT NULL -- NOT NULL bu kolonun boş geçilemeyeceği manasına gelir.
	major VARCHAR(20) UNIQUE -- UNIQUE bu kolona aynı değerin girilemeyeceği manasına gelir.
);


CREATE TABLE student (
	student_id INT PRIMARY KEY,
	name VARCHAR(20), 
	major VARCHAR(20) DEFAULT 'undecided' -- DEFAULT eğer kolon boş geçilirse tırnak içerisindeki değerin yazılacağını ifade eder.
);


/*Bu örnekte AUTO_INCREMENT ile tanımlandıktan sonra INSERT ederken student_id keyinin eklenmesine gerek kalmadığını açıklar. */

CREATE TABLE student (
	student_id INT AUTO_INCREMENT, -- AUTO_INCREMENT bu değerin otomatik olarak arttırılarak kaydedileceği anlamına gelir.
	name VARCHAR(20), 
	major VARCHAR(20),
	PRIMARY KEY(student_id)
);

INSERT INTO student(name, major) VALUES('Claire', 'Biology')



/* UPDATE ve DELETE işlemleri. */

/*Buradaki kod student tablosunda major değeri Biology olanları Bio olarak değiştirmek için yazılmıştır. */

UPDATE student 
SET major 'Bio'
WHERE major = 'Biology'


/*Bu kod student_id= 4 olan satırın major değerini Comp Sci olarak değiştirmiştir. */

UPDATE student 
SET major 'Comp Sci'
WHERE student_id = 4;


/*Bu kod major = Bio veya major = Chemistry olan kısmı Biochemistry olarak değiştirmiştir. */

UPDATE student 
SET major 'Biochemistry'
WHERE major = 'Bio' OR major = "Chemistry";


/* Bu kod student_id = 1 olan değerin name ve major keylerini değiştirir. */

UPDATE student 
SET name = 'Tom', major = 'undecided'
WHERE student_id = 1;



/* WHERE kullanılmadan tablo update edilirse geçerli değer tüm verilere uygulanır */

UPDATE student 
SET major = 'undecided';


DELETE FROM student; -- student tablosundaki tüm verileri siler.


/*student_id keyi 1 olan veriyi siler */

DELETE FROM student
WHERE student_id = 1;


/* name = TOM major = undecided olan tüm verileri siler. */

DELETE FROM student
WHERE name = 'Tom' AND major = 'undecided';


/*student tablosundaki name ve major kolonlarını getirir*/

SELECT name, major
FROM student;


/*student tablosundaki name ve major kolonlarını name değerini kontrol ederek alfabatik sırayla getirir. A > Z */

SELECT student.name, student.major
FROM student
ORDER BY name;

/*student tablosundaki name ve major kolonlarını name değerini kontrol ederek alfabatik sırayla getirir. Z > A */

SELECT student.name, student.major
FROM student
ORDER BY name DESC;


/*Bu kod major değerlerini kontrol ederek sırayla getirir eğer major değerleri aynıysa student_id değerlerini kontrol ederek sıralar*/

SELECT *
FROM student
ORDER BY major, student_id;


/*Burada LIMIT ile student id büyükten küçüğer 2 tane veriyi getirmek için kullanılır. */

SELECT *
FROM student
ORDER BY student_id DESC
LIMIT 2;


/*Burada student tablosunda name ve major kolonları major = Chemistry veya name = Kate olanları getirmek için yazılmıştır. */

SELECT name, major
FROM student
WHERE major = 'Chemistry' OR name = 'Kate'


/*Bu kod name değeri 'Claire', 'Kate', 'Mike' olan verileri getirmek için yazılır. */

SELECT *
FROM student
WHERE name IN ('Claire', 'Kate', 'Mike')



/*Bu kod major değeri 'Biology', 'Chemistry' ve student_id si 2 den büyük olan verileri getirmek için yazılır. */

SELECT *
FROM student
WHERE major IN ('Biology', 'Chemistry') AND student_id > 2;
WHERE major IN ('Biology', 'Chemistry') AND student_id > 2;




/* ÖRNEK Şirket database oluşturma. */


CREATE TABLE employee (
	emp_id INT PRIMARY KEY,      --employee_id
	first_name VARCHAR(40),
	last_name VARCHAR(40),
	birth_day DATE,
	sex VARCHAR,
	salary INT,
	super_id INT,                --supervisor_id
	branch_id INT
);


CREATE TABLE branch (
	branch_id INT PRIMARY KEY,
	branch_name VARCHAR(40),
	mgr_id INT,    				-- manager_id
	mgr_start_date DATE,        -- manager_start_date
	FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);


/* employee ve branch tablosu fk ile bağlama */

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)


CREATE TABLE client(
	client_id INT PRIMARY KEY,
	client_name VARCHAR(40),
	branch_id INT,
	FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL -- ON DELETE SET NULL mevcut veri silinirse bağlı olduğu tablodaki değeri NULL yapması için kullanılır.
);


CREATE TABLE work_with(
	emp_id INT,
	client_id INT,
	total_sales INT,
	PRIMARY KEY(emp_id, client_id),
	FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
	FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE	-- ON DELETE CASCADE mevcut veri silinirse bağlı olduğu tablodaki değerin de silinmesi için kullanılır.
);


CREATE TABLE branch_supplier(
	branch_id INT,
	supplier_name VARCHAR(40),
	supply_type VARCHAR(40),
	PRIMARY KEY(branch_id, supplier_name),
	FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


/* 

	!!!!! NOT: 

	Bu tablolara veri insert edilirken FK ile bağlanacak değerler diğer tablolarda henüz oluşturulmamış olabilir. 
	Bu durumda da hata alma ihtimalleri olabilir. Bu tarz hataların önüne geçebilmek için FK değerleri ilk etapta NULL olarak girilmelidir.
	Tablolara veriler girildikten sonra bağlanacak olan FK değerleri içeren veriler UPDATE edilerek bu tarz hataların önüne geçilir.

*/


/*

	Find the forename and surnames names of all employees.
	Tabloda first_name ve last_name olarak tanımlanmış kolonların isimlerini forename ve surname olarak çağırmak için kullanılan bir query.

*/


SELECT first_name AS forename, last_name AS surname
FROM employee;

/*

	Yukarıda yazılmış queryde kolon isimleri kullanıcıya forename ve surname ile dönmektedir. Arka planda keyler hala firs_name ve last_name olarak saklanmaktadır.
	Eğer bu keyleri forename, surname olarak değiştirmek istersek aşağıdaki komutları yazmamız gerekir.

*/


ALTER TABLE employee RENAME COLUMN first_name TO forename
ALTER TABLE employee RENAME COLUMN last_name TO surname


/*
	Geçerli kolonda kaç farklı veri olduğunu görmek için aşağıdaki method kullanılır.
	employee tablosunda kaç farklı cinsiyet olduğu bu sayede görüntülenir.
*/

SELECT DISTINCT sex
FROM employee



/* SQL Fonksiyon */

/* Geçerli tabloda kaç bulunduğunu görmek için aşağıdaki method kullanılır. */

SELECT COUNT(emp_id)
FROM employee


/* 1970 den sonra doğan kadın çalışanların sayısını getiren query */

SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND  birth_day > '1970-01-01';


/* Erkek çalışanların maaş ortalamasını getiren fonksiyon */

SELECT AVG(salary)
FROM employee
WHERE sex = 'M';


/* Tüm çalışanların maaş toplamlarını getiren fonksiyon. */

SELECT SUM(salary)
FROM employee;


/* Kaç erkek kaç kadın çalışanın olduğunu getiren fonksiyon. */

SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;


/* Satış elemanlarının yaptığı toplam satışı getiren fonksiyon. */

SELECT SUM(total_sales), emp_id
FROM work_with
GROUP BY emp_id;


/*
	WILDCARDS (LIKE METHOD)
	1. örnekte string veri içerisinde son karakterleri LLC olan değerleri bize döndürür.
	2. örnekte date veri içerisinde (yyyy-mm-dd) yıl değeri 4 tane _ girilerek boş geçilir ay 10 olanları getirir.
	3. örnekte string veri içerisinde herhangi bir noktaca LLC içeren değerleri bize döndürür.

*/


SELECT *
FROM client
WHERE client_name LIKE '%LLC';

SELECT * 
FROM employee
WHERE birth_day LIKE '____-10%'

SELECT *
FROM client
WHERE client_name LIKE '%LLC%';


/*

	UNIONS
	Aynı anda birden fazla tablodaki verileri tek seferde çekmek için kullanılır.
	Bu işlemde temel olarak 2 kural vardır:
	Kural 1: birleştirdiğin verilerin tipleri aynı olmak zorundadır.
	Kural 2: tüm tablolardan çektiğin kolon sayıları eşit olmalıdır.

*/

/*

	employee_name branch_name ve client_name aynı anda getiren sorgu
	bu sorgu bize bu 3 kolonu içeren verileri tek bir kolonda döner.
	ilk yazılan SELECT içerisinde kolon ismi AS kullanılarak değiştirilmezse o kolonun ismiyle döner.
*/


SELECT first_name AS ALL_NAMES
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;


/*

	çalışanların total maaşı ve müşterilerden gelen ödemelerin toplamlarını getiren query.

*/


SELECT SUM(salary)
FROM employee
UNION
SELECT SUM(total_sales)
FROM work_with;



/*

	JOINS
	Birden fazla tabloyu birleştirerek tek bir istekte ihtiyaç duyulan spesifik veriyi çekmemizi sağlar


*/

/*

 	Tüm branchleri ve bu branchlerin managerlarını getiren query.
	(Branch tablosunda yalnızca branch_name ve mgr_id bulunmakta.)
	4 tip join vardır
	(INNER) JOIN iki tablodaki kesşim kümesini bize döndürür.
	LEFT (OUTER) JOIN ilk FROM da yazılan tablodaki verilerin tamamını döner ikinci tabloda karşılık veri yoksa NULL döner.
	RIGHT (OUTER) JOIN ikinci FROM da yazılan tablodaki verilerin tamamını döner ilk tabloda karşılık veri yoksa NULL döner.
	FULL (OUTER) JOIN iki tablonun da birleşim kümesini bize döner.
*/

SELECT employee.emp_id, employee.first_name, branch.mgr_id
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;


SELECT employee.emp_id, employee.first_name, branch.mgr_id
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;


SELECT employee.emp_id, employee.first_name, branch.mgr_id
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;



/*

	Nested Queries
	Tek bir müşteriye 30000$ üzeri satış yapan çalışanların listesi için iç içe iki sorgu atılarak istenen değere ulaşılır.

*/


SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
	SELECT work_with.emp_id
	FROM work_with
	WHERE work_with.total_sales > 30000
);


/*

	Micheal Scott yönetiminde olan branche ait tüm müşterileri getiren query
	Micheal ID'si biliniyor olsun

*/


SELECT client.client_name
FROM client
WHERE client.branch_id = (
	SELECT branch.branch_id
	FROM branch
	WHERE branch.mgr_id = 102
);



/*

	On Delete

	İki tip ON DELETE işlemi vardır:
	1. ON DELETE SET NULL - bu komutla FK ile bağlı olduğu diğer tablolardaki değerleri NULL yapar
	2. ON DELETE CASCADE  - bu komutla FK ile bağlı olduğu diğer tablolardaki değerleri siler.

	Bu iki işlem tablolar yaratılırken tanımlanmalıdır!!!!!!
	
*/


/* employee tablosunde emp_id = 102 olan veriyi siler diğer tablolarda emp_id=102 olan verileri de NULL değeri atar (ON DELETE SET NULL) */

DELETE FROM employee
WHERE emp_id = 102;



/*

	Triggers
	
	DELIMITER komutu, MySQL'de kullanılan ve çok satırlı SQL ifadelerini veya prosedürleri belirli bir karakter dizisiyle bitirmek için kullanılır. 
	Normalde, SQL ifadeleri noktalı virgülle (;) biter. 
	Ancak, birden fazla SQL ifadesini içeren bir blok (örneğin, bir trigger veya stored procedure) tanımlarken, MySQL bu ifadeleri bir bütün olarak algılamalıdır.
	Bu nedenle DELIMITER komutu kullanılarak standart sonlandırıcı (;) yerine başka bir sonlandırıcı (bu örnekte $$) belirlenir.

	
	Bu kod parçacığı, employee tablosuna veri eklenmeden önce (BEFORE INSERT) çalışan bir trigger (my_trigger) oluşturur. 
	Trigger'lar, belirli bir tabloya veri ekleme, güncelleme veya silme işlemi gerçekleştiğinde otomatik olarak çalışan SQL kod bloklarıdır.

	Açıklama:
	CREATE TRIGGER: Yeni bir trigger oluşturur.
	my_trigger: Trigger'ın adıdır. Bu ad, veritabanında benzersiz olmalıdır.
	BEFORE INSERT: Bu, trigger'ın INSERT işlemi gerçekleşmeden önce çalışacağını belirtir.
	ON employee: Trigger'ın hangi tablo üzerinde çalışacağını belirtir. Bu durumda employee tablosu.
	FOR EACH ROW: Bu ifade, INSERT işlemi sırasında her bir satır için trigger'ın çalışacağını belirtir.
	BEGIN ... END: Bu blok, trigger'ın çalıştıracağı SQL ifadelerini içerir.
	INSERT INTO trigger_test VALUES('add new employee'): Bu ifade, trigger_test tablosuna bir satır ekler ve message sütununa 'add new employee' değerini yazar.


*/


CREATE TABLE trigger_test(
	message VARCHAR(40)
);

DELIMITTER $$
CREATE
	TRIGGER my_trigger BEFORE INSERT
	ON employee
	FOR EACH ROW BEGIN
		INSERT INTO trigger_test VALUES('add new employee');
	END $$
DELIMITTER;


DELIMITTER $$
CREATE
	TRIGGER my_trigger BEFORE INSERT
	ON employee
	FOR EACH ROW BEGIN
		INSERT INTO trigger_test VALUES(NEW.first_name); -- bu noktada prop geçilerek employee tablosuna yazılacak olan first_name verisine erişilerek trigger_test tablosuna yazılır.
	END $$
DELIMITTER;


/*

	Bu noktada durumu kontrol eden bir trigger yazılmıştır.
	Cinsiyete göre erkek kadın diğer çalışan olarak trigger_test tablosuna yazılır

*/


DELIMITTER $$
CREATE
	TRIGGER my_trigger BEFORE INSERT -- BEFORE yerine AFTER yazılabilir böylece önce employee tablosuna veriyi girer sonra trigger_test tablosuna geçerli veriyi yazar.
	ON employee						 -- INSERT yerine UPDATE veya DELETE yazılarak farklı durumlarda trigger_test tablosuna veri yazdırmak mümkündür.
	FOR EACH ROW BEGIN
		IF NEW.sex = 'M' THEN
			INSERT INTO trigger_test VALUES('added male employee');
		ELSEIF NEW.sex = 'F' THEN
			INSERT INTO trigger_test VALUES('added female employee');
		ELSE 
			INSERT INTO trigger_test VALUES('added other employee');
		END IF;
	END $$
DELIMITTER;

DROP TRIGGER my_trigger -- Komutuyla mevcut triggerı silmek mümkündür.