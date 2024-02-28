-- FIRST WEEK

TRUNCATE TABLE TEST1;
GRANT SELECT ON student_list TO SYS;

SELECT HC,ROUND(AVG(SCORE),1) FROM STUDENT_LIST
GROUP BY HC
ORDER BY HC;

INSERT INTO STUDENT_LIST values(9,'Roundle',4,31);
INSERT INTO STUDENT_LIST values(10,'Aron',1,89,null);
INSERT INTO STUDENT_LIST values(11,'Abramara',3,89,2);
INSERT INTO STUDENT_LIST values(14,'Toreyzi',1,(SELECT ROUND(DBMS_RANDOM.VALUE(1,100)) FROM DUAL),2);

SELECT * FROM STUDENT_LIST
ORDER BY SCORE desc;

SELECT COUNT(*) FROM STUDENT_LIST
GROUP BY HC;

UPDATE STUDENT_LIST  
	SET SCORE = SCORE - 5;
	
CREATE VIEW tmp_score AS 
	SELECT STUDENT_ID,SCORE FROM STUDENT_LIST;
DROP VIEW tmp_score;
	
SELECT * FROM tmp_score;

SELECT SCORE, DECODE(SCORE,100,'True','False') 
FROM STUDENT_LIST;

-- 점수 범위에 따라 분류
-- CASE WHEN THEN 사용 
SELECT b.name,b.score,a.Grading
FROM 
(SELECT STUDENT_ID,SCORE,CASE 
WHEN SCORE >= 90 THEN 'A'
WHEN SCORE >= 70 THEN 'B'
WHEN SCORE >= 50 THEN 'C'
ELSE 'D' END AS Grading
FROM STUDENT_LIST) a,
(SELECT * FROM STUDENT_LIST) b
WHERE a.STUDENT_ID = b.student_id
ORDER BY a.Grading;

SELECT 
STUDENT_ID,
SCORE, 
DECODE(hc, 1, '병아리반',2, '호랑이반',3,'기린반','임시반') AS 반이름
FROM STUDENT_LIST sl 


SELECT * FROM STUDENT_LIST
	WHERE ROWNUM <=2;

SELECT * 
FROM (SELECT rownum arr,name,score FROM STUDENT_LIST)
WHERE arr BETWEEN 2 AND 5;

SELECT rowid,Name
FROM STUDENT_LIST;

WITH tmp_view AS 
(
SELECT * FROM HOME_CLASS
UNION ALL
SELECT * FROM HOME_CLASS
)
SELECT * FROM tmp_view;

SELECT Name FROM STUDENT_LIST
WHERE STUDENT_ID = 1;

UPDATE STUDENT_LIST SET NAME ='마일' WHERE STUDENT_ID = 1;
ROLLBACK;
COMMIT;

SELECT MAX(A), MAX(B) FROM 
(SELECT 'Na' A,'' B FROM DUAL
UNION ALL
SELECT '' A,'NU' B FROM DUAL
);

SELECT STUDENT_ID,NAME,SCORE,CLASS_NUMBER,teacher FROM STUDENT_LIST sl, HOME_CLASS hc
WHERE sl.HC = hc.CLASS_NUMBER;

SELECT HC  FROM STUDENT_LIST
INTERSECT 
SELECT Class_number FROM HOME_CLASS;

SELECT * FROM HOME_CLASS hc LEFT OUTER JOIN STUDENT_LIST sl
ON hc.CLASS_NUMBER = sl.HC;

SELECT * FROM STUDENT_LIST sl CROSS JOIN HOME_CLASS hc;
SELECT HC FROM STUDENT_LIST sl UNION all SELECT class_number FROM HOME_CLASS hc;
SELECT HC FROM STUDENT_LIST sl UNION SELECT class_number FROM HOME_CLASS hc;



SELECT class_number FROM HOME_CLASS hc MINUS SELECT HC FROM STUDENT_LIST sl; 

CREATE TABLE EMP(
	EMPNO number(10) PRIMARY KEY,
	ENAME VARCHAR2(20),
	DEPTNO number(10),
	MGR number(10),
	JOB VARCHAR2(20),
	SAL NUMBER(10)
);

INSERT INTO EMP VALUES(100,'Test1',2,NULL,'CLERK',800);
INSERT INTO EMP VALUES(110,'Test11',2,102,'CLERK',1100);
INSERT INTO EMP VALUES(111,'Test12',3,101,'CLERK',950);
INSERT INTO EMP VALUES(113,'Test14',1,100,'CLERK',1300);

INSERT INTO EMP VALUES(101,'Test2',3,100,'SALESMAN',1600);
INSERT INTO EMP VALUES(102,'Test3',3,100,'SALESMAN',1600);
INSERT INTO EMP VALUES(104,'Test5',3,100,'SALESMAN',1600);
INSERT INTO EMP VALUES(109,'Test10',3,102,'SALESMAN',1600);

INSERT INTO EMP VALUES(103,'Test4',2,100,'MANAGER',2400);
INSERT INTO EMP VALUES(105,'Test6',3,101,'MANAGER',2400);
INSERT INTO EMP VALUES(106,'Test7',1,101,'MANAGER',2400);

INSERT INTO EMP VALUES(107,'Test8',2,106,'ANALYST',3000);
INSERT INTO EMP VALUES(112,'Test13',2,100,'ANALYST',3000);

INSERT INTO EMP VALUES(108,'Test9',3,106,'PRESIDENT',5000);
SELECT * FROM EMP;

SELECT MAX(LEVEL) FROM EMP e
START WITH e.MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;


--DAY JAN 15

ALTER TABLE STUDENT_LIST ADD CONSTRAINT score_field CHECK(score >= 0 AND score <= 100);
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'STUDENT_LIST'

BEGIN 
	DBMS_OUTPUT.ENABLE;
	SAVEPOINT a;
	INSERT INTO HOME_CLASS VALUES(9,'KaTea');
	SAVEPOINT b;
	UPDATE HOME_CLASS SET TEACHER = 'MOUIT' WHERE CLASS_NUMBER = 6;
	ROLLBACK TO SAVEPOINT b;
	COMMIT;
	DBMS_OUTPUT.put_line('RollBack to Savepoint ?');
END;

SELECT LEVEL,SYS_CONNECT_BY_PATH(e.EMPNO,'->')  FROM EMP e
WHERE CONNECT_BY_ISLEAF = 1
START WITH e.MGR = 106
CONNECT BY PRIOR MGR = EMPNO 
ORDER BY LENGTH(ENAME), ENAME


-- leaf 찾기 leaf일 경우 ISLEAF = 1
SELECT LEVEL,EMPNO,ENAME,CONNECT_BY_ISLEAF AS isleaf FROM EMP e
-- WHERE CONNECT_BY_ISLEAF = 1 leaf인 것만 출력
START WITH e.MGR IS NULL 
CONNECT BY PRIOR EMPNO = MGR 
-- ORDER BY LEVEL DESC; 고레벨부터 출력

-- 알아낸 leaf 노드 중 가장 낮은 레벨인 4를 가진 노드는 Test8(EMPNO는 107)

-- Test8부터 상위 경로를 탐색
SELECT LEVEL,ENAME,EMPNO,MGR FROM EMP e
START WITH empno = 107
CONNECT BY PRIOR MGR = EMPNO
-- CONNECT BY를 자식 = 부모로 하여 역방향 전개

/*
CREATE TABLE Student_role
(
	Role_number number(2) PRIMARY KEY,
	Role_name varchar2(20)
);

INSERT INTO student_role values(1,'학생회장');
INSERT INTO STUDENT_ROLE values(2,'미정');

SELECT * FROM student_role;
ALTER TABLE STUDENT_LIST ADD CONSTRAINTS ROLE_fk FOREIGN KEY(STUDENT_LIST."Role") REFERENCES student_role(STUDENT_ROLE.ROLE_NUMBER); 
*/

SELECT *
FROM STUDENT_LIST sl, HOME_CLASS hc  
WHERE sl.HC = hc.CLASS_NUMBER 
AND STUDENT_ID IN (SELECT STUDENT_ID FROM STUDENT_LIST
		  WHERE SCORE > 50);
		 
-- IN 연산자 이해
SELECT * FROM HOME_CLASS hc 
WHERE CLASS_NUMBER IN (1,2,3),


-- ANY 연산자 : ()안 조건 중 하나라도
SELECT * FROM HOME_CLASS hc 
WHERE CLASS_NUMBER = ANY(4,5)

-- ANY 연산자 이해 , 1을 뺀 나머지,any()안에 여러 값이 있을 경우 무의미
SELECT * FROM HOME_CLASS hc 
WHERE CLASS_NUMBER <> ANY(3) -- <> 연산자 : !=(다르다) 연산자와 동일

-- ALL 연산자 =  IN 연산자와 대동소이
SELECT * FROM STUDENT_LIST
WHERE HC != ALL(1,2,3) --1,2,3 반이 아닐 경우

-- EXISTS 연산자 , 조건만족이 하나라도 있다면 전체가 참, 테이블에 존재하는가? 확인
SELECT * FROM STUDENT_LIST sl 
WHERE EXISTS (SELECT 1 FROM STUDENT_LIST WHERE SCORE > 97)

SELECT * FROM STUDENT_LIST sl
WHERE lower(name) LIKE 'v%' OR lower(name) LIKE 'l%';

SELECT * FROM STUDENT_LIST sl
WHERE lower(name) like ('a%','e%','i%','o%','u%');





-- DAY JAN 16





-- where이 order by 보다 먼저 실행되므로 where 실행문의 from 부분에서 먼저 정렬한다
SELECT * 
FROM 
(
	SELECT * FROM STUDENT_LIST sl 
	ORDER BY score desc
)
WHERE rownum <= 5

CALL Top3('the first');
SELECT * FROM USER_SOURCE WHERE name = 'TOP3';

CALL PrintSentence();

-- 평균 점수와 해당 번호의 점수를 동시에 출력
SELECT
    STUDENT_ID,
    score,
    (SELECT AVG(score) FROM STUDENT_LIST) AS average
FROM
    STUDENT_LIST 
WHERE
    student_id = 2;
   
   
SELECT decode(hc,NULL,'Total',hc) AS CLASS,"Role", ROUND(AVG(SCORE),1) AS total
FROM STUDENT_LIST
GROUP BY ROLLUP(hc,"Role");

-- bool값 Grouping을 사용해 여부 구분
SELECT hc,
decode(GROUPING(hc),1,'Total') Total,
"Role",
DECODE(GROUPING("Role"),1,'Sub') Sub,
AVG(SCORE)
FROM STUDENT_LIST sl 
GROUP BY ROLLUP(hc,"Role");

SELECT 
decode(hc,NULL,'NA',hc) AS Class,
decode("Role",NULL,'NA',"Role") AS Role,
round(AVG(score),1) AS Average
FROM STUDENT_LIST sl 
GROUP BY GROUPING SETS(hc,"Role")
ORDER BY hc;

SELECT STUDENT_ID,score,	
RANK() OVER (ORDER BY score DESC) AS Ranking
FROM STUDENT_LIST;

-- 처음부터(unbounded preceding) 끝까지의(unbounded following) 총합
SELECT STUDENT_ID,SCORE, 
sum(score) OVER(ORDER BY SCORE
				ROWS BETWEEN UNBOUNDED PRECEDING
				AND UNBOUNDED FOLLOWING) ToT
FROM STUDENT_LIST sl 

-- 처음부터 현재까지(current row)의 총합
SELECT STUDENT_ID,SCORE, 
sum(score) OVER(ORDER BY SCORE
				ROWS BETWEEN UNBOUNDED PRECEDING
				AND CURRENT ROW) ToT
FROM STUDENT_LIST sl;

SELECT STUDENT_ID,SCORE, 
sum(score) OVER(ORDER BY SCORE
				ROWS BETWEEN CURRENT ROW 
				AND UNBOUNDED FOLLOWING) ToT
FROM STUDENT_LIST sl;

-- 하나 이전(1 preceding)과 현재와 하나 이후(1 following)의 총합
SELECT STUDENT_ID,SCORE, 
sum(score) OVER(ORDER BY SCORE
				ROWS BETWEEN 1 PRECEDING
				AND 1 FOLLOWING) ToT
FROM STUDENT_LIST sl;

-- 수 계산 : 50점 이상 학생이 5명 더 많다
SELECT a - b 
FROM 
(SELECT count(*) AS a FROM STUDENT_LIST WHERE score > 50) ,
(SELECT count(*) AS b FROM STUDENT_LIST WHERE score < 50) ;


-- 각 반의 1등을 뺸 나머지 학생을 조회
SELECT *
FROM 
(SELECT NAME, hc,
DENSE_RANK() OVER (PARTITION BY hc ORDER BY score desc) ALL_BANK
FROM STUDENT_LIST)
WHERE ALL_BANK >= 2; 


-- 각 반의 가장 낮은 점수를 조회
SELECT hc, MIN(score) AS lowest_score
FROM STUDENT_LIST
GROUP BY hc;

-- 각 반의 꼴등의 점수와 이름을 조회
WITH RankedScores AS (
  SELECT
    name,
    hc,
    score,
    RANK() OVER (PARTITION BY hc ORDER BY score desc) AS score_rank
  FROM
    SCOTT.STUDENT_LIST sl 
)
SELECT *
FROM 
(
	SELECT
	  name,
	  hc,
	  score,
	  score_rank,
	  CASE 
	  	WHEN score >= (SELECT avg(SCORE) FROM STUDENT_LIST)
	  		THEN 'Over AVG'
	  	ELSE 'Under AVG'
	  END AS IsOverAVG
	FROM
	  RankedScores
	ORDER BY hc, score desc
)
WHERE isoveravg = 'Under AVG'

-- ALTER TABLE SCORE_RECORD ADD CONSTRAINTS id_fk FOREIGN key(ID) REFERENCES student_list(STUDENT_ID);

-- LAG():이전 값 불러옴 사용
SELECT "Time",SCORE,
score - LAG(score) OVER(ORDER BY "Time")
FROM SCORE_RECORD






-- DAY JAN 17






-- lead(,args) : 정해진 위치의 값 데려옴
SELECT "Time",score,
LEAD(score,2) OVER (ORDER BY "Time")
FROM SCORE_RECORD;

SELECT name, score,
LEAD(score,1) OVER (ORDER BY score desc)  AS "one after"
FROM STUDENT_LIST 

-- Percent Rank : 등수를 백분율로 나타냄
SELECT NAME,SCORE,
round(PERCENT_RANK() OVER (ORDER BY score desc),2) * 100 || '%' AS percent
FROM STUDENT_LIST;

-- NTile(args) : 전체 테이블을 args 등분해 몇번째 조각인지 표현 
SELECT name, score, 
NTILE(4) OVER (ORDER BY SCORE DESC) AS tile,
round(PERCENT_RANK() OVER (ORDER BY score desc),2) * 100 || '%' AS percent
FROM STUDENT_LIST;

SELECT DISTINCT LEVEL, ENAME,EMPNO,MGR FROM EMP e
START WITH job = 'SALESMAN'
CONNECT BY PRIOR EMPNO = MGR;

SELECT hc.TEACHER, decode(sl."Role",NULL,'NA',"Role") AS Role,
sum(score)
FROM SCOTT.STUDENT_LIST sl , SCOTT.HOME_CLASS Hc  
WHERE sl.HC = hc.CLASS_NUMBER 
GROUP BY ROLLUP(Hc.TEACHER,sl."Role");

SELECT name,score,
(SELECT min(score) FROM STUDENT_LIST WHERE HC = 4) AS standard
FROM STUDENT_LIST
WHERE score > all(SELECT score FROM STUDENT_LIST sl WHERE HC = 4);

-- 반복문처럼 날짜 벡터 만들기
SELECT TO_DATE('20181201','YYYYMMDD') + (ROWNUM -1) AS TEMP_CAL
FROM DUAL
CONNECT BY LEVEL <= (TO_DATE('20181231','YYYYMMDD') - TO_DATE('20181201','YYYYMMDD') + 1);
-- 시간 벡터
SELECT rownum,TO_TIMESTAMP('01' + (ROWNUM -1) || ':00','HH24:MI') AS TEMP_TIME
FROM DUAL
CONNECT BY LEVEL <= 23;

/*
SELECT 
  TO_TIMESTAMP(TO_CHAR(TO_DATE('20181201','YYYYMMDD') + (LEVEL - 1), 'YYYYMMDD') || ' ' || MOD(LEVEL - 1, 24) || ':00:00', 'YYYYMMDD HH24:MI:SS') AS TEMP_TIME
FROM 
  DUAL
CONNECT BY 
  LEVEL <= (TO_DATE('20181231','YYYYMMDD') - TO_DATE('20181201','YYYYMMDD') + 1) * 24
 ORDER BY temp_time;
*/

-- 각 날짜에 24시간을 배정해 생성
INSERT INTO SCORE_RECORD("Time")
SELECT 
  TO_TIMESTAMP(TO_CHAR(TO_DATE('19800101','YYYYMMDD') + TRUNC((LEVEL - 1) / 24), 'YYYYMMDD') || ' ' || MOD(LEVEL - 1, 24) || ':00:00', 'YYYYMMDD HH24:MI:SS') AS TEMP_TIME
FROM 
  DUAL
CONNECT BY 
	LEVEL <= (TO_DATE('20201231','YYYYMMDD') - TO_DATE('19800101','YYYYMMDD') + 1) * 24;

-- 점수 부여 반복
DECLARE
  v_min_score NUMBER := 1; -- Minimum random score
  v_max_score NUMBER := 100; -- Maximum random score
  v_min_id NUMBER := 1; -- Minimum random score
  v_max_id NUMBER := 10; -- Maximum random score
BEGIN
  FOR r IN (SELECT "Time", SCORE,ID 
              FROM SCORE_RECORD 
             WHERE (SCORE IS NULL) OR (ID IS NULL)) 
  LOOP
	r.ID := ROUND(DBMS_RANDOM.VALUE(v_min_id, v_max_id));
    r.score := ROUND(DBMS_RANDOM.VALUE(v_min_score, v_max_score));
    r.score := CASE WHEN r.ID < 6 THEN r.score + (60 - r.ID * 10) ELSE r.score - (r.ID * 10 - 50) END;
    r.score := CLAMP_NUMBER(r.score);
    UPDATE SCORE_RECORD 
       SET SCORE = r.score,
       	   ID = r.ID
     WHERE "Time" = r."Time";
  END LOOP;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Random scores updated successfully.');
END;

DELETE FROM SCORE_RECORD;



-- ID 부여
DECLARE

BEGIN
  FOR r IN (SELECT "Time",ID  
              FROM SCORE_RECORD 
             WHERE ID IS NULL) 
  LOOP

    r.ID := ROUND(DBMS_RANDOM.VALUE(v_min_id, v_max_id));

    UPDATE SCORE_RECORD 
       SET ID = r.ID
     WHERE "Time" = r."Time";
  END LOOP;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Random scores updated successfully.');
END;

-- 루프 연습
DECLARE 
	V_STRING VARCHAR2(100) := NULL;
	V_DAN NUMBER(2) := 1;
	V_CNT NUMBER(2) := 0;
BEGIN 
	LOOP
	  EXIT WHEN V_CNT = 9;
	      V_CNT := V_CNT +1;
	-------------------------------첫단부터 끝단 1줄--------------------------------     
	      LOOP
	       EXIT WHEN V_DAN > 9;
	          V_STRING := V_STRING || V_CNT || '*' || V_DAN || '=' || V_CNT * V_DAN || ' ' ;
	          V_DAN := V_DAN + 1;
	      END LOOP;
	      
	      DBMS_OUTPUT.PUT_LINE(V_STRING);
	-------------------------------첫단부터 끝단 1줄--------------------------------     
	      V_STRING := NULL;  -- 다시초기화
	      V_DAN := 1;   --다시초기화
      
	END LOOP;
END;

-- 인덱스 생성
CREATE INDEX record_idx ON 
	score_record("Time",ID);

DROP INDEX record_idx;
	
SELECT * FROM SCORE_RECORD sr WHERE "Time" = TO_DATE('20120103','YYYYMMDD');
SELECT /*+ INDEX(SCORE_RECORD SCORE_IDX) */
* FROM SCORE_RECORD sr WHERE "Time" = TO_DATE('20120103','YYYYMMDD');

SELECT /* INDEX(SCORE_RECORD SCORE_IDX) */
* FROM SCORE_RECORD sr WHERE ID < 4 AND SCORE < 23 AND "Time" > TO_DATE('20200103','YYYYMMDD');

SELECT * FROM SCORE_RECORD WHERE TO_CHAR(TO_DATE("Time", 'YYYYMMDD'), 'YYYY') = '2020';

SELECT * FROM SCORE_RECORD sr WHERE ID = 1 AND "Time" BETWEEN '20080101' AND '20080113';
SELECT /*+ INDEX(SCORE_RECORD SCORE_IDX) */
* FROM SCORE_RECORD sr WHERE ID IN(1,2,3) ORDER BY "Time";

SELECT avg(score) FROM SCORE_RECORD sr2;

SELECT /*+ INDEX(SCORE_RECORD SCORE_IDX) */
count(*) FROM SCORE_RECORD
WHERE "Time" IS NULL OR ID IS NULL OR SCORE IS NULL;




-- DAY JAN 18



SELECT * FROM SCORE_RECORD
WHERE "Time" = TO_DATE('20081201','yyyymmdd')

SELECT min(score) FROM SCORE_RECORD sr 

UPDATE SCORE_RECORD 
SET SCORE = 20
WHERE SCORE = 30 AND "Time" = TO_DATE('20081201','yyyymmdd') 

SELECT EXTRACT(YEAR FROM "Time") AS year,SUBSTR(EXTRACT(YEAR FROM "Time"),3) AS sub ,count("Time")
FROM 
(
	SELECT *
	FROM SCORE_RECORD
	WHERE score > 90 AND ID = 3
)
GROUP BY EXTRACT(YEAR FROM "Time")
ORDER BY YEAR;


DECLARE 
	CURRENT_NUM NUMBER;
BEGIN 
	FOR i IN (SELECT * FROM SCORE_RECORD)
	LOOP
		CURRENT_num := DBMS_RANDOM.value(1,100);
		IF CURRENT_num = i.score
			THEN DBMS_OUTPUT.PUT_LINE('CURRENT NUMBER : ' || CURRENT_num || ' and Listed Score : ' || i.score || 'Are the same');
		END IF; 
	END LOOP;
END;


SELECT
	NAME, 
	SCORE,
	"Time", 
	CASE 
		WHEN score - lag(SCORE) OVER (ORDER BY "Time") > 0
		THEN '+'
		WHEN score - lag(SCORE) OVER (ORDER BY "Time") < 0
		THEN '-'
		ELSE '='
	END AS Change
FROM 
(
SELECT sl.NAME, sr.SCORE,sr."Time"  
FROM SCORE_RECORD sr, STUDENT_LIST sl
WHERE sl.STUDENT_ID  = 1 AND sl.STUDENT_ID = sr.ID AND rownum <= 100
ORDER BY "Time"
);



-- DAY JAN 19



SELECT hc2.TEACHER,hc2.CLASS_NAME, a.count
FROM HOME_CLASS hc2,
	(SELECT hc, COUNT(*) AS Count
	 FROM STUDENT_LIST
	 GROUP BY hc) a
WHERE hc2.CLASS_NUMBER = a.hc;

SELECT * 
FROM
(
	SELECT
		NAME, 
		SCORE,
		"Time", 
		CASE 
			WHEN score - lag(SCORE) OVER (ORDER BY "Time") > 0
			THEN '+'
			WHEN score - lag(SCORE) OVER (ORDER BY "Time") < 0
			THEN '-'
			ELSE '='
		END AS Change
	FROM 
	(
		SELECT sl.NAME, sr.SCORE,sr."Time"  
		FROM SCORE_RECORD sr, STUDENT_LIST sl
		WHERE sl.STUDENT_ID  = 1 AND sl.STUDENT_ID = sr.ID
		ORDER BY "Time"
	)
)
WHERE change = '+';

-- Oracle 정규식
SELECT *
FROM SCORE_RECORD
WHERE REGEXP_LIKE(score,'%0%');

SELECT "Time" ,ID ,SCORE , replace(SCORE,substr(score,1)) AS rel
FROM SCORE_RECORD
WHERE MOD(score,11) = 0;

SELECT "Time",REPLACE(TO_CHAR("Time",'yyyymmdd'),0)
FROM SCORE_RECORD
WHERE rownum < 10;

drop TABLE worker

CREATE TABLE worker
(
	id int PRIMARY KEY,
	Name varchar2(20),
	Salary int
);

INSERT INTO worker values(1,'Kristeen',1420)
INSERT INTO worker values(2,'Ashley',2006)
INSERT INTO worker values(3,'Julia',2210)
INSERT INTO worker values(4,'Maria',3000)

SELECT * FROM worker

select
  (AVG(salary)) - 
  (AVG(replace(salary, 0))) 
FROM WORKER w 
  
select
  round((AVG(salary)) - (AVG(replace(salary, 0))))
FROM WORKER;

SELECT score, count(score)
FROM SCORE_RECORD
WHERE score = (SELECT max(score) FROM SCORE_RECORD);




-- DAY 22 JAN




SELECT 
	max(score) Highest_score,
	COUNT(*) Total, 
	count(CASE WHEN score = 100 THEN 1 end) perfect, 
	'0' ||(round(count(CASE WHEN score = 100 THEN 1 end) / count(*) * 100,3) || '%') AS perfect_percent
FROM SCORE_RECORD
WHERE ID = 3;

SELECT NAME,sl.HC,hc.CLASS_NUMBER  , hc.TEACHER 
FROM STUDENT_LIST sl, HOME_CLASS hc 
WHERE sl.HC = hc.CLASS_NUMBER;

SELECT ID, avg(SCORE)
FROM SCORE_RECORD
GROUP BY ID
HAVING avg(SCORE) >= 50.5
ORDER BY ID; 

SELECT SUBSTR(name,1,1)
FROM STUDENT_LIST sl;

CREATE TABLE what 
(
	target number(10),
	stat enum('Y','N')
);

SELECT 
	id,
	round(avg(SCORE),2) Mean
FROM SCORE_RECORD
GROUP BY ID
ORDER BY ID;

-- Clamp 함수가 잘 작동되었는지 확인
SELECT score 
FROM SCORE_RECORD sr 
WHERE score < 0 OR score > 100;

-- Clamp 함수 사용 
SELECT CLAMP_NUMBER(120) FROM DUAL; 
-- Clamp 함수 내용
SELECT LEAST(GREATEST(120,0),100) FROM DUAL; 



-- DAY 24 JAN



SELECT 
	count(CASE WHEN score = 100 THEN 1 end) Hundred,
	round(count(CASE WHEN score = 100 THEN 1 end) / count(*),3) HunPercent,
	count(CASE WHEN score = 0 THEN 1 end) Zero,
	round(count(CASE WHEN score = 0 THEN 1 end) / count(*),3) ZeroPercent,
	count(CASE WHEN score != 100 AND score != 0 THEN 1 end) Other,
	round(count(CASE WHEN score != 100 AND score != 0 THEN 1 end) / count(*),3)OtherPercent,
	count(*) Total
FROM SCORE_RECORD sr;

SELECT nvl(mgr,0)
FROM EMP e;

SELECT nvl2(mgr,'Y','N') FROM emp;

SELECT ID ,SCORE ,sum(score) over(PARTITION BY ID ORDER BY SCORE)
FROM SCORE_RECORD sr
WHERE score = 51;

SELECT ID, "Time",sum(score)
FROM SCORE_RECORD sr 
WHERE TO_CHAR("Time",'yyyymmdd') < 19800110 AND id IN (2,3,4)
GROUP BY ROLLUP(ID, "Time");

SELECT * 
FROM STUDENT_LIST sl LEFT OUTER JOIN HOME_CLASS hc
ON sl.HC = hc.CLASS_NUMBER 
ORDER BY hc;

CREATE TABLE dummy AS 
SELECT LEVEL AS id,
	round(DBMS_RANDOM.VALUE(1,1000)) AS num
FROM dual
CONNECT BY LEVEL <= 300000

DROP TABLE DUMMY 

SELECT id,num 
FROM DUMMY d 
WHERE id <= 50000
UNION
SELECT id,NUM 
FROM DUMMY d3 
WHERE id > 50000;

SELECT id,num 
FROM DUMMY d 
WHERE id <= 50000
UNION all
SELECT id,NUM 
FROM DUMMY d3 
WHERE id > 50000;

SELECT score,count(*) OVER (ORDER BY score DESC RANGE BETWEEN 10 PRECEDING AND 0 FOLLOWING) AS what 
FROM STUDENT_LIST sl; 

SELECT * FROM STUDENT_LIST sl;

SELECT score
FROM SCORE_RECORD sr 
WHERE id = 1
UNION all
SELECT SCORE
FROM SCORE_RECORD sr2 
WHERE id = 1;




-- DAY 25 JAN




SELECT "Time", ID,score,count(SCORE) OVER (PARTITION BY SCORE)
FROM SCORE_RECORD sr 
WHERE score != 0;

SELECT score,count(*)
FROM SCORE_RECORD sr 
GROUP BY SCORE 
ORDER BY count(*) DESC;

SELECT 
	score,
	count(*) OVER (ORDER BY score DESC RANGE BETWEEN 1 PRECEDING AND 0 FOLLOWING) AS oneup
FROM SCORE_RECORD sr 

CREATE TABLE test1
(
	col1 number(10),
	col2 NUMBER(10) 
);

CREATE TABLE test2
(
	col1 number(10),
	col2 NUMBER(10) 
);

SELECT * FROM test1 a
WHERE (a.COL1, a.COL2)
IN (SELECT b.COL1,b.COL2  FROM TEST2 b);

SELECT * FROM test1 a 
WHERE EXISTS (SELECT '?' FROM test2 b
			  WHERE a.COL1 = b.COL1
			  AND a.col2 = b.col2);

SELECT *
FROM STUDENT_LIST sl 
WHERE EXISTS (SELECT 1 FROM HOME_CLASS hc WHERE sl.HC = hc.CLASS_NUMBER); 

SELECT *
FROM SCORE_RECORD sr 
WHERE EXISTS (SELECT 1 FROM STUDENT_LIST sl WHERE sr.id = sl.STUDENT_ID);

DROP TABLE test2;

SELECT 
	count(CASE WHEN ID = 1 THEN 1 end) ID_1,
	count(*) ID_All, 
	round((count(CASE WHEN ID = 1 THEN 1 end)/count(*))*100,2)||'%' Percent 
FROM SCORE_RECORD sr;

SELECT EXTRACT(YEAR FROM "Time") Year, ID, ceil(sum(score)/1000)*1000
FROM SCORE_RECORD sr 
WHERE "Time" < '19851230' AND id < 6
GROUP BY ROLLUP (EXTRACT(YEAR FROM "Time"),(ID))
ORDER BY EXTRACT(YEAR FROM "Time"),ID;  




-- DAY 26 JAN





SELECT 
	EXTRACT(MONTH FROM "Time"), 
	round(avg(score),2)
FROM SCORE_RECORD sr
GROUP BY EXTRACT(month FROM "Time")
ORDER BY EXTRACT(month FROM "Time");

DELETE FROM SCORE_RECORD;

SELECT TRUNC(SYSDATE) + 6/24
FROM dual;

SELECT TO_DATE('20230921') - SYSDATE  
FROM DUAL; 

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24')
FROM dual;

CREATE TABLE B
(
	id integer,
	name varchar(10)
);
CREATE TABLE B
(
	b integer PRIMARY KEY,
	c integer REFERENCES A(c) ON DELETE CASCADE 
);
CREATE TABLE C
(
	a integer PRIMARY KEY,
	b integer REFERENCES B(b) ON DELETE SET NULL  
);

DROP TABLE A;

SELECT * FROM A;

-- 아래 세 SQL은 모두 같은 결과

-- 1
SELECT A.id,B.id
FROM A RIGHT OUTER JOIN B
ON A.id = B.id
UNION 
SELECT A.id,B.id
FROM A LEFT OUTER JOIN B
ON A.id = B.id;

-- 2
SELECT A.id,B.id
FROM A FULL OUTER JOIN B
ON A.id = B.id
ORDER BY A.ID;

-- 3
SELECT A.id,B.id
FROM A  INNER JOIN B
ON A.id = B.id
UNION ALL 
SELECT ID, NULL
FROM A
WHERE NOT EXISTS (SELECT 1 FROM B WHERE A.ID = B.ID)
UNION ALL
SELECT NULL, ID 
FROM B
WHERE NOT EXISTS (SELECT 1 FROM A WHERE A.ID = B.ID)
 
SELECT ID,SCORE, NTILE(4) OVER (ORDER BY score desc) div
FROM SCORE_RECORD sr
WHERE "Time" > '20201201' AND (id = 1 OR id = 2);

SELECT COALESCE(NULLIF(1,1),200,300) DATA
FROM DUAL;




-- DAY 29 JAN




SELECT 
	TO_CHAR(EXTRACT(YEAR FROM "Time")) || ',' ||
	'0' || EXTRACT(MONTH FROM "Time")
FROM SCORE_RECORD sr 
WHERE rownum < 2;

SELECT 
	EXTRACT(YEAR FROM "Time"),
	LPAD(EXTRACT(MONTH FROM "Time"),2,'0')
FROM SCORE_RECORD sr 
WHERE rownum < 2;


SELECT *
FROM 
(
	SELECT hc,"Role" r, Round(AVG(score),2) mean
	FROM STUDENT_LIST sl
	GROUP BY GROUPING SETS(HC,(HC,"Role"))
	ORDER BY mean desc
) a
WHERE a.r IS NOT NULL;

SELECT *
FROM STUDENT_LIST sl 
WHERE NAME LIKE '%oul%';





-- DAY 30 JAN






-- column 이름만 알 때 테이블 이름 찾기, 일부만 알 경우 where에 like 사용 가능 
SELECT 
	TABLE_NAME,
	COLUMN_NAME 
FROM ALL_TAB_COLUMNS atc 
WHERE 1=1
	AND COLUMN_NAME = 'STUDENT_ID';

-- 加拂可 相異獨生


SELECT *
FROM scott.EMP e;

SELECT e.* 
FROM EMP e,EMP e2 
WHERE e.ENAME = 'Test1'
	AND e.MGR = e2.MGR;

SELECT 
	LEVEL, 
	LPAD(e.EMPNO,(LEVEL)*3,' ') Num, 
	e.DEPTNO, 
	e.MGR 
FROM EMP e 
START WITH mgr IS NULL
CONNECT BY PRIOR EMPNO = MGR
ORDER BY LEVEL; 	

SELECT
	STUDENT_ID,
	SCORE,
	DENSE_RANK() OVER (ORDER BY score desc) Rank
FROM STUDENT_LIST sl;

SELECT avg(score)
FROM SCORE_RECORD sr;




-- DAY 31 JAN






SELECT
	ID,
	SCORE,
	DENSE_RANK() OVER (PARTITION BY ID ORDER BY SCORE DESC) R
FROM SCORE_RECORD sr2
WHERE rownum < 3;

SELECT 
	student_id,
	SCORE,
	RANK() OVER (ORDER BY SCORE)
FROM STUDENT_LIST sl;

SELECT 
	ENAME, 
	DEPTNO,
	JOB,
	RANK() OVER (PARTITION BY DEPTNO,JOB ORDER BY SAL DESC) AS Part
FROM EMP e 

CREATE OR REPLACE TABLE USER_MANAGER
(
	ID varchar(20),
	Created TimeStamp DEFAULT Current_TimeStamp
);
ALTER TABLE	USER_MANAGER MODIFY(created DEFAULT CURRENT_TIMESTAMP);

INSERT INTO USER_MANAGER(ID) values(1);

SELECT * FROM USER_MANAGER um;


SELECT *
FROM 
(
SELECT *
FROM STUDENT_LIST sl 
ORDER BY SCORE 
)
WHERE rownum < 5;

-- 만든 함수 호출 : 무작위 번호를 입력하고 USER_MANAGER 테이블에는 현재 시간이 디폴트로 입력 
CALL insert_random_number();

-- JOB 만들기
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'INSERTING_JOB',
            job_type => 'STORED_PROCEDURE',
            job_action => 'insert_random_number',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=6',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE);
END;

-- JOB 목록 확인
SELECT * FROM USER_SCHEDULER_JOBS;

-- JOB 활성화
BEGIN
  DBMS_SCHEDULER.disable(name=>'INSERTING_JOB');
END;

select H.hacker_id,H.name,added.total
from 
hackers H,
(
select 
    distinct hacker_id, sum(score) over (partition by hacker_id) total
from 
    (
        SELECT hacker_id, challenge_id, score
        FROM (
            SELECT hacker_id, challenge_id, score,
                   ROW_NUMBER() OVER (PARTITION BY hacker_id, challenge_id ORDER BY score DESC) AS rn
            FROM submissions
    ) ranked
    WHERE rn <= 1
    ) maxed
order by total
) added
where added.hacker_id = H.hacker_id and total != 0
order by added.total desc;




-- DAY 1 FEB




-- 각 연도별 and 각 ID 별 평균 
SELECT EXTRACT(YEAR FROM "Time"), ID, Round(AVG(score),1)
FROM SCORE_RECORD sr
GROUP BY EXTRACT(YEAR FROM "Time"), ID
ORDER BY EXTRACT(YEAR FROM "Time"), ID;


-- 위의 결과에서 Group By Id 부분을 컬럼으로 빼서 테이블처럼 만듦
SELECT 
    EXTRACT(YEAR FROM "Time") AS Year,
    ROUND(AVG(CASE WHEN ID = '1' THEN score ELSE NULL END), 1) AS ID1,
    ROUND(AVG(CASE WHEN ID = '2' THEN score ELSE NULL END), 1) AS ID2,
    ROUND(AVG(CASE WHEN ID = '3' THEN score ELSE NULL END), 1) AS ID3,
    ROUND(AVG(CASE WHEN ID = '4' THEN score ELSE NULL END), 1) AS ID4,
    ROUND(AVG(CASE WHEN ID = '5' THEN score ELSE NULL END), 1) AS ID5,
    ROUND(AVG(CASE WHEN ID = '6' THEN score ELSE NULL END), 1) AS ID6,
    ROUND(AVG(CASE WHEN ID = '7' THEN score ELSE NULL END), 1) AS ID7,
    ROUND(AVG(CASE WHEN ID = '8' THEN score ELSE NULL END), 1) AS ID8,
    ROUND(AVG(CASE WHEN ID = '9' THEN score ELSE NULL END), 1) AS ID9,
    ROUND(AVG(CASE WHEN ID = '10' THEN score ELSE NULL END), 1) AS ID10
FROM 
    SCORE_RECORD sr
GROUP BY 
	EXTRACT(YEAR FROM sr."Time") 
ORDER BY 
    Year;

SELECT DISTINCT ID
FROM SCORE_RECORD sr
ORDER BY ID; 

-- 오라클 버전 확인용, 19c Enterprise 버전으로 확인
SELECT * FROM "V$VERSION" o;


--LEVEL 사용

-- 1부터 10까지 오름차순
SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 10;

-- 9부터 0까지 내림순 (- LEVEL 사용)
SELECT 10 - LEVEL FROM DUAL CONNECT BY LEVEL <= 10;

-- 2 ~ 20 2씩 증가
SELECT LEVEL*2 FROM DUAL CONNECT BY LEVEL <= 10;

-- 0.5씩 증가 
SELECT LEVEL*0.5 FROM DUAL CONNECT BY LEVEL <= 10;


-- 커서 사용
DECLARE 
	DECLARE_AT SCOTT.SCORE_RECORD."Time"%type;
	CU_ID SCOTT.SCORE_RECORD.ID%type;
	CU_SCORE SCOTT.SCORE_RECORD.SCORE%type;

-- 커서 선언 후 select값 넣음
CURSOR cu1 IS 
	SELECT "Time",ID,SCORE 
	FROM SCOTT.SCORE_RECORD sr
	WHERE rownum < 4; 

BEGIN 
	-- 커서 사용 시작 Open
	OPEN cu1;
	FETCH cu1 INTO DECLARE_AT,CU_ID,CU_SCORE;
	dbms_output.put_line(DECLARE_AT||'  '||CU_ID||'  '||CU_SCORE);
	FETCH cu1 INTO DECLARE_AT,CU_ID,CU_SCORE;
	dbms_output.put_line(DECLARE_AT||'  '||CU_ID||'  '||CU_SCORE);
	FETCH cu1 INTO DECLARE_AT,CU_ID,CU_SCORE;
	dbms_output.put_line(DECLARE_AT||'  '||CU_ID||'  '||CU_SCORE);
	FETCH cu1 INTO DECLARE_AT,CU_ID,CU_SCORE;
	dbms_output.put_line(DECLARE_AT||'  '||CU_ID||'  '||CU_SCORE);
	dbms_output.put_line(cu1%rowcount);
	
/*	LOOP
		-- 커서에서 하나씩 값을 반출
		FETCH cu1 INTO DECLARE_AT,CU_ID,CU_SCORE;
		EXIT WHEN cu1%NotFound; -- 더 이상 반출 불가능하면 반복 종료 
		dbms_output.put_line(DECLARE_AT||'  '||CU_ID||'  '||CU_SCORE);
	END LOOP; */
	-- 커서 사용 종료
	CLOSE cu1;
END;

DECLARE 
	cnt1 NUMBER;
	cnt2 NUMBER;
BEGIN 
	SELECT count(*) INTO cnt1
	FROM SCOTT.STUDENT_LIST sl; 
	
	cnt2 := SQL%rowcount;

	dbms_output.put_line('cnt1 : ' || cnt1);
	dbms_output.put_line('cnt2 : ' || cnt2);
END;

-- 짝수열만 출력
SELECT *
FROM
(
SELECT STUDENT_ID, NAME, rownum r
FROM SCOTT.STUDENT_LIST sl 
) a
WHERE MOD(a.r,2) = 0;

SELECT STUDENT_ID, NAME, MOD(STUDENT_ID,2)
FROM SCOTT.STUDENT_LIST sl
WHERE MOD(STUDENT_ID,2) = 0;

SELECT TO_CHAR(a.YR) Year,a.mean A,b.mean B
from
(SELECT EXTRACT(YEAR FROM "Time") YR, Round(avg(score)) Mean
FROM SCOTT.SCORE_RECORD
WHERE id = 3
GROUP BY EXTRACT(YEAR FROM "Time")) a INNER JOIN 
(SELECT EXTRACT(YEAR FROM "Time") YR, Round(avg(score)) Mean
FROM SCOTT.SCORE_RECORD
WHERE id = 5
GROUP BY EXTRACT(YEAR FROM "Time")) b 
ON a.YR = b.YR
ORDER BY a.YR;


-- Index 활성화 & 비활성화
ALTER INDEX RECORD_IDX unusable;
ALTER INDEX RECORD_IDX Rebuild;

-- for문 연습
DECLARE 
num1 NUMBER := 1;
BEGIN 
	LOOP
		DBMS_output.put_line(num1);
		num1 := num1 + 1;
		EXIT WHEN num1 > 10;
	END LOOP;
END;









