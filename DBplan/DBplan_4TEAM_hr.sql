SELECT USER
FROM DUAL;
--==>> HR

------------------------------���̺� ����----------------------------------------
--���������� ���̺�
CREATE TABLE TBL_ADMIN
( ADMIN_CODE VARCHAR2(20) 
, ADMIN_PW   VARCHAR2(20) CONSTRAINT ADMIN_ADMIN_PW_NN NOT NULL
, CONSTRAINT ADMIN_ADMIN_CODE_PK PRIMARY KEY(ADMIN_CODE)
);
--==>> Table TBL_ADMIN��(��) �����Ǿ����ϴ�.


-- �������� ���̺�
-- �����ڵ� ù �ڸ� P�� ���� P || 0001 ~~
-- �ֹι�ȣ ���ڸ����� ù �ڸ��� �Է� ������ ������ 1,2,3,4 �������� ����
CREATE TABLE TBL_PROFESSOR
( PROF_CODE VARCHAR2(20)                                                                -- �����ڵ� PK 
, PROF_NAME VARCHAR2(20)         CONSTRAINT PROFESSOR_PROF_NAME_NN NOT NULL             -- �����̸�
, PROF_SSN  CHAR(7)              CONSTRAINT PROFESSOR_PROF_SSN_NN NOT NULL              -- �ֹι�ȣ ���ڸ�
, PROF_PW   VARCHAR2(20)         CONSTRAINT PROFESSOR_PROF_PW_NN NOT NULL               -- ����PW
, PROF_DATE  DATE DEFAULT SYSDATE CONSTRAINT PROFESSOR_PROF_DATE_NN NOT NULL             -- �������
, CONSTRAINT PROFESSOR_PROF_CODE_PK PRIMARY KEY(PROF_CODE)                                   -- �����ڵ� �⺻Ű
, CONSTRAINT PROFESSOR_PROF_SSN_CK  CHECK(SUBSTR(PROF_CODE,1,1) IN ('1','2','3','4'))        -- �����ֹι�ȣ CK
);
--==>> Table TBL_PROFESSOR��(��) �����Ǿ����ϴ�.

--ALTER TABLE TBL_PROFESSOR
--MODIFY PROF_PW DEFAULT PROF_SSN;       


-- �л����� ���̺�
-- �л��ڵ� ù �ڸ� S�� ���� S || 0001 ~~
-- �ֹι�ȣ ���ڸ����� ù �ڸ��� �Է� ������ ������ 1,2,3,4 �������� ����
CREATE TABLE TBL_STUDENT
( STD_CODE  VARCHAR2(20)                                                                -- �л��ڵ�
, STD_NAME  VARCHAR2(20)    CONSTRAINT STUDENT_STD_NAME_NN NOT NULL                     -- �л��̸�
, STD_SSN   CHAR(7)         CONSTRAINT STUDENT_STD_SSN_NN NOT NULL                      -- �ֹι�ȣ ���ڸ�
, STD_PW    VARCHAR2(20)    CONSTRAINT STUDENT_STD_PW_NN NOT NULL                       -- �л�PW
, STD_DATE  DATE            DEFAULT SYSDATE   CONSTRAINT STUDENT_STD_DATE_NN NOT NULL   -- �������
, CONSTRAINT STUDENT_STD_CODE_PK PRIMARY KEY(STD_CODE)
, CONSTRAINT STUDENT_STD_SSN_CK CHECK(SUBSTR(STD_SSN, 1, 1) IN ('1', '2', '3', '4'))
);
--==>> Table TBL_STUDENT��(��) �����Ǿ����ϴ�.


-- �������� ���̺�
CREATE TABLE TBL_COURSE
( CRS_CODE VARCHAR2(20)                                                                 -- �����ڵ�
, CRS_NAME VARCHAR2(50) CONSTRAINT COURSE_CRS_NAME_NN NOT NULL                          -- �����̸�
, CONSTRAINT COURSE_CRS_CODE_PK PRIMARY KEY(CRS_CODE)
);
--==>> Table TBL_COURSE��(��) �����Ǿ����ϴ�.

ALTER TABLE TBL_COURSE MODIFY CRS_NAME VARCHAR2(100);
--==>> Table TBL_COURSE��(��) ����Ǿ����ϴ�.

-- �������� ���̺�
CREATE TABLE TBL_SUBJECT
( SUB_CODE  VARCHAR2(20)                                                                -- �����ڵ�
, SUB_NAME  VARCHAR2(50) CONSTRAINT SUBJECT_SUB_NAME_NN NOT NULL                        -- �����̸�
, CONSTRAINT SUBJECT_SUB_CODE_PK PRIMARY KEY(SUB_CODE)
);
--==>> Table TBL_SUBJECT��(��) �����Ǿ����ϴ�.


-- �������� ���̺�
CREATE TABLE TBL_BOOK
( BOOK_CODE VARCHAR2(20)                                                                -- �����ڵ�
, BOOK_NAME VARCHAR2(50)    CONSTRAINT BOOK_BOOK_NAME_NN NOT NULL                       -- �����̸�
, CONSTRAINT BOOK_BOOK_CODE_PK PRIMARY KEY(BOOK_CODE)
);
--==>> Table TBL_BOOK��(��) �����Ǿ����ϴ�.
ALTER TABLE TBL_BOOK MODIFY BOOK_NAME VARCHAR2(100);
--==>> Table TBL_BOOK��(��) ����Ǿ����ϴ�.

-- ���ǽ����� ���̺�
-- �����ο� �������� ����
CREATE TABLE TBL_ROOM
( ROOM_CODE VARCHAR2(20)                                                                -- ���ǽ��ڵ�
, ROOM_NAME VARCHAR2(30)    CONSTRAINT ROOM_ROOM_NAME_NN NOT NULL                       -- ���ǽ��̸�
, ROOM_NUM  NUMBER(3)       CONSTRAINT ROOM_ROOM_NUM_NN NOT NULL                        -- �����ο�
, CONSTRAINT ROOM_ROOM_CODE_PK PRIMARY KEY(ROOM_CODE)
, CONSTRAINT ROOM_ROOM_NUM_CK CHECK(ROOM_NUM > 0)
);
--==>> Table TBL_ROOM��(��) �����Ǿ����ϴ�.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';


-- �������� ���̺�
-- �����������ڰ� SYSDATE < ������������ ���� �� TRIGGER
-- �����������ڰ� ����������� < ������������ �������� ����
CREATE TABLE TBL_OPENC
( OPENC_CODE  VARCHAR2(20)                                                              -- ���������ڵ�
, CRS_CODE    VARCHAR2(20) CONSTRAINT OPENC_CRS_CODE_NN NOT NULL                        -- �����ڵ�
, ROOM_CODE   VARCHAR2(20) CONSTRAINT OPENC_ROOM_CODE_NN NOT NULL                       -- ���ǽ��ڵ�
, CRS_START   DATE CONSTRAINT OPENC_CRS_START_NN NOT NULL                               -- ������������
, CRS_END     DATE CONSTRAINT OPENC_CRS_END_NN NOT NULL                                 -- ������������
, CONSTRAINT OPENC_OPENC_CODE_PK PRIMARY KEY(OPENC_CODE)
, CONSTRAINT OPENC_CRS_CODE_FK FOREIGN KEY(CRS_CODE)
             REFERENCES TBL_COURSE(CRS_CODE)
, CONSTRAINT OPENC_ROOM_CODE_FK FOREIGN KEY(ROOM_CODE)
             REFERENCES TBL_ROOM(ROOM_CODE)
--, CONSTRAINT OPENC_CRS_START_CK CHECK (SYSDATE < CRS_START)           INSERT TRIGGER�� �����ؾ��� �κ�
, CONSTRAINT OPENC_CRS_END_CK CHECK (CRS_START < CRS_END)
);
--==>> Table TBL_OPENC��(��) �����Ǿ����ϴ�.


-- ���񰳼� ���̺�
-- ����������ڰ� SYSDATE < ����������� ���� �� TRIGGER
-- �����������ڰ� ����������� < ������������ �������� ����
-- ���� 0~100����, ���� ���� 100������ ������ ����ó���� �Ұ��� ���⼭ ��������? ��
CREATE TABLE TBL_OPENS
( OPENS_CODE    VARCHAR2(20)                                                            -- ���񰳼��ڵ�
, OPENC_CODE    VARCHAR2(20) CONSTRAINT OPENS_OPENC_CODE_NN NOT NULL                    -- ���������ڵ�
, SUB_CODE      VARCHAR2(20) CONSTRAINT OPENS_SUB_CODE_NN NOT NULL                      -- �����ڵ�
, BOOK_CODE     VARCHAR2(20) CONSTRAINT OPENS_BOOK_CODE_NN NOT NULL                     -- �����ڵ�
, PROF_CODE     VARCHAR2(20) CONSTRAINT OPENS_PROF_CODE_NN NOT NULL                     -- �����ڵ�
, SUB_START     DATE         CONSTRAINT OPENS_SUB_STRAT_NN NOT NULL                     -- �����������
, SUB_END       DATE         CONSTRAINT OPENS_SUB_END_NN NOT NULL                       -- ������������
, C_PERCENT     NUMBER(3)                                                              -- ������
, S_PERCENT     NUMBER(3)                                                              -- �Ǳ����
, P_PERCENT     NUMBER(3)                                                              -- �ʱ����
, CONSTRAINT OPENS_OPENS_CODE_PK PRIMARY KEY(OPENS_CODE)
, CONSTRAINT OPENS_OPENC_CODE_FK FOREIGN KEY(OPENC_CODE) REFERENCES TBL_OPENC(OPENC_CODE)
, CONSTRAINT OPENS_SUB_CODE_FK FOREIGN KEY(SUB_CODE) REFERENCES TBL_SUBJECT(SUB_CODE)
, CONSTRAINT OPENS_BOOK_CODE_FK FOREIGN KEY(BOOK_CODE) REFERENCES TBL_BOOK(BOOK_CODE)
, CONSTRAINT OPENS_PROF_CODE_FK FOREIGN KEY(PROF_CODE) REFERENCES TBL_PROFESSOR(PROF_CODE)
--, CONSTRAINT OPENS_SUB_START_CK CHECK (SYSDATE < SUB_START)            INSERT TRIGGER�� �����ؾ��� �κ�
, CONSTRAINT OPENS_SUB_END_CK CHECK (SUB_START < SUB_END)
, CONSTRAINT OPENS_PERCENT_TOTAL_CK CHECK (C_PERCENT + S_PERCENT + P_PERCENT = 100)
, CONSTRAINT OPENS_C_PERCENT_CK CHECK (0 <= C_PERCENT AND C_PERCENT <= 100)
, CONSTRAINT OPENS_S_PERCENT_CK CHECK (0 <= S_PERCENT AND S_PERCENT <= 100)
, CONSTRAINT OPENS_P_PERCENT_CK CHECK (0 <= P_PERCENT AND P_PERCENT <= 100)
);
--==>> Table TBL_OPENS��(��) �����Ǿ����ϴ�.



-- ������û ���̺�
-- ������û���� �� ������û����(SYSDATE) < ������������ �������� ���� �� INSERT ���ν����� �����ؾ��� �κ�
CREATE TABLE TBL_REGISTER                                                       
( REGISTER_CODE VARCHAR2(20)                                                        -- ������û�ڵ�
, OPENC_CODE    VARCHAR2(20)          CONSTRAINT REGISTER_OPENC_CODE_NN NOT NULL    -- ���������ڵ�
, STD_CODE      VARCHAR2(20)          CONSTRAINT REGISTER_STD_CODE_NN NOT NULL      -- �л��ڵ�
, REGISTER_DATE DATE DEFAULT SYSDATE  CONSTRAINT REGISTER_REGISTER_DATE_NN NOT NULL -- ������û����
, CONSTRAINT REGISTER_REGISTER_CODE_PK PRIMARY KEY(REGISTER_CODE)                   -- ������û�ڵ� �⺻Ű
, CONSTRAINT REGISTER_OPENC_CODE_FK FOREIGN KEY(OPENC_CODE)                         -- ���������ڵ� FK
            REFERENCES TBL_OPENC(OPENC_CODE)
, CONSTRAINT REGISTER_STU_CODE_FK FOREIGN KEY(STD_CODE)                             -- �л��ڵ� FK
            REFERENCES TBL_STUDENT(STD_CODE)
--, CONSTRAINT REGISTER_REGI_CODE_CK CHECK(REGISTER_CODE BETWEEN 30000 AND 39999)      -- ������û�ڵ� CK
);
--==>> Table TBL_REGISTER��(��) �����Ǿ����ϴ�.


-- �������� ���̺� ����
-- ��� �� 0 <= ��� <= ������  ���ν������� �����ؾ��� �κ�
CREATE TABLE TBL_SCORE
( REGISTER_CODE VARCHAR2(20) CONSTRAINT SCORE_REGISTER_CODE_NN NOT NULL             -- ������û�ڵ�
, OPENS_CODE    VARCHAR2(20) CONSTRAINT SCORE_OPENS_CODE_NN NOT NULL                -- ���񰳼��ڵ�
, C_SCORE       NUMBER(3)                                                           -- ���
, S_SCORE       NUMBER(3)                                                           -- �Ǳ�
, P_SCORE       NUMBER(3)                                                           -- �ʱ�
, CONSTRAINT SCORE_REGISTER_CODE_FK FOREIGN KEY(REGISTER_CODE)
             REFERENCES TBL_REGISTER(REGISTER_CODE)
, CONSTRAINT SCORE_OPENS_CODE_FK FOREIGN KEY(OPENS_CODE)
             REFERENCES TBL_OPENS(OPENS_CODE)
);
--==>> Table TBL_SCORE��(��) �����Ǿ����ϴ�.


-- �ߵ�Ż��
-- �ߵ�Ż������ ������������ <= �ߵ�Ż������ < ������������   �� ���ν������� �����ؾ��� �κ�
-- ���� �ߵ�Ż�� ��û���ڿ� ��ܿ� �߰��� Ż�����ڰ� �ٸ� �� �־ DEFAULT SYSDATE �������� �ʾ���
CREATE TABLE TBL_FAIL
( REGISTER_CODE VARCHAR2(20)     CONSTRAINT FAIL_REGISTER_CODE_NN NOT NULL           -- ������û�ڵ�
, FAIL_DATE     DATE            CONSTRAINT FAIL_FAIL_DATE_NN NOT NULL               -- �ߵ�Ż������
, FAIL_REASON   VARCHAR2(100)                                                       -- �ߵ�Ż������
, CONSTRAINT FAIL_REGISTER_CODE_FK FOREIGN KEY(REGISTER_CODE)
             REFERENCES TBL_REGISTER(REGISTER_CODE)
);
--==>> Table TBL_FAIL��(��) �����Ǿ����ϴ�.

------------------------------���̺� ���� ��-------------------------------------

------------------------------������ �Է�----------------------------------------

SET SERVEROUTPUT ON;
--==>> �۾��� �Ϸ�Ǿ����ϴ�.

--���̺��� ��ȸ
SELECT OBJECT_NAME
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TABLE';

--���� ��ȸ
SELECT OBJECT_NAME
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'VIEW';

--���ν������ ��ȸ
SELECT OBJECT_NAME
FROM USER_PROCEDURES
WHERE OBJECT_TYPE = 'PROCEDURE';

--�Լ���� ��ȸ
SELECT OBJECT_NAME
FROM USER_PROCEDURES
WHERE OBJECT_TYPE = 'FUNCTION';

SELECT *
FROM TBL_OPENS;

--���� Sequence �� ��ȸ
SELECT SEQ_REGISTER.CURRVAL
FROM DUAL;

--Sequence �ʱ�ȭ ����
ALTER SEQUENCE SEQ_REGISTER INCREMENT BY -18;
SELECT SEQ_REGISTER.NEXTVAL
FROM DUAL;
ALTER SEQUENCE SEQ_REGISTER INCREMENT BY 1; 


-- ������ ���� �Է�
INSERT INTO TBL_ADMIN(ADMIN_CODE,ADMIN_PW)
VALUES('ADMIN',1234);
--==>> 1 �� ��(��) ���ԵǾ����ϴ�.

SELECT *
FROM TBL_ADMIN;

-- �л� �Է� 
EXEC PRC_STUDENT_INSERT('�谡��', '2345678');
EXEC PRC_STUDENT_INSERT('�輭��', '2456789');
EXEC PRC_STUDENT_INSERT('������', '2102938');
EXEC PRC_STUDENT_INSERT('�̻�ȭ', '2683941');
EXEC PRC_STUDENT_INSERT('�̻���', '2987646');
EXEC PRC_STUDENT_INSERT('��ȣ��', '1029385');
EXEC PRC_STUDENT_INSERT('������', '2385921');
EXEC PRC_STUDENT_INSERT('������', '2638493');
EXEC PRC_STUDENT_INSERT('������', '1958302');
EXEC PRC_STUDENT_INSERT('������', '1385921');
EXEC PRC_STUDENT_INSERT('���ϸ�', '4385921');
EXEC PRC_STUDENT_INSERT('������', '3385921');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
SELECT *
FROM TBL_STUDENT;

-- ���� �Է�
EXEC PRC_PROFESSOR_INSERT('����ȣ', '1234567');
EXEC PRC_PROFESSOR_INSERT('������', '1968203');
EXEC PRC_PROFESSOR_INSERT('�ں���', '2968391');
EXEC PRC_PROFESSOR_INSERT('���α�', '1968402'); 
EXEC PRC_PROFESSOR_INSERT('�ں���', '2596820');
EXEC PRC_PROFESSOR_INSERT('�۰�', '1852818');
EXEC PRC_PROFESSOR_INSERT('�̼�', '2485921');
EXEC PRC_PROFESSOR_INSERT('�ں���', '2948518');
EXEC PRC_PROFESSOR_INSERT('�����', '2182212');
EXEC PRC_PROFESSOR_INSERT('������', '2166192');
EXEC PRC_PROFESSOR_INSERT('������', '3199494');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
SELECT *
FROM TBL_PROFESSOR;

-- ���� ���� �Է�
EXEC PRC_COURSE_INSERT('�Ӻ���� �÷��� ���� ���� ������ �缺 ����');
EXEC PRC_COURSE_INSERT('AWS Ŭ���� Ȱ�� Ǯ���� ������ �缺 ����');
EXEC PRC_COURSE_INSERT('JAVA ����� ����Ʈ �� Ǯ���� ������ �缺����');
EXEC PRC_COURSE_INSERT('JAVA�� Ȱ���� �� ������ �缺����');
EXEC PRC_COURSE_INSERT('UI/UX�� Ȱ���� �� �ۺ��� ����');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
SELECT *
FROM TBL_COURSE;

-- ���� ���� �Է�
EXEC PRC_SUBJECT_INSERT('Java');
EXEC PRC_SUBJECT_INSERT('Oracle');
EXEC PRC_SUBJECT_INSERT('HTML');
EXEC PRC_SUBJECT_INSERT('CSS');
EXEC PRC_SUBJECT_INSERT('JSP');
EXEC PRC_SUBJECT_INSERT('Servlet');
EXEC PRC_SUBJECT_INSERT('UI/UX');
EXEC PRC_SUBJECT_INSERT('JavaScript');
EXEC PRC_SUBJECT_INSERT('jQuery');
EXEC PRC_SUBJECT_INSERT('��Ʈ��ũ');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
SELECT *
FROM TBL_SUBJECT;

-- ���ǽ� �Է�
EXEC PRC_ROOM_INSERT('A������', 20);
EXEC PRC_ROOM_INSERT('B������', 10);
EXEC PRC_ROOM_INSERT('C������', 15);
EXEC PRC_ROOM_INSERT('D������', 25);
EXEC PRC_ROOM_INSERT('E������', 18);
EXEC PRC_ROOM_INSERT('F������', 22);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
SELECT *
FROM TBL_ROOM;

-- ���� �Է�
EXEC PRC_BOOK_INSERT('�ڹ��� ����');
EXEC PRC_BOOK_INSERT('�̰��� �ڹٴ�');
EXEC PRC_BOOK_INSERT('HTML5+CSS3 ��ǥ���� ����');
EXEC PRC_BOOK_INSERT('Do it! �ڹٽ�ũ��Ʈ + �������� �Թ�');
EXEC PRC_BOOK_INSERT('���� ��� �������� AWS ������ ���� ���̵�');
EXEC PRC_BOOK_INSERT('UML ���ʿ� ����');
EXEC PRC_BOOK_INSERT('����Ŭ�� ���� �����ͺ��̽� ���а� �ǽ�');
EXEC PRC_BOOK_INSERT('����� ��Ʈ��ũ');
EXEC PRC_BOOK_INSERT('UI/UX �䱸 �м�');
EXEC PRC_BOOK_INSERT('JSP �� ���α׷��� �Թ�+Ȱ��');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_BOOK;

-- �������� �Է� PRC_OPENC_INSERT(�����ڵ�,���ǽ��ڵ�,������������,������������)
INSERT INTO TBL_OPENC(OPENC_CODE, CRS_CODE, ROOM_CODE, CRS_START, CRS_END)  
VALUES('9999', '1000', '3000', '2020-11-01', '2021-02-01');
INSERT INTO TBL_OPENC(OPENC_CODE, CRS_CODE, ROOM_CODE, CRS_START, CRS_END) 
VALUES ('9998','1004','3005','2021-02-04','2021-05-02');
EXEC PRC_OPENC_INSERT('1000', '3000', '2021-05-03', '2021-08-03');
EXEC PRC_OPENC_INSERT('1001', '3005', '2021-06-14', '2021-09-14');
EXEC PRC_OPENC_INSERT('1002', '3003', '2021-07-19', '2021-10-19');
EXEC PRC_OPENC_INSERT('1003', '3003', '2021-10-22', '2022-01-22');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_OPENC;

-- ���񰳼� �Է� PRC_OPENS_INSERT(���������ڵ�, �����ڵ�, ���������, ����������, �����ڵ�, �������ڵ�)
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29999','9999', '2000', '2020-11-01', '2020-12-01', '4000', 'P20211001');                                 
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29998','9999', '2001', '2020-12-02', '2021-01-03', '4006', 'P20211002');                                 
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29997','9999', '2002', '2021-01-04', '2021-02-01', '4002', 'P20211003');
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29994','9998', '2006', '2021-02-04', '2021-03-01', '4009', 'P20211009');
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29995','9998', '2001', '2021-03-02', '2021-04-03', '4001', 'P20211010');
INSERT INTO TBL_OPENS(OPENS_CODE,OPENC_CODE, SUB_CODE, SUB_START, SUB_END, BOOK_CODE, PROF_CODE) 
VALUES('29996','9998', '2002', '2021-04-04', '2021-05-02', '4006', 'P20211011');

-- ���񰳼� �Է� PRC_OPENS_INSERT(���������ڵ�, �����ڵ�, ���������, ����������, �����ڵ�, �������ڵ�)
EXEC PRC_OPENS_INSERT('10000', '2000', '2021-05-03', '2021-06-03', '4000', 'P20211001');
EXEC PRC_OPENS_INSERT('10000', '2001', '2021-06-04', '2021-07-03', '4006', 'P20211002');
EXEC PRC_OPENS_INSERT('10000', '2005', '2021-07-04', '2021-08-03', '4008', 'P20211003');
EXEC PRC_OPENS_INSERT('10001', '2003', '2021-06-14', '2021-07-13', '4002', 'P20211004');
EXEC PRC_OPENS_INSERT('10001', '2004', '2021-07-14', '2021-08-13', '4008', 'P20211005');
EXEC PRC_OPENS_INSERT('10001', '2002', '2021-08-14', '2021-09-14', '4002', 'P20211006');
EXEC PRC_OPENS_INSERT('10002', '2000', '2021-07-19', '2021-08-18', '4001', 'P20211007');
EXEC PRC_OPENS_INSERT('10002', '2007', '2021-08-19', '2021-09-18', '4003', 'P20211008');
EXEC PRC_OPENS_INSERT('10002', '2008', '2021-09-19', '2021-10-19', '4003', 'P20211009');
EXEC PRC_OPENS_INSERT('10003', '2009', '2021-10-22', '2021-11-21', '4007', 'P20211010');
EXEC PRC_OPENS_INSERT('10003', '2006', '2021-11-22', '2021-12-21', '4009', 'P20211011');
EXEC PRC_OPENS_INSERT('10003', '2004', '2021-12-22', '2022-01-22', '4008', 'P20211001');

SELECT *
FROM TBL_OPENS;

--������û�Է� (������û�ڵ�, ���������ڵ�, �л��ڵ�, ������û����)
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39999', '9999', 'S20211001', TO_DATE('2020-10-25','YYYY-MM-DD')) ;                                              
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39998', '9999', 'S20211002', TO_DATE('2020-10-25','YYYY-MM-DD')) ;                                              
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39997', '9999', 'S20211003', TO_DATE('2020-10-25','YYYY-MM-DD')) ;
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39996', '9998', 'S20211009', TO_DATE('2021-01-30','YYYY-MM-DD')) ;  
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39995', '9998', 'S20211008', TO_DATE('2021-01-30','YYYY-MM-DD')) ;  
INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE, REGISTER_DATE) 
VALUES('39994', '9998', 'S20211010', TO_DATE('2021-01-30','YYYY-MM-DD')) ;  

--������û�Է� (������û�ڵ�, ���������ڵ�, �л��ڵ�, ������û����)
EXEC PRC_REGISTER_INSERT('10000', 'S20211001'); 
EXEC PRC_REGISTER_INSERT('10000', 'S20211006'); 
EXEC PRC_REGISTER_INSERT('10000', 'S20211007'); 
EXEC PRC_REGISTER_INSERT('10001', 'S20211003'); 
EXEC PRC_REGISTER_INSERT('10001', 'S20211004'); 
EXEC PRC_REGISTER_INSERT('10001', 'S20211011'); 
EXEC PRC_REGISTER_INSERT('10002', 'S20211012'); 
EXEC PRC_REGISTER_INSERT('10002', 'S20211002'); 
EXEC PRC_REGISTER_INSERT('10002', 'S20211005');
EXEC PRC_REGISTER_INSERT('10003', 'S20211009'); 
EXEC PRC_REGISTER_INSERT('10003', 'S20211008');
EXEC PRC_REGISTER_INSERT('10003', 'S20211010');

SELECT *
FROM TBL_REGISTER;

-- ���� ���̺� ��ȸ (������û�ڵ�, ���񰳼��ڵ�, �������, �Ǳ�����, �ʱ�����)
SELECT *
FROM TBL_SCORE;

SELECT *
FROM TBL_SCORE;

-- ������û ���̺� DELETE ���ν��� ���� PRC_REGISTER_DELETE(������û�ڵ�)
EXEC PRC_REGISTER_DELETE('39999');


--�ߵ�Ż�� �Է� PRC_FAIL_INSERT(������û�ڵ�, �ߵ�Ż������, �ߵ�Ż������)
EXEC PRC_FAIL_INSERT('39994', SYSDATE ,'�������');

--�ߵ�Ż�� ���� PRC_FAIL_DELETE(������û�ڵ�)
--EXEC PRC_FAIL_DELETE('39994');

SELECT *
FROM TBL_FAIL;


--������ �α��� ���ν���
EXEC PRC_LOGIN_ADMIN('ADMIN','1234');

--������ �н����� ���� ���ν���
EXEC PRC_ADMIN_UPDATE('ADMIN', 'ADMIN2', '1234', '5678');

--�л� �α��� ���ν���
EXEC PRC_LOGIN_STUDENT('S20211002','2456789');

--�л� �н����� ���� ���ν��� PRC_STUDENT_UPDATE(�л��ڵ�, ����PW, �ٲ�PW)
EXEC PRC_STUDENT_UPDATE('S20211001', '2345678', 'RLARKDUD');

--�л� ���� ���� ���ν���(����������) PRC_AD_STUDENT_UPDATE(�л��ڵ�, NEW�̸�, NEW�ֹι�ȣ)
EXEC PRC_AD_STUDENT_UPDATE('S20211001', '�質��', '2345678');

SELECT *
FROM TBL_STUDENT;

--�л� ���� ���� ���ν��� PRC_STUDENT_DELETE(�л��ڵ�)
EXEC PRC_STUDENT_DELETE('S20211001');

--���� �α��� ���ν���
EXEC PRC_LOGIN_PROFESSOR('P20211001','RLARKDUD');

--���� �н����� ���� ���ν���
EXEC PRC_PROFESSOR_UPDATE('P20211001', '����ȣ', '1234567', 'RLARKDUD');

--���� ���� ���� ���ν���(����������) PRC_AD_PROFESSOR_UPDATE(�ڵ�, NEW�̸�, NEW�ֹι�ȣ)
EXEC PRC_AD_PROFESSOR_UPDATE('P20211001', '����ȣ', '1234567');

SELECT*
FROM TBL_PROFESSOR;

--���� VIEW (������, ���ǽ�, �����, �����������, ������������, �����, ������)
SELECT *
FROM VIEW_SUBJECT;

-- ���� ���� ���� ���ν��� PRC_OPENS_DELETE(���񰳼��ڵ�)
EXEC PRC_OPENS_DELETE('20000');

-- �л� VIEW (�л��̸�, ������, �����, ��������, ������������)
SELECT *
FROM VIEW_STUDENT;

-- ������û ������ ����� �����ִ� VIEW
SELECT *
FROM VIEW_REGISTER;


-- ���� �α��� �� ���� ��� ���ν��� (���� ���� ����!) PRC_PROF_SUBJECT_VIEW(�����ڵ�)
EXEC PRC_PROF_SUBJECT_VIEW('P20211002');
--==>> ������ , Oracle , 20/12/02 , 21/01/03 , ����Ŭ�� ���� �����ͺ��̽� ���а� �ǽ�

--���� �Է� PRC_PERCENT_UPDATE(���񰳼��ڵ�, ���,�Ǳ�,�ʱ�)
EXEC PRC_PERCENT_UPDATE('29998', 30,30,40);
EXEC PRC_PERCENT_UPDATE('29999', 20,40,40);
EXEC PRC_PERCENT_UPDATE('29997', 10,50,40);
EXEC PRC_PERCENT_UPDATE('29994', 30,30,40);
EXEC PRC_PERCENT_UPDATE('29995', 20,40,40);
EXEC PRC_PERCENT_UPDATE('29996', 10,50,40);
--==>>
/*
29999	9999	2000	4000	P20211001	20/11/01	20/12/01	20	40	40
29998	9999	2001	4001	P20211002	20/12/02	21/01/03	30	30	40
29997	9999	2002	4003	P20211003	21/01/04	21/02/01	10	50	40
*/

SELECT *
FROM TBL_OPENS;
SELECT *
FROM TBL_STUDENT;

--��������� �����Է� ȭ�� (�л��̸��� �ڵ��ԷµǾ��ְ� ���/�Ǳ�/�ʱ� ������ ������ ��/ �Է°��� �����ڵ�+���񰳼��ڵ�)
-- �̶�, ������ �ߵ�Ż���Ͽ� ��ܿ��� ���ܵ� �л��� �����Է� ȭ�鿡�� ���ܵǾ�� ��.
EXEC PRC_PROFESSOR_SCORE_VIEW('P20211009', '29994');
--==>> �ߵ�Ż������ ������ �л��� ������ ������ �ʴ� ���� �� �� ����.

--���� �Է� PRC_SCORE_UPDATE(������û�ڵ�, ���񰳼��ڵ�, ���, �Ǳ�, �ʱ�)
--����
EXEC PRC_SCORE_UPDATE('39998', '29998', 30, 20, 30);
EXEC PRC_SCORE_UPDATE('39997', '29998', 20, 30, 40);
EXEC PRC_SCORE_UPDATE('39999', '29998', 25, 20, 30);
--����
EXEC PRC_SCORE_UPDATE('39994', '29994', 30, 30, 40);
EXEC PRC_SCORE_UPDATE('39995', '29994', 0, 20, 10);
EXEC PRC_SCORE_UPDATE('39996', '29994', 10, 15, 20);

SELECT *
FROM TBL_SCORE;

--��������� ���� ��� PRC_PROFESSOR_SCOREINFO_VIEW(�����ڵ�)
EXEC PRC_PROFESSOR_SCOREINFO_VIEW('P20211009');
--==>>
/*
����� : UI/UX| ����Ⱓ : 21/02/04| - 21/03/01| ����� : JSP �� ���α׷��� �Թ�+Ȱ��| �л� �̸� : ������| ��� : 30| �ʱ� : 40| �Ǳ� : 30| ���� : 100| ��� : 1| �������� : �ߵ�Ż��
����� : UI/UX| ����Ⱓ : 21/02/04| - 21/03/01| ����� : JSP �� ���α׷��� �Թ�+Ȱ��| �л� �̸� : ������| ��� : 10| �ʱ� : 20| �Ǳ� : 15| ���� : 45| ��� : 2| �������� : �����Ϸ�
����� : UI/UX| ����Ⱓ : 21/02/04| - 21/03/01| ����� : JSP �� ���α׷��� �Թ�+Ȱ��| �л� �̸� : ������| ��� : 0| �ʱ� : 10| �Ǳ� : 20| ���� : 30| ��� : 3| �������� : �����Ϸ�
*/

--�л������ �α��� �� ���� ��� PRC_STUDENT_SUB_VIEW(�л��ڵ�)
EXEC PRC_STUDENT_SUB_VIEW('S20211010');
--==>>
/*
������ : UI/UX�� Ȱ���� �� �ۺ��� ���� | ����� : UI/UX | �������� : 21/02/04 - 21/03/01 �������� : �ߵ�Ż��
������ : UI/UX�� Ȱ���� �� �ۺ��� ���� | ����� : Oracle | �������� : 21/03/02 - 21/04/03 �������� : �ߵ�Ż��
*/

--�л������ ���� ��� PRC_STUDENT_SUBINFO_VIEW(�л��ڵ�, ���񰳼��ڵ�)
EXEC PRC_STUDENT_SUBINFO_VIEW('S20211010', '29994');
--==>> �̸� : ������ | ������ : UI/UX�� Ȱ���� �� �ۺ��� ���� | ����� : UI/UX | �������� : 21/02/04 - 21/05/02 | ����� : JSP �� ���α׷��� �Թ�+Ȱ�� | ��� : 30 �ʱ� : 30 �Ǳ� : 40 ���� : 100 ��� : 1

--���� ������ ���� EXEC PRC_OPENS_UPDATE(���������ڵ�, ���񰳼��ڵ�, �����ڵ�, ���������, ����������, �����ڵ�, �������ڵ�)
EXEC PRC_OPENS_UPDATE('10000', '20000', '2000', TO_DATE('21/05/03'), TO_DATE('21/06/03'), '4000', 'P20211002');
--==>>
--�ٲٱ� �� 20000	    10000	2000	    4000    	P20211001	21/05/03	    21/06/03	
--�ٲ� ��   20000	10000	2000	    4000	    P20211002	21/05/03	    21/06/03	

SELECT *
FROM TBL_OPENS;


