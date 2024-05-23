SELECT USER
FROM DUAL;
--==>> HR

------------------------------시퀀스 생성----------------------------------------

-- 교수코드 SEQUENCE
CREATE SEQUENCE SEQ_PROFESSOR
START WITH 1001 
INCREMENT BY 1
MAXVALUE 9999
NOCACHE;
--==>> Sequence SEQ_PROFESSOR이(가) 생성되었습니다.


-- 학생코드 SEQUENCE
CREATE SEQUENCE SEQ_STUDENT
START WITH 1001
INCREMENT BY 1
MAXVALUE 9999
NOCACHE;
--==>> Sequence SEQ_STUDENT이(가) 생성되었습니다.

-- 과정코드 SEQUENCE
CREATE SEQUENCE SEQ_COURSE
START WITH 1000
INCREMENT BY 1
MAXVALUE 1999
NOCACHE;
--==>> Sequence SEQ_COURSE이(가) 생성되었습니다.

-- 과목코드 SEQUENCE
CREATE SEQUENCE SEQ_SUBJECT
START WITH 2000
INCREMENT BY 1
MAXVALUE 2999
NOCACHE;
--==>> Sequence SEQ_SUBJECT이(가) 생성되었습니다.

-- 강의실코드 SEQUENCE
CREATE SEQUENCE SEQ_ROOM
START WITH 3000
INCREMENT BY 1
MAXVALUE 3999
NOCACHE;
--==>> Sequence SEQ_ROOM이(가) 생성되었습니다.

-- 교재코드 SEQUENCE
CREATE SEQUENCE SEQ_BOOK
START WITH 4000
INCREMENT BY 1
MAXVALUE 4999
NOCACHE;
--==>> Sequence SEQ_BOOK이(가) 생성되었습니다.

-- 과정개설코드 SEQUENCE
CREATE SEQUENCE SEQ_OPENC
START WITH 10000
INCREMENT BY 1
MAXVALUE 19999
NOCACHE;
--==>> Sequence SEQ_OPENC이(가) 생성되었습니다.

-- 과목개설코드 SEQUENCE
CREATE SEQUENCE SEQ_OPENS
START WITH 20000
INCREMENT BY 1
MAXVALUE 29999
NOCACHE;
--==>> Sequence SEQ_OPENS이(가) 생성되었습니다.

-- 수강신청코드 SEQUENCE
CREATE SEQUENCE SEQ_REGISTER
START WITH 30000
INCREMENT BY 1
MAXVALUE 39999
NOCACHE;
--==>> Sequence SEQ_REGISTER이(가) 생성되었습니다.

---------------------------------시퀀스 생성 끝----------------------------------


-------------------------------0. 로그인 프로시저--------------------------------

-- 로그인 프로시저(관리자) PRC_LOGIN_ADMIN(ADMIN_CODE,ADMIN_PW)

CREATE OR REPLACE PROCEDURE PRC_LOGIN_ADMIN
( V_ADMIN_CODE  IN TBL_ADMIN.ADMIN_CODE%TYPE
, V_ADMIN_PW    IN TBL_ADMIN.ADMIN_PW%TYPE
)
IS
    -- 변수선언
    V_ORI_ADMIN_PW  TBL_ADMIN.ADMIN_PW%TYPE;    --입력받은 ADMIN_CODE에 해당하는 유효한 PW.
    
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    SELECT ADMIN_PW INTO V_ORI_ADMIN_PW
    FROM TBL_ADMIN
    WHERE ADMIN_CODE = V_ADMIN_CODE;
    
    
    IF ( V_ORI_ADMIN_PW != V_ADMIN_PW )
        THEN RAISE USER_DEFINE_ERROR;
    ELSE
        DBMS_OUTPUT.PUT_LINE('관리자 페이지로 로그인되었습니다.');
    END IF;
       
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20100, '아이디 또는 패스워드를 잘못 입력하였습니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    --커밋
    COMMIT;
    
END;
--==>> Procedure PRC_LOGIN_ADMIN이(가) 컴파일되었습니다.

-- 로그인 프로시저 (교수) PRC_LOGIN_PROFESSOR(PROF_CODE,PROF_PW)
CREATE OR REPLACE PROCEDURE PRC_LOGIN_PROFESSOR
( V_PROF_CODE   IN TBL_PROFESSOR.PROF_CODE%TYPE
, V_PROF_PW     IN TBL_PROFESSOR.PROF_PW%TYPE
)
IS
    --변수선언
    V_ORI_PROF_PW   TBL_PROFESSOR.PROF_PW%TYPE;    --입력받은 PROF_CODE에 해당하는 유효한 PW.
    
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    SELECT PROF_PW INTO V_ORI_PROF_PW
    FROM TBL_PROFESSOR
    WHERE PROF_CODE = V_PROF_CODE;

    IF ( V_ORI_PROF_PW != V_PROF_PW )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('교수 페이지로 로그인되었습니다.');
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20100, '아이디 또는 패스워드를 잘못 입력하였습니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
    --커밋
    COMMIT;
    
END;
--==>> Procedure PRC_LOGIN_PROFESSOR이(가) 컴파일되었습니다.

-- 로그인 프로시저 (학생) PRC_LOGIN_STUDENT(STD_CODE,STD_PW)
CREATE OR REPLACE PROCEDURE PRC_LOGIN_STUDENT
( V_STD_CODE    IN TBL_STUDENT.STD_CODE%TYPE
, V_STD_PW      IN TBL_STUDENT.STD_PW%TYPE
)
IS
    --변수선언
    V_ORI_STD_PW    TBL_STUDENT.STD_PW%TYPE;    --입력받은 STD_CODE에 해당하는 유효한 PW.
    
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
    SELECT STD_PW INTO V_ORI_STD_PW
    FROM TBL_STUDENT
    WHERE STD_CODE = V_STD_CODE;
    
    IF ( V_ORI_STD_PW != V_STD_PW )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('학생 페이지로 로그인되었습니다.');
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20100, '아이디 또는 패스워드를 잘못 입력하였습니다.');
            ROLLBACK;   
        WHEN OTHERS
            THEN ROLLBACK;
    
    --커밋
    COMMIT;
    
END;
--==>> Procedure PRC_LOGIN_STUDENT이(가) 컴파일되었습니다.

-----------------------------1. 교수 프로시저------------------------------------

-- 교수 INSERT 프로시저 PRC_PROFESSOR_INSERT(PROF_NAME,PROF_SSN)

CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_INSERT
(   
    V_PROF_NAME  IN TBL_PROFESSOR.PROF_NAME%TYPE            --이름
   ,V_PROF_SSN   IN TBL_PROFESSOR.PROF_SSN%TYPE             --주민번호뒷자리   
)
IS
    V_PROF_CODE   TBL_PROFESSOR.PROF_CODE%TYPE;             -- 코드
BEGIN
    -- 교수 코드(시퀀스)
    V_PROF_CODE := 'P' || TO_CHAR(SYSDATE,'YYYY') || TO_CHAR(SEQ_PROFESSOR.NEXTVAL);           
    
    
    -- INSERT 쿼리문
    INSERT INTO TBL_PROFESSOR(PROF_CODE, PROF_NAME, PROF_SSN, PROF_PW)
    VALUES(V_PROF_CODE, V_PROF_NAME, V_PROF_SSN, V_PROF_SSN);
    
    -- 커밋
    COMMIT;
    
END;
--==>> Procedure PRC_PROFESSOR_INSERT이(가) 컴파일되었습니다

-- (관리자 입장)교수 UPDATE 프로시저 PRC_AD_PROFESSOR_UPDATE(코드, NEW이름, NEW주민번호)
CREATE OR REPLACE PROCEDURE PRC_AD_PROFESSOR_UPDATE
(
     V_PROF_CODE    IN TBL_PROFESSOR.PROF_CODE%TYPE 
    ,V_PROF_NAME    IN TBL_PROFESSOR.PROF_NAME%TYPE     -- NEW 이름
    ,V_PROF_SSN     IN TBL_PROFESSOR.PROF_SSN%TYPE      -- NEW 주민번호
)
IS   
    V_PROF_CODE_TEMP    TBL_PROFESSOR.PROF_CODE%TYPE;

BEGIN

    UPDATE TBL_PROFESSOR
    SET PROF_NAME = V_PROF_NAME, PROF_SSN = V_PROF_SSN
    WHERE PROF_CODE = V_PROF_CODE;

    DBMS_OUTPUT.PUT_LINE('변경사항이 성공적으로 반영되었습니다.');
    
    --커밋
    COMMIT;  
    
    EXCEPTION
        WHEN OTHERS
            THEN ROLLBACK;
               
END;


-- (사용자입장)교수 UPDATE 프로시저 PRC_PROFESSOR_UPDATE(코드, 기존PW, 바꿀PW)
CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_UPDATE
(
     V_PROF_CODE        IN TBL_PROFESSOR.PROF_CODE%TYPE 
    ,V_PROF_PW          IN TBL_PROFESSOR.PROF_SSN%TYPE      -- 기존 PW
    ,V_PROF_NEW_PW      IN TBL_PROFESSOR.PROF_PW%TYPE       -- NEW 바꿀 PW
)
IS
    V_ORI_PW     TBL_PROFESSOR.PROF_PW%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;
   
BEGIN
    
    SELECT PROF_PW INTO V_ORI_PW
    FROM TBL_PROFESSOR
    WHERE PROF_CODE = V_PROF_CODE AND (SELECT PROF_PW
                                       FROM TBL_PROFESSOR
                                       WHERE PROF_CODE=V_PROF_CODE)=V_PROF_PW; 
                                                                              
    IF  (V_ORI_PW != V_PROF_PW) 
        THEN RAISE USER_DEFINE_ERROR;
    END IF;  
        
    -- 코드 , 기존 PW 비교 → NEW PW 변경    
    
    UPDATE TBL_PROFESSOR
    SET PROF_PW = V_PROF_NEW_PW 
    WHERE PROF_CODE = V_PROF_CODE AND (SELECT PROF_PW
                                       FROM TBL_PROFESSOR
                                       WHERE PROF_CODE=V_PROF_CODE)=V_PROF_PW;                                           
    
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
             THEN RAISE_APPLICATION_ERROR(-20101, '기존 아이디와 패스워드가 일치하지 않습니다.');
            ROLLBACK;   
        WHEN OTHERS
            THEN ROLLBACK;
    
    --커밋
    COMMIT;                                          
    
                                     
END;
--==>> Procedure PRC_PROFESSOR_UPDATE이(가) 컴파일되었습니다.


-- 교수 DELETE 프로시저 PRC_PROFESSOR_DELETE(PROF_CODE)
CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_DELETE
(   V_PROF_CODE    IN TBL_PROFESSOR.PROF_CODE%TYPE )
IS
BEGIN
    
    DELETE
    FROM TBL_PROFESSOR
    WHERE PROF_CODE = V_PROF_CODE;
        
    -- 커밋
    COMMIT;

           
END;
--==>> Procedure PRC_PROFESSOR_DELETE이(가) 컴파일되었습니다.


-----------------------------2. 학생 프로시저------------------------------------

-- 학생 입력 프로시저 생성 PRC_STUDENT_INSERT(이름, 주민번호뒷자리)
CREATE OR REPLACE PROCEDURE PRC_STUDENT_INSERT
(   V_STD_NAME IN TBL_STUDENT.STD_NAME%TYPE   -- 학생이름
,   V_STD_SSN  IN TBL_STUDENT.STD_SSN%TYPE    -- 주민번호뒷자리
)
IS
    V_STD_CODE TBL_STUDENT.STD_CODE%TYPE;     -- 생성된 코드를 담을 변수
BEGIN
    -- 학생 코드 생성
    V_STD_CODE := 'S' || TO_CHAR(SYSDATE, 'YYYY') || TO_CHAR(SEQ_STUDENT.NEXTVAL);
    
    -- 학생 테이블 INSERT 쿼리문 구성
    INSERT INTO TBL_STUDENT(STD_CODE, STD_NAME, STD_SSN, STD_PW)
    VALUES(V_STD_CODE, V_STD_NAME, V_STD_SSN, V_STD_SSN);
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENT_INSERT이(가) 컴파일되었습니다.

-- 관리자 입장에서 학생 UPDATE 프로시저 PRC_AD_STUDENT_UPDATE(기존ID, 기존 이름, 기존 PW)
CREATE OR REPLACE PROCEDURE PRC_AD_STUDENT_UPDATE
(
     V_STD_CODE    IN TBL_STUDENT.STD_CODE%TYPE 
    ,V_STD_NAME    IN TBL_STUDENT.STD_NAME%TYPE     -- NEW 이름
    ,V_STD_SSN     IN TBL_STUDENT.STD_SSN%TYPE      -- NEW 주민번호
)
IS   
    V_STD_CODE_TEMP    TBL_STUDENT.STD_CODE%TYPE;

BEGIN

    UPDATE TBL_STUDENT
    SET STD_NAME = V_STD_NAME, STD_SSN = V_STD_SSN
    WHERE STD_CODE = V_STD_CODE;

    DBMS_OUTPUT.PUT_LINE('변경사항이 성공적으로 반영되었습니다.');
    
    --커밋
    COMMIT;  
    
    EXCEPTION
        WHEN OTHERS
            THEN ROLLBACK;
               
END;
--==>> Procedure PRC_AD_STUDENT_UPDATE이(가) 컴파일되었습니다.


-- (학생)학생 업데이트 프로시저 생성 PRC_STUDENT_UPDATE(자기ID, 기존PW, 바꿀PW)
CREATE OR REPLACE PROCEDURE PRC_STUDENT_UPDATE
(   V_STD_CODE   IN TBL_STUDENT.STD_CODE%TYPE
,   V_STD_OLD_PW IN TBL_STUDENT.STD_PW%TYPE     -- 기존PW
,   V_STD_NEW_PW IN TBL_STUDENT.STD_PW%TYPE     -- 바꿀PW
)
IS 
    V_ORI_STD_CODE TBL_STUDENT.STD_CODE%TYPE;
    V_ORI_STD_PW   TBL_STUDENT.STD_PW%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT STD_CODE, STD_PW INTO V_ORI_STD_CODE, V_ORI_STD_PW
    FROM TBL_STUDENT
    WHERE STD_CODE = V_STD_CODE AND (SELECT STD_PW
                                     FROM TBL_STUDENT
                                     WHERE STD_CODE = V_STD_CODE) = V_STD_OLD_PW;

    IF (V_ORI_STD_CODE != V_STD_CODE OR V_ORI_STD_PW != V_STD_OLD_PW)
        THEN RAISE USER_DEFINE_ERROR;       
    END IF;   
    
     -- 코드, 주민번호 비교 → NAME, PW 변경
    UPDATE TBL_STUDENT
    SET STD_PW = V_STD_NEW_PW
    WHERE STD_CODE =  V_STD_CODE AND (SELECT STD_PW
                                      FROM TBL_STUDENT
                                      WHERE STD_CODE=V_STD_CODE)=V_STD_OLD_PW;
                                      
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20101, '기존 아이디와 패스워드가 일치하지 않습니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_STUDENT_UPDATE이(가) 컴파일되었습니다.

-- 학생 삭제 프로시저 생성 PRC_STUDENT_DELETE(학생코드, 학생PW)

--PRC_STUDENT_DELETE(학생코드)
CREATE OR REPLACE PROCEDURE PRC_STUDENT_DELETE
(   V_STD_CODE IN TBL_STUDENT.STD_CODE%TYPE ) -- 학생 코드
IS
BEGIN
    -- 학생 테이블 DELETE 쿼리문 구성
    DELETE
    FROM TBL_STUDENT
    WHERE STD_CODE = V_STD_CODE;
    
    DBMS_OUTPUT.PUT_LINE('성공적으로 삭제되었습니다.');
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENT_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------3. 과정 프로시저------------------------------------

-- ① 과정정보 INSERT
-- 과정이름을 넣으면 코드가 자동적으로 부여
-- 실행 예)
-- EXEC PRC_COURSE_INSERT(과정이름)
CREATE OR REPLACE PROCEDURE PRC_COURSE_INSERT
( V_CRS_NAME    IN TBL_COURSE.CRS_NAME%TYPE )
IS
    -- 주요 변수 선언
    V_CRS_CODE TBL_COURSE.CRS_CODE%TYPE;
BEGIN
    -- 변수 초기화
    V_CRS_CODE := TO_CHAR(SEQ_COURSE.NEXTVAL);
    
    -- 연산 및 처리
    INSERT INTO TBL_COURSE(CRS_CODE, CRS_NAME)
    VALUES(V_CRS_CODE, V_CRS_NAME);
    
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_COURSE_INSERT이(가) 컴파일되었습니다.

-- ② 과정정보 UPDATE
-- 실행 예)
-- EXEC PRC_COURSE_UPDATE(과정코드, 수정할과정이름)
CREATE OR REPLACE PROCEDURE PRC_COURSE_UPDATE
( V_CRS_CODE    IN TBL_COURSE.CRS_CODE%TYPE
, V_CRS_NAME    IN TBL_COURSE.CRS_NAME%TYPE
)
IS
BEGIN
    UPDATE TBL_COURSE
    SET CRS_NAME = V_CRS_NAME
    WHERE CRS_CODE = V_CRS_CODE;
    
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_COURSE_UPDATE이(가) 컴파일되었습니다.

-- ③ 과정정보 DELETE
-- 실행 예
-- EXEC PRC_COURSE_DELETE(과정코드)
-- 전제: 개강 전에만 과정 삭제 가능함
-- 과정코드가 사라지면.. 과정개설코드가 사라져야하고..
-- 그 안에 있는 과목개설코드(과목시작일, 종료일이 정해져 있기 때문에)가 사라져야 함.
-- 그리고 수강신청코드도 사라져야 함

CREATE OR REPLACE PROCEDURE PRC_COURSE_DELETE
( V_CRS_CODE    IN TBL_COURSE.CRS_CODE%TYPE )
IS
BEGIN
    -- 개설된 과정이 없다면 삭제 
    DELETE
    FROM TBL_COURSE
    WHERE CRS_CODE = V_CRS_CODE;
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_COURSE_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------4. 과목 프로시저------------------------------------
-- 과목 입력 프로시저 생성 PRC_SUBJECT_INSERT(과목명)

CREATE OR REPLACE PROCEDURE PRC_SUBJECT_INSERT
( V_SUB_NAME  IN TBL_SUBJECT.SUB_NAME%TYPE
)
IS
    --필요 변수 선언
    V_SUB_CODE  TBL_SUBJECT.SUB_CODE%TYPE;
    
BEGIN
    --V_SUB_CODE 변수 초기화
    V_SUB_CODE := TO_CHAR(SEQ_SUBJECT.NEXTVAL);

    --INSERT 쿼리문 작성
    INSERT INTO TBL_SUBJECT(SUB_CODE,SUB_NAME)
    VALUES(V_SUB_CODE, V_SUB_NAME);
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_SUBJECT_INSERT이(가) 컴파일되었습니다.

-- 과목 업데이트 프로시저 생성 PRC_SUBJECT_UPDATE(과목코드, 변경과목명)
CREATE OR REPLACE PROCEDURE PRC_SUBJECT_UPDATE
( V_SUB_CODE  IN TBL_SUBJECT.SUB_CODE%TYPE
, V_SUB_NAME  IN TBL_SUBJECT.SUB_NAME%TYPE
)
IS  
BEGIN
    --UPDATE 쿼리문 작성
    UPDATE TBL_SUBJECT
    SET SUB_NAME = V_SUB_NAME
    WHERE SUB_CODE = V_SUB_CODE;
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_SUBJECT_UPDATE이(가) 컴파일되었습니다.

-- 과목 삭제 프로시저 생성 PRC_SUBJECT_DELETE(과목코드) => 해당 과목 삭제 시 수강신청이 이미 된..과정의 과목일경우 삭제불가..?(상관없음..)
CREATE OR REPLACE PROCEDURE PRC_SUBJECT_DELETE
( V_SUB_CODE  IN TBL_SUBJECT.SUB_CODE%TYPE
)
IS    
BEGIN
    --DELETE 쿼리문 작성
    DELETE
    FROM TBL_SUBJECT
    WHERE SUB_CODE = V_SUB_CODE;
    
    --커밋
    COMMIT;    

END;
--==>> Procedure PRC_SUBJECT_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------5. 과정개설 프로시저--------------------------------
-- 과정개설 INSERT 프로시저 PRC_OPENC_INSERT(과정코드,강의실코드,과정시작일자,과정종료일자)
CREATE OR REPLACE PROCEDURE PRC_OPENC_INSERT
( V_CRS_CODE    IN TBL_COURSE.CRS_CODE%TYPE
, V_ROOM_CODE   IN TBL_ROOM.ROOM_CODE%TYPE
, V_CRS_START   IN TBL_OPENC.CRS_START%TYPE
, V_CRS_END     IN TBL_OPENC.CRS_END%TYPE
)
IS
    V_OPENC_CODE        TBL_OPENC.OPENC_CODE%TYPE;
    --V_CRS_START_TEMP    TBL_OPENC.CRS_START%TYPE;
    V_CRS_END_TEMP      TBL_OPENC.CRS_END%TYPE;
    USER_DEFINE_ERROR1  EXCEPTION;
    USER_DEFINE_ERROR2  EXCEPTION;
    
    
    -- CURSOR의 선언
    CURSOR CUR_ROOM_CHECK
    IS
    SELECT CRS_END
    FROM TBL_OPENC
    WHERE ROOM_CODE = V_ROOM_CODE;
    
BEGIN
    -- CURSOR 열기
     OPEN CUR_ROOM_CHECK;
    
     LOOP
         FETCH CUR_ROOM_CHECK INTO V_CRS_END_TEMP;
         
         EXIT WHEN CUR_ROOM_CHECK%NOTFOUND;
         
         IF (V_CRS_START <= V_CRS_END_TEMP) --이건가..?
         --기존 강좌종료일자보다 내가 등록할 강좌시작일자가 과거라면
            THEN RAISE USER_DEFINE_ERROR2;
         END IF;
         
     END LOOP;
     
     CLOSE CUR_ROOM_CHECK;

    -- 과정시작일자가 SYSDATE보다 미래이게 
     IF (SYSDATE >= V_CRS_START)
        THEN RAISE USER_DEFINE_ERROR1;
     END IF;
    
    -- V_OPENC_CODE 변수 초기화
    V_OPENC_CODE := TO_CHAR(SEQ_OPENC.NEXTVAL);
    
    INSERT INTO TBL_OPENC(OPENC_CODE, CRS_CODE, ROOM_CODE, CRS_START, CRS_END)
    VALUES (V_OPENC_CODE, V_CRS_CODE, V_ROOM_CODE, V_CRS_START, V_CRS_END);
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20002, '과정시작일자가 오늘날짜보다 이전입니다.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20003, '현재 강의 진행중인 과정의 강의실입니다.');
            ROLLBACK;
        
    -- 커밋
    COMMIT;
    
END;
--==>> Procedure PRC_OPENC_INSERT이(가) 컴파일되었습니다.

-- 과정개설 UPDATE 프로시저 PRC_OPENC_UPDATE(과정개설코드, NEW강의실코드, NEW과정시작일자, NEW과정종료일자)
CREATE OR REPLACE PROCEDURE PRC_OPENC_UPDATE
( V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE
, V_ROOM_CODE   IN TBL_ROOM.ROOM_CODE%TYPE
, V_CRS_START     IN TBL_OPENC.CRS_START%TYPE
, V_CRS_END       IN TBL_OPENC.CRS_END%TYPE
)
IS  
    V_CRS_END_TEMP  TBL_OPENC.CRS_END%TYPE;
    
    USER_DEFINE_ERROR  EXCEPTION;
    
    --커서 선언
    CURSOR CUR_ROOM_CHE
    IS
    SELECT CRS_END
    FROM TBL_OPENC
    WHERE ROOM_CODE = V_ROOM_CODE;
    
BEGIN
    -- 커서 열기
    OPEN CUR_ROOM_CHE;
    
    LOOP
        FETCH CUR_ROOM_CHE INTO V_CRS_END_TEMP;
        
        EXIT WHEN CUR_ROOM_CHE%NOTFOUND;
        
        IF (V_CRS_START <= V_CRS_END_TEMP)
            THEN RAISE USER_DEFINE_ERROR;
        END IF;
        
    END LOOP;
    
    -- 커서 닫기
    CLOSE CUR_ROOM_CHE;

    -- UPDATE 쿼리문
    UPDATE TBL_OPENC
    SET ROOM_CODE = V_ROOM_CODE, CRS_START = V_CRS_START, CRS_END = V_CRS_END
    WHERE OPENC_CODE = V_OPENC_CODE;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '현재 강의 진행중인 과정의 강의실입니다.');
            ROLLBACK;
    
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_OPENC_UPDATE이(가) 컴파일되었습니다.

-- 과정개설 DELETE 프로시저 PRC_OPENC_DELETE(과정개설코드)
CREATE OR REPLACE PROCEDURE PRC_OPENC_DELETE
( V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE
)
IS
BEGIN
    
    -- DELETE 쿼리문
    DELETE
    FROM TBL_OPENC
    WHERE OPENC_CODE = V_OPENC_CODE;
    
    --커밋
    COMMIT;
    
END;
--==>> Procedure PRC_OPENC_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------6. 과목개설 프로시저--------------------------------

-- 교수 강의 가능 판별 함수(교수코드, 과목개설코드, 강의시작일, 강의종료일)
CREATE OR REPLACE FUNCTION FN_OPENS_SELECT_PROF
( V_PROF_CODE  IN TBL_PROFESSOR.PROF_CODE%TYPE -- 교수코드
, V_OPENS_CODE IN TBL_OPENS.OPENS_CODE%TYPE    -- 과목개설코드
, V_SUB_START  IN TBL_OPENS.SUB_START%TYPE   -- 강의시작일
, V_SUB_END    IN TBL_OPENS.SUB_END%TYPE     -- 강의종료일
)
RETURN NUMBER
IS
    -- 주요 변수 선언
    V_SUB_START_TEMP    TBL_OPENS.SUB_START%TYPE; -- 교수코드가 같은 과목들의 과목시작일자
    V_SUB_END_TEMP      TBL_OPENS.SUB_END%TYPE;   -- 교수코드가 같은 과목들의 과목종료일자
    V_RESULT            NUMBER;                   -- 함수를 통해 분기된 결과값
    
    -- 커서 작성
    CURSOR CUR_OPENS_SELECT_PROF
    IS
    SELECT SUB_START, SUB_END                     -- ③ 즉, 해당 교수 이름이 들어간 과목의 과목시작일과 종료일을 모두 눌러담는다.        
    FROM TBL_OPENS
    WHERE PROF_CODE = V_PROF_CODE;                 -- ① 교수 코드가 같고
          --AND OPENS_CODE != V_OPENS_CODE;         -- ② 수정할 과목개설코드가 아닌
BEGIN    
    -- 커서 오픈 AND V_SUB_START_TEMP, V_SUB_END_TEMP, V_RESULT 채우기
    OPEN CUR_OPENS_SELECT_PROF;
    
    LOOP
        FETCH CUR_OPENS_SELECT_PROF INTO V_SUB_START_TEMP, V_SUB_END_TEMP;
        
        IF 
        --ⓐ 수정할 과목기간이 해당 교수가 맡고 있는 다른 과목들의 과목 시작일 및 종료일 사이에 있으면 안 됨.  
        V_SUB_START BETWEEN V_SUB_START_TEMP AND V_SUB_END_TEMP
        -- 수정할 과목의 시작일이 기존과목들 시작일자 와 기존과목들 종료일자 사이에 있거나
        OR V_SUB_END BETWEEN V_SUB_END_TEMP AND V_SUB_END_TEMP
        -- 수정할 과목의 종료일이 기존과목들 시작일자 와 기존과목들 종료일자 사이에 있다면
            THEN V_RESULT := 0; -- UPDATE X
        
        ELSE V_RESULT := 1;     -- UPDATE O
        END IF;
                
        EXIT WHEN CUR_OPENS_SELECT_PROF%NOTFOUND;
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_OPENS_SELECT_PROF;

    -- 최종결과값 반환
    RETURN V_RESULT;
END;

-- 기간조건 판별 함수
-- 과정개설코드와 과목개설코드와 과목시작일자와 과목종료일자를 매개변수로 받는다
CREATE OR REPLACE FUNCTION FN_OPENS_SELECT_STEND
(
  V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE -- 과정개설코드
, V_OPENS_CODE  IN TBL_OPENS.OPENS_CODE%TYPE -- 과목개설코드
, V_SUB_START   IN TBL_OPENS.SUB_START%TYPE  -- 과목시작일자
, V_SUB_END     IN TBL_OPENS.SUB_END%TYPE    -- 과목종료일자
)
RETURN NUMBER
IS
    -- 주요 변수 선언
    V_SUB_START_TEMP    TBL_OPENS.SUB_START%TYPE; -- 과정개설코드가 같은(같은 과정에 속하는) 과목들의 과목시작일자
    V_SUB_END_TEMP      TBL_OPENS.SUB_END%TYPE;   -- 과정개설코드가 같은(같은 과정에 속하는) 과목들의 과목종료일자
    V_RESULT            NUMBER;                   -- 함수를 통해 분기된 결과값
    
    V_CRS_START         TBL_OPENC.CRS_START%TYPE;   -- 과정시작일자
    V_CRS_END           TBL_OPENC.CRS_END%TYPE;     -- 과정종료일자
    
    -- 커서 작성
    CURSOR CUR_OPENS_SELECT_STEND
    IS
    SELECT SUB_START, SUB_END                             -- ③해당 과목들의 과목시작일자와, 과목종료일자를 받는다.
    FROM TBL_OPENS
    WHERE OPENS_CODE = (SELECT OPENS_CODE                 -- ② 과목개설코드들을 찾아서
                        FROM TBL_OPENC
                        WHERE OPENC_CODE = V_OPENC_CODE)  -- ① 과정개설코드가 같은
          AND OPENS_CODE != V_OPENS_CODE;                 --    그리고, 입력된 과목개설코드와는 같지 않은 (다른 과목들)
BEGIN
    -- V_CRS_START, V_CRS_END 채우기
    SELECT CRS_START, CRS_END INTO V_CRS_START, V_CRS_END   -- 과정시작일과 과정종료일을 따온다.
    FROM TBL_OPENC
    WHERE OPENC_CODE = V_OPENC_CODE;    -- 입력받은 과정개설코드의 
    
    -- 커서 오픈 AND V_SUB_START_TEMP, V_SUB_END_TEMP, V_RESULT 채우기
    OPEN CUR_OPENS_SELECT_STEND;
    
    LOOP
        FETCH CUR_OPENS_SELECT_STEND INTO V_SUB_START_TEMP, V_SUB_END_TEMP;
        
        --ⓐ 과목시작일자는 SYSDATE 보다 과거이면 안 됨
        IF V_SUB_START < SYSDATE--과목등록일자
        --(과목시작일자가 SYSDATE 전이거나)
        
        --ⓑ 과목 시작일과 과목 종료일은 과정시작일과 과정종료일 사이에 있어야 한다.
        OR V_SUB_START NOT BETWEEN V_CRS_START AND V_CRS_END
        -- OR 과목 종료일이 과정시작일 전이다. 과목 시작일은 과목 종료일보다 전이므로, 자연스럽게 과정시작일 보다 과거가 된다.
        OR V_SUB_END NOT BETWEEN V_CRS_START AND V_CRS_END
        -- OR 과목 종료일이 과정종료일 밖이다. 과목 시작일은 과목 종료일보다 전이므로, 자연스럽게 과정종료일 보다 미래가 된다. 
        
        --ⓒ 과정 내 다른 과목 기간과 겹치지 않아야 함.  
        OR V_SUB_START BETWEEN V_SUB_START_TEMP AND V_SUB_END_TEMP
        -- 등록할 과목의 시작일이 기존과목들 시작일자 와 기존과목들 종료일자 사이에 있거나
        OR V_SUB_END BETWEEN V_SUB_END_TEMP AND V_SUB_END_TEMP
        -- 등록할 과목의 종료일이 기존과목들 시작일자 와 기존과목들 종료일자 사이에 있다면
            THEN V_RESULT := 0; -- UPDATE X
        
        ELSE V_RESULT := 1;     -- UPDATE O
        END IF;
                
        EXIT WHEN CUR_OPENS_SELECT_STEND%NOTFOUND;
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_OPENS_SELECT_STEND;
    
    -- 최종결과값 반환
    RETURN V_RESULT;
END;
--==>> Function FN_OPENS_SELECT이(가) 컴파일되었습니다.


-- ① 과목개설 INSERT
-- 과목시작일자가 SYSDATE < 과목시작일자,  조건 → TRIGGER
-- 과목 정보 입력은 과정명, 과목명, 과목 기간(시작 연월일, 끝 연월일), 교재 명, 교수자 명 정보
-- 실행 예)
-- EXEC PRC_COURSE_UPDATE(과정개설코드, 과목코드, 과목시작일, 과목종료일, 교재코드, 교수자코드)
CREATE OR REPLACE PROCEDURE PRC_OPENS_INSERT
( V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE   -- 과정개설코드   -- 기존 등록
, V_SUB_CODE    IN TBL_SUBJECT.SUB_NAME%TYPE    -- 과목코드      -- 기존 등록
, V_SUB_START   IN TBL_OPENS.SUB_START%TYPE     -- 과목시작일
, V_SUB_END     IN TBL_OPENS.SUB_END%TYPE       -- 과목종료일
, V_BOOK_CODE   IN TBL_BOOK.BOOK_CODE%TYPE      -- 교재코드      -- 기존 등록
, V_PROF_CODE   IN TBL_PROFESSOR.PROF_CODE%TYPE -- 교수자코드    -- 얘는 코드가 맞고 
)
IS
    -- 변수    
    V_OPENS_CODE    TBL_OPENS.OPENS_CODE%TYPE;  -- 과목개설코드
    
    -- 함수 결과값 담을 변수
    V_RESULT_STEND  NUMBER;
    V_RESULT_PROF   NUMBER;
    
    USER_DEFINE_ERROR_STEND  EXCEPTION;
    USER_DEFINE_ERROR_PROF   EXCEPTION;
BEGIN
    -- 과목개설코드
    V_OPENS_CODE := SEQ_OPENS.NEXTVAL;
    -- 기간판별함수를 통해 값 따오기
    SELECT FN_OPENS_SELECT_STEND(V_OPENC_CODE, V_OPENS_CODE, V_SUB_START, V_SUB_END) INTO V_RESULT_STEND
    FROM DUAL;
    -- 교수강의가능판별함수를 통해 값 따오기
    SELECT FN_OPENS_SELECT_PROF(V_PROF_CODE, V_OPENS_CODE, V_SUB_START, V_SUB_END) INTO V_RESULT_PROF
    FROM DUAL;
    
    -- UPDATE 여부 결정
    IF V_RESULT_STEND = 0
        THEN RAISE USER_DEFINE_ERROR_STEND;
    END IF;
    
    IF V_RESULT_PROF = 0
        THEN RAISE USER_DEFINE_ERROR_PROF;
    END IF;
    
    -- INSERT 문 작성
    INSERT INTO TBL_OPENS(OPENC_CODE, OPENS_CODE, SUB_CODE, BOOK_CODE, PROF_CODE
                        , SUB_START, SUB_END)
    VALUES(V_OPENC_CODE, V_OPENS_CODE, V_SUB_CODE, V_BOOK_CODE, V_PROF_CODE
         , V_SUB_START, V_SUB_END); -- 출결, 실기, 필기 배점은 NULL 값 들어가도록 생략
         
    -- 커밋
    COMMIT;
         
    -- 예외 캐치
    EXCEPTION 
        WHEN USER_DEFINE_ERROR_STEND
            THEN RAISE_APPLICATION_ERROR(-20001, '과목 기간 설정오류입니다. 다시 확인해주세요.');
                ROLLBACK;
        WHEN USER_DEFINE_ERROR_PROF
            THEN RAISE_APPLICATION_ERROR(-20006, '해당 교수는 입력한 과목 기간에 이미 배정된 강의가 있습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_OPENS_INSERT이(가) 컴파일되었습니다.

-- ② 과목개설 UPDATE
-- 과목시작일자가 SYSDATE < 과목시작일자 조건 → TRIGGER
-- 실행 예)
-- EXEC PRC_OPENS_UPDATE(과정개설코드, 과목개설코드, 과목코드, 과목시작일, 과목종료일, 교재코드, 교수자코드)
-- 과정개설코드 는 변경 불가.
-- *과정개설코드, 과목시작일, 과목종료일은 변경 가능하도록 해야 하는가?
-- 과정개설코드는 복잡해지니까 변경 불가한 것으로 하고, 과목시작일, 종료일, 교재코드, 교수자코드만 변경 가능하도록.
-- 이 경우, ⓐ과목 시작일은 SYSDATE 보다 미래여야 하고, ⓑ과목 시작일과 과목 종료일은 과정시작일과 과정종료일 안이어야 하며,
-- ⓒ다른 과목 기간과 겹치지 않아야 함. 
CREATE OR REPLACE PROCEDURE PRC_OPENS_UPDATE
( V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE
, V_OPENS_CODE  IN TBL_OPENS.OPENS_CODE%TYPE
, V_SUB_CODE    IN TBL_SUBJECT.SUB_CODE%TYPE
, V_SUB_START   IN TBL_OPENS.SUB_START%TYPE
, V_SUB_END     IN TBL_OPENS.SUB_END%TYPE
, V_BOOK_CODE   IN TBL_BOOK.BOOK_CODE%TYPE
, V_PROF_CODE   IN TBL_PROFESSOR.PROF_CODE%TYPE
)
IS
    -- 함수 결과값 담을 변수
    V_RESULT_STEND  NUMBER;
    V_RESULT_PROF   NUMBER;
    
    USER_DEFINE_ERROR_STEND  EXCEPTION;
    USER_DEFINE_ERROR_PROF   EXCEPTION;
BEGIN
    -- 함수를 통해 값 따오기
    -- 기간판별함수를 통해 값 따오기
    SELECT FN_OPENS_SELECT_STEND(V_OPENC_CODE, V_OPENS_CODE, V_SUB_START, V_SUB_END) INTO V_RESULT_STEND
    FROM DUAL;
    -- 교수강의가능판별함수를 통해 값 따오기
    SELECT FN_OPENS_SELECT_PROF(V_PROF_CODE, V_OPENS_CODE, V_SUB_START, V_SUB_END) INTO V_RESULT_PROF
    FROM DUAL;
    
    -- UPDATE 여부 결정
    IF V_RESULT_STEND = 0
        THEN RAISE USER_DEFINE_ERROR_STEND;
    END IF;
    
    IF V_RESULT_PROF = 0
        THEN RAISE USER_DEFINE_ERROR_PROF;
    END IF;
    
    -- UPDATE 문 작성
    UPDATE TBL_OPENS
    SET SUB_CODE = V_SUB_CODE, SUB_START = V_SUB_START, SUB_END = V_SUB_END
      , BOOK_CODE = V_BOOK_CODE, PROF_CODE = V_PROF_CODE 
    WHERE OPENS_CODE = V_OPENS_CODE;
    
    --커밋
    COMMIT;
    
    -- 예외 캐치
    EXCEPTION 
        WHEN USER_DEFINE_ERROR_STEND
            THEN RAISE_APPLICATION_ERROR(-20001, '과목 기간 설정오류입니다. 다시 확인해주세요.');
                ROLLBACK;
        WHEN USER_DEFINE_ERROR_PROF
            THEN RAISE_APPLICATION_ERROR(-20006, '해당 교수는 입력한 과목 기간에 이미 배정된 강의가 있습니다.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_OPENS_UPDATE이(가) 컴파일되었습니다.

-- ③ 과목개설 DELETE
-- 실행 예)
-- EXEC PRC_OPENS_DELETE(과목개설코드)
-- 과목 삭제는 과정에 영향을 주지 않는다. 교수, 교재, 강의실 ETC.. 수강신청과 학생은 과정에 연결돼 있는 거니까 신경 안 써도 되고.
-- 과목은.. 그냥 ^과목시작일 전에만 삭제 가능^하다고 전제 깔면 아무데도 영향 안 끼치고 얘만 삭제 가능
CREATE OR REPLACE PROCEDURE PRC_OPENS_DELETE
( V_OPENS_CODE  IN TBL_OPENS.OPENS_CODE%TYPE )
IS
BEGIN
    -- DELETE 문 작성
    DELETE
    FROM TBL_OPENS
    WHERE OPENS_CODE = V_OPENS_CODE;
    
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_OPENS_DELETE이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------

-----------------------------7. 강의실 프로시저----------------------------------

-- 강의실 입력 프로시저 생성 PRC_ROOM_INSERT(강의실이름, 수용인원)
CREATE OR REPLACE PROCEDURE PRC_ROOM_INSERT
(   V_ROOM_NAME IN TBL_ROOM.ROOM_NAME%TYPE   -- 강의실 이름
,   V_ROOM_NUM  IN TBL_ROOM.ROOM_NUM%TYPE    -- 강의실 수용인원
)
IS
    V_ROOM_CODE TBL_ROOM.ROOM_CODE%TYPE;   -- 생성된 코드를 담을 변수
BEGIN
    -- 강의실 코드 생성
    V_ROOM_CODE := TO_CHAR(SEQ_ROOM.NEXTVAL);
    
    -- 강의실 테이블 INSERT 쿼리문 구성
    INSERT INTO TBL_ROOM(ROOM_CODE, ROOM_NAME, ROOM_NUM)
    VALUES(V_ROOM_CODE, V_ROOM_NAME, V_ROOM_NUM);
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_ROOM_INSERT이(가) 컴파일되었습니다.


-- 강의실 업데이트 프로시저 생성 PRC_ROOM_UPDATE(강의실코드, NEW강의실이름, NEW수용인원)
CREATE OR REPLACE PROCEDURE PRC_ROOM_UPDATE
(   V_ROOM_CODE IN TBL_ROOM.ROOM_CODE%TYPE      -- 강의실 코드
,   V_ROOM_NAME IN TBL_ROOM.ROOM_NAME%TYPE   -- 강의실 이름
,   V_ROOM_NUM  IN TBL_ROOM.ROOM_NUM%TYPE    -- 강의실 수용인원
)
IS
BEGIN
    -- 강의실 테이블 UPDATE 쿼리문 구성
    UPDATE TBL_ROOM
    SET ROOM_NAME = V_ROOM_NAME
      , ROOM_NUM = V_ROOM_NUM
    WHERE ROOM_CODE = V_ROOM_CODE;
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_ROOM_UPDATE이(가) 컴파일되었습니다.

-- 강의실 삭제 프로시저 생성 PRC_ROOM_DELETE(강의실코드)
CREATE OR REPLACE PROCEDURE PRC_ROOM_DELETE
(   V_ROOM_CODE IN TBL_ROOM.ROOM_CODE%TYPE      -- 강의실코드
)
IS
BEGIN
    -- 강의실 테이블 DELETE 쿼리문 구성
    DELETE
    FROM TBL_ROOM
    WHERE ROOM_CODE = V_ROOM_CODE;
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENT_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------8. 교재 프로시저------------------------------------

-- 교재 입력 PRC_BOOK_INSERT(교재이름)

CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT
(
   V_BOOK_NAME   IN TBL_BOOK.BOOK_NAME%TYPE 
)
IS   
    V_BOOK_CODE TBL_BOOK.BOOK_CODE%TYPE ;
BEGIN
    -- 교재코드 
    V_BOOK_CODE := TO_CHAR(SEQ_BOOK.NEXTVAL);
    
    -- INSERT 쿼리문 
    INSERT INTO TBL_BOOK(BOOK_CODE, BOOK_NAME)
    VALUES(V_BOOK_CODE, V_BOOK_NAME);
    
    --커밋
    COMMIT;

      --예외 처리
      --EXCEPTION
        --WHEN OTHERS 
            --THEN ROLLBACK;    
END;
--==>> Procedure PRC_BOOK_INSERT이(가) 컴파일되었습니다.


-- 교재 수정 PRC_BOOK_UPDATE(교재코드,NEW교재이름)

CREATE OR REPLACE PROCEDURE PRC_BOOK_UPDATE
(
    V_BOOK_CODE     IN TBL_BOOK.BOOK_CODE%TYPE    
,   V_BOOK_NAME     IN TBL_BOOK.BOOK_NAME%TYPE
)
IS
BEGIN

    --UPDATE 쿼리문
    UPDATE TBL_BOOK
    SET BOOK_NAME = V_BOOK_NAME
    WHERE BOOK_CODE = V_BOOK_CODE;
    
    --커밋
    COMMIT;
    
      --예외 처리
      --EXCEPTION
        --WHEN OTHERS 
            --THEN ROLLBACK;    
END;
--==>> Procedure PRC_BOOK_UPDATE이(가) 컴파일되었습니다.

-- 교재 삭제 PRC_BOOK_DELETE(교재코드)

CREATE OR REPLACE PROCEDURE PRC_BOOK_DELETE
(
    V_BOOK_CODE     IN TBL_BOOK.BOOK_CODE%TYPE 
)
IS
BEGIN

    DELETE
    FROM TBL_BOOK
    WHERE BOOK_CODE = V_BOOK_CODE;

      --커밋
      COMMIT;

      --예외 처리
      --EXCEPTION
        --WHEN OTHERS 
            --THEN ROLLBACK;
END;
--==>> Procedure PRC_BOOK_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------9. 중도탈락 프로시저--------------------------------

-- 중도탈락 입력 프로시저 생성 PRC_FAIL_INSERT(수강신청코드,중도탈락일자,중도탈락사유)
-- 중도 탈락일자가 과정 시작~ 종료 일자 사이에 들어와야 함.
CREATE OR REPLACE PROCEDURE PRC_FAIL_INSERT
( V_REGISTER_CODE  IN TBL_FAIL.REGISTER_CODE%TYPE
, V_FAIL_DATE      IN TBL_FAIL.FAIL_DATE%TYPE
, V_FAIL_REASON    IN TBL_FAIL.FAIL_REASON%TYPE
)
IS    
BEGIN
    --INSERT 쿼리문 작성
    INSERT INTO TBL_FAIL(REGISTER_CODE, FAIL_DATE, FAIL_REASON)
    VALUES(V_REGISTER_CODE, V_FAIL_DATE, V_FAIL_REASON);
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_FAIL_INSERT이(가) 컴파일되었습니다.

-- 중도탈락 수정 프로시저 생성 PRC_FAIL_UPDATE(기존수강신청코드, NEW수강신청코드, NEW중도탈락일자, NEW중도탈락사유)
CREATE OR REPLACE PROCEDURE PRC_FAIL_UPDATE
( V_OLD_REGISTER_CODE  IN TBL_FAIL.REGISTER_CODE%TYPE
, V_REGISTER_CODE  IN TBL_FAIL.REGISTER_CODE%TYPE
, V_FAIL_DATE      IN TBL_FAIL.FAIL_DATE%TYPE
, V_FAIL_REASON    IN TBL_FAIL.FAIL_REASON%TYPE
)
IS    
BEGIN
    --UPDATE 쿼리문 작성
    UPDATE TBL_FAIL
    SET REGISTER_CODE = V_REGISTER_CODE
      , FAIL_DATE     = V_FAIL_DATE
      , FAIL_REASON   = V_FAIL_REASON
    WHERE REGISTER_CODE = V_OLD_REGISTER_CODE;
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_FAIL_UPDATE이(가) 컴파일되었습니다

-- 중도탈락 삭제 프로시저 생성 PRC_FAIL_DELETE(수강신청코드)
CREATE OR REPLACE PROCEDURE PRC_FAIL_DELETE
( V_REGISTER_CODE  IN TBL_FAIL.REGISTER_CODE%TYPE
)
IS    
BEGIN
    --DELETE 쿼리문 작성
    DELETE
    FROM TBL_FAIL
    WHERE REGISTER_CODE = V_REGISTER_CODE;
    
    --커밋
    COMMIT;

END;
--==>> Procedure PRC_FAIL_DELETE이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------

-----------------------------10. 성적 프로시저-----------------------------------

-- 성적 업데이트 프로시저 생성 PRC_SCORE_UPDATE(수강신청코드, 과목개설코드, 출결, 실기, 필기)

CREATE OR REPLACE PROCEDURE PRC_SCORE_UPDATE
(   V_REGISTER_CODE IN TBL_REGISTER.REGISTER_CODE%TYPE   -- 수강신청코드
,   V_OPENS_CODE    IN TBL_OPENS.OPENS_CODE%TYPE         -- 과목개설코드
,   V_C_SCORE       IN TBL_SCORE.C_SCORE%TYPE
,   V_S_SCORE       IN TBL_SCORE.S_SCORE%TYPE
,   V_P_SCORE       IN TBL_SCORE.P_SCORE%TYPE
)
IS
    V_C_PERCENT TBL_OPENS.C_PERCENT%TYPE;
    V_S_PERCENT TBL_OPENS.S_PERCENT%TYPE;
    V_P_PERCENT TBL_OPENS.P_PERCENT%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    -- 비교할 배점 담아오기(과목개설 코드가 동일한 배점 가져오기)
    SELECT C_PERCENT, S_PERCENT, P_PERCENT INTO V_C_PERCENT, V_S_PERCENT, V_P_PERCENT
    FROM TBL_OPENS
    WHERE OPENS_CODE = V_OPENS_CODE;
    
    -- 입력한 점수가 0보다 작거나 설정되어있는 배점보다 클 경우 예외 발생
    IF ((V_C_SCORE < 0) OR (V_C_SCORE > V_C_PERCENT) OR (V_S_SCORE < 0) OR (V_S_SCORE > V_S_PERCENT) OR (V_P_SCORE < 0) OR (V_P_SCORE > V_P_PERCENT))
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 성적 테이블 UPDATE 쿼리문 구성
    UPDATE TBL_SCORE
    SET C_SCORE = V_C_SCORE
      , S_SCORE = V_S_SCORE
      , P_SCORE = V_P_SCORE
    WHERE REGISTER_CODE = V_REGISTER_CODE
      AND OPENS_CODE = V_OPENS_CODE; 
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20200, '점수를 다시 입력해주세요.(0미만, 배점 초과 불가)');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SCORE_UPDATE이(가) 컴파일되었습니다.

-- 성적 삭제(다시 NULL 값으로) 프로시저 생성 PRC_SCORE_DELETE(수강신청코드, 과목개설코드)
CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
(   V_REGISTER_CODE IN TBL_REGISTER.REGISTER_CODE%TYPE   -- 수강신청코드
,   V_OPENS_CODE    IN TBL_OPENS.OPENS_CODE%TYPE         -- 과목개설코드
)
IS
BEGIN
    -- 성적 테이블 DELETE 쿼리문 구성
    UPDATE TBL_SCORE
    SET C_SCORE = ''
      , S_SCORE = ''
      , P_SCORE = ''
    WHERE REGISTER_CODE = V_REGISTER_CODE
      AND OPENS_CODE = V_OPENS_CODE; 
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_SCORE_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------11. 배점 프로시저-----------------------------------

-- 배점 UPDATE 프로시저 PRC_PERCENT_UPDATE(과목개설코드)

CREATE OR REPLACE PROCEDURE PRC_PERCENT_UPDATE
(
    V_OPENS_CODE    IN TBL_OPENS.OPENS_CODE%TYPE
,   V_C_PERCENT     IN TBL_OPENS.C_PERCENT%TYPE         -- 출결
,   V_S_PERCENT     IN TBL_OPENS.S_PERCENT%TYPE         -- 실기
,   V_P_PERCENT     IN TBL_OPENS.P_PERCENT%TYPE         -- 필기
)
IS
BEGIN        
    -- 배점 테이블 UPDATE 쿼리문 구성
    UPDATE TBL_OPENS
    SET C_PERCENT = V_C_PERCENT
       ,S_PERCENT = V_S_PERCENT
       ,P_PERCENT = V_P_PERCENT
    WHERE OPENS_CODE =V_OPENS_CODE;
    
    --커밋
    COMMIT;
        
      --예외 처리
      --EXCEPTION
        --WHEN OTHERS 
            --THEN ROLLBACK;
END;
--==>> Procedure PRC_PERCENT_UPDATE이(가) 컴파일되었습니다.

-- 배점 DELETE PRC_PERCENT_DELETE(과목개설코드)

CREATE OR REPLACE PROCEDURE PRC_PERCENT_DELETE
( 
   V_OPENS_CODE    IN TBL_OPENS.OPENS_CODE%TYPE
)
IS
BEGIN
    
    UPDATE TBL_OPENS
    SET C_PERCENT = ''
       ,S_PERCENT = ''
       ,P_PERCENT = ''
    WHERE OPENS_CODE =V_OPENS_CODE;      
    
    --커밋
    COMMIT;

      --예외 처리
      --EXCEPTION
        --WHEN OTHERS 
            --THEN ROLLBACK;
END;
--==>> Procedure PRC_PERCENT_DELETE이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------

-----------------------------12. 수강신청 프로시저-------------------------------
-- 수강신청 입력 프로시저 생성 PRC_REGISTER_INSERT(과정개설코드, 학생코드) 
-- 수강신청일자는 DEFAULT 값으로..
-- 수강신청일자(SYSDATE) < 과정시작일자 => 수강신청 VIEW 자체에서 이미 해당 조건으로만 보일 수 있게 설정하면, 
-- 프로시저에서 거르지않아도 된다고 생각하여, 따로 예외처리 하지 않았음.
-- 동일한 학생이 같은 과정을 신청할 수 없음. 기간겹치는 과정을 신청할 수 없음.
CREATE OR REPLACE PROCEDURE PRC_REGISTER_INSERT
( V_OPENC_CODE  IN TBL_OPENC.OPENC_CODE%TYPE
, V_STD_CODE    IN TBL_STUDENT.STD_CODE%TYPE
)
IS
    --필요변수선언
    V_REGISTER_CODE TBL_REGISTER.REGISTER_CODE%TYPE;
    V_OPENC_CODE_TEMP   TBL_OPENC.OPENC_CODE%TYPE;
    V_CRS_START_TEMP    TBL_OPENC.CRS_START%TYPE;
    V_CRS_END_TEMP      TBL_OPENC.CRS_END%TYPE;
    
    USER_DEFINE_ERROR1 EXCEPTION;       -- 이미 수강신청한 과정입니다.
    USER_DEFINE_ERROR2 EXCEPTION;       -- 수강중인 과정의 기간과 중복되어 신청할 수 없습니다.
    
    CURSOR CUR_REGISTER_CHECK1  -- 1번에러 잡는 CURSOR 커서명
    IS
    SELECT OPENC_CODE
    FROM TBL_REGISTER
    WHERE STD_CODE = V_STD_CODE;
    
    CURSOR CUR_REGISTER_CHECK2  -- 2번에러 잡는 CURSOR 커서명
    IS
    SELECT OC.CRS_END
    FROM TBL_REGISTER RE, TBL_OPENC OC
    WHERE RE.OPENC_CODE = OC.OPENC_CODE(+)
      AND STD_CODE = V_STD_CODE;
BEGIN
    --변수 초기화
    V_REGISTER_CODE := TO_CHAR(SEQ_REGISTER.NEXTVAL);
    
    SELECT CRS_START INTO V_CRS_START_TEMP
    FROM TBL_OPENC
    WHERE OPENC_CODE = V_OPENC_CODE;
    
    --1번에러 잡는 커서 오픈
    OPEN CUR_REGISTER_CHECK1;
    LOOP
        -- 한 행 한 행 끄집어내어 가져오는 행위 → 『FETCH』
        FETCH CUR_REGISTER_CHECK1 INTO V_OPENC_CODE_TEMP;
        
        EXIT WHEN CUR_REGISTER_CHECK1%NOTFOUND; -- 더이상 꺼낼 데이터가 없을 때 반복종료.
        
        -- IF문 작동~~!!
        IF (V_OPENC_CODE_TEMP = V_OPENC_CODE)
            THEN RAISE USER_DEFINE_ERROR1;
        END IF;
        
    END LOOP;
    
    --1번에러 잡는 커서 클로즈
    CLOSE CUR_REGISTER_CHECK1;
    
    --2번에러 잡는 커서 오픈
    OPEN CUR_REGISTER_CHECK2;
    LOOP
        -- 한 행 한 행 끄집어내어 가져오는 행위 → 『FETCH』
        FETCH CUR_REGISTER_CHECK2 INTO V_CRS_END_TEMP;
        
        EXIT WHEN CUR_REGISTER_CHECK2%NOTFOUND; -- 더이상 꺼낼 데이터가 없을 때 반복종료.
        
        -- IF문 작동~~!! --선택한 과정의 시작날짜가 기존과정의 종료날짜보다 작거나 같다면 예외처리.
        IF (V_CRS_START_TEMP <= V_CRS_END_TEMP)
            THEN RAISE USER_DEFINE_ERROR2;
        END IF;
        
    END LOOP;
    
    --2번에러 잡는 커서 클로즈
    CLOSE CUR_REGISTER_CHECK2;
    
    
    --INSERT 쿼리문 작성
    INSERT INTO TBL_REGISTER(REGISTER_CODE, OPENC_CODE, STD_CODE)
    VALUES(V_REGISTER_CODE, V_OPENC_CODE, V_STD_CODE);
    
    --커밋
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20300, '이미 수강신청한 과정입니다.');
            ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20005, '수강중인 과정의 기간과 중복되어 신청할 수 없습니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==>>  Procedure PRC_REGISTER_INSERT이(가) 컴파일되었습니다.

-- 수강신청 삭제 프로시저 생성 PRC_REGISTER_DELETE(수강신청코드)--**중도탈락기록이 있는 수강신청코드의 경우.. 수강신청삭제 불가.
-- 수강신청한 과정의 시작일자가 SYSDATE 보다 앞서면(작으면) DELETE 불가.
CREATE OR REPLACE PROCEDURE PRC_REGISTER_DELETE
( V_REGISTER_CODE IN TBL_REGISTER.REGISTER_CODE%TYPE
)
IS
    V_OPENC_CODE    TBL_OPENC.OPENC_CODE%TYPE;
    V_CRS_START   TBL_OPENC.CRS_START%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    --삭제할 수강신청코드의 과정개설코드 추출
    SELECT OPENC_CODE INTO V_OPENC_CODE
    FROM TBL_REGISTER
    WHERE REGISTER_CODE = V_REGISTER_CODE;
    
    --과정개설코드의 과정시작일자 추출
    SELECT CRS_START INTO V_CRS_START
    FROM TBL_OPENC
    WHERE OPENC_CODE = V_OPENC_CODE;
    
    -- 수강신청한 과정의 시작일자가 SYSDATE 보다 작으면..
    IF (V_CRS_START  < SYSDATE)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    --DELETE 쿼리문 작성
    DELETE 
    FROM TBL_REGISTER
    WHERE REGISTER_CODE = V_REGISTER_CODE;
    
    --커밋
    COMMIT;
    
    --예외처리..
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004,'이미 수강이 시작된 과정이므로 삭제 불가합니다.');
                 ROLLBACK;
        WHEN OTHERS 
            THEN ROLLBACK;  

END;
--==>> Procedure PRC_REGISTER_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------

-----------------------------13. 관리자 프로시저---------------------------------

-- 관리자정보 업데이트 프로시저 PRC_ADMIN_UPDATE(기존CODE, NEW CODE, 기존 PW, NEW PW)

CREATE OR REPLACE PROCEDURE PRC_ADMIN_UPDATE
(   
    V_OLD_CODE   IN TBL_ADMIN.ADMIN_CODE%TYPE            
   ,V_NEW_CODE   IN TBL_ADMIN.ADMIN_CODE%TYPE  
   ,V_OLD_PW   IN TBL_ADMIN.ADMIN_PW%TYPE 
   ,V_NEW_PW   IN TBL_ADMIN.ADMIN_PW%TYPE
)
IS
    V_ADMIN_CODE  TBL_ADMIN.ADMIN_CODE%TYPE;
    V_ADMIN_PW  TBL_ADMIN.ADMIN_PW%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    --변수 초기화
    SELECT ADMIN_CODE,ADMIN_PW INTO V_ADMIN_CODE, V_ADMIN_PW
    FROM TBL_ADMIN;
    
    IF (V_OLD_CODE != V_ADMIN_CODE
        OR V_OLD_PW != V_ADMIN_PW)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- UPDATE 쿼리문
    UPDATE TBL_ADMIN
    SET ADMIN_CODE = V_NEW_CODE, ADMIN_PW = V_NEW_PW 
    WHERE ADMIN_CODE = V_OLD_CODE AND (SELECT ADMIN_PW
                                       FROM TBL_ADMIN
                                       WHERE ADMIN_CODE=V_OLD_CODE)=V_OLD_PW;
    -- 커밋
    COMMIT;
    
    --예외 처리
      EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20101, '기존 아이디와 패스워드가 일치하지 않습니다..');
        WHEN OTHERS 
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_ADMIN_UPDATE이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------

------------------------------VIEW 생성-----------------------------------------

-- ① 교수자 계정 관리 기능 구현한 뷰 
-- 교수명, 배정된과목명, 기간, 교재명, 강의실, 강의진행여부 조회 
CREATE OR REPLACE VIEW VIEW_PROFESSORS
AS
SELECT TP.PROF_NAME "교수명", TS.SUB_NAME "과목명", TOS.SUB_START "과목시작일", TOS.SUB_END "과목종료일"
     , TB.BOOK_NAME"교재명", TR.ROOM_NAME"강의실"
     , CASE WHEN SYSDATE BETWEEN TOS.SUB_START AND TOS.SUB_END THEN '강의진행중' 
             WHEN SYSDATE < TOS.SUB_START THEN '강의예정'
             ELSE '강의완료' END "강의진행여부"
FROM TBL_PROFESSOR TP, TBL_SUBJECT TS, TBL_OPENS TOS, TBL_BOOK TB, TBL_ROOM TR, TBL_OPENC TOC, TBL_COURSE TC
WHERE TOS.PROF_CODE = TP.PROF_CODE(+)
  AND TOS.SUB_CODE = TS.SUB_CODE(+)
  AND TOS.BOOK_CODE = TB.BOOK_CODE(+)
  AND TOC.CRS_CODE = TC.CRS_CODE(+)
  AND TOS.OPENC_CODE = TOC.OPENC_CODE(+)
  AND TOC.ROOM_CODE = TR.ROOM_CODE(+);
--==>> View VIEW_PROFESSORS이(가) 생성되었습니다.
  
-- ② 관리자 과정 출력 뷰 생성
-- 과정명, 강의실, 과목명, 과목 기간(시간일, 종료일), 교재명, 교수명
CREATE OR REPLACE VIEW VIEW_COURSE
AS
SELECT TC.CRS_NAME "과정명", TR.ROOM_NAME "강의실", TS.SUB_NAME "과목명", TOS.SUB_START "과목시작일자"
     , TOS.SUB_END "과목종료일자", TB.BOOK_NAME "교재명", TP.PROF_NAME "교수명"
FROM TBL_COURSE TC, TBL_ROOM TR, TBL_SUBJECT TS, TBL_OPENS TOS, TBL_BOOK TB, TBL_PROFESSOR TP, TBL_OPENC TOC
WHERE TOS.OPENC_CODE = TOC.OPENC_CODE(+)
  AND TOC.ROOM_CODE = TR.ROOM_CODE(+)
  AND TOS.SUB_CODE = TS.SUB_CODE(+)
  AND TOC.CRS_CODE = TC.CRS_CODE(+)
  AND TOS.BOOK_CODE = TB.BOOK_CODE(+)
  AND TOS.PROF_CODE = TP.PROF_CODE(+);
--==>> iew VIEW_COURSE이(가) 생성되었습니다.
  
--과목 VIEW (과정명, 강의실, 과목명, 과목시작일자, 과목종료일자, 교재명, 교수명)
CREATE OR REPLACE VIEW VIEW_SUBJECT
AS
SELECT C.CRS_NAME "과정명", R.ROOM_NAME"강의실", S.SUB_NAME"과목명"
     , OS.SUB_START"과목시작일자", OS.SUB_END"과목종료일자", B.BOOK_NAME"교재명", P.PROF_NAME"교수명"
FROM TBL_OPENS OS, TBL_OPENC OC, TBL_ROOM R, TBL_COURSE C, TBL_SUBJECT S, TBL_BOOK B, TBL_PROFESSOR P
WHERE OS.OPENC_CODE = OC.OPENC_CODE(+)
  AND OC.ROOM_CODE = R.ROOM_CODE(+)
  AND OC.CRS_CODE = C.CRS_CODE(+)
  AND OS.SUB_CODE = S.SUB_CODE(+)
  AND OS.BOOK_CODE = B.BOOK_CODE(+)
  AND OS.PROF_CODE = P.PROF_CODE(+);
--==>> View VIEW_SUBJECT이(가) 생성되었습니다.

--학생 VIEW (학생이름, 과정명, 과목명, 과목총점, 과정수강상태)

CREATE OR REPLACE VIEW VIEW_STUDENT
AS
SELECT ST.STD_NAME"학생이름", CO.CRS_NAME"과정명", SU.SUB_NAME"과목명"
     , (SC.C_SCORE+SC.P_SCORE+SC.S_SCORE)"과목총점", NVL2(FA.REGISTER_CODE,'중도탈락','해당없음')"과정수강상태"
FROM TBL_REGISTER RE, TBL_STUDENT ST, TBL_OPENC OC, TBL_COURSE CO
   , TBL_OPENS OS, TBL_SUBJECT SU, TBL_SCORE SC, TBL_FAIL FA
WHERE RE.STD_CODE = ST.STD_CODE(+)      --수강신청과 학생정보  연결하여 학생이름 추출
  AND RE.OPENC_CODE = OC.OPENC_CODE(+)  --수강신청과 과정개설과 연결
  AND OC.CRS_CODE = CO.CRS_CODE(+)      -- 과정개설과 과정정보 연결하여 과정명 추출
  AND OS.OPENC_CODE = OC.OPENC_CODE     -- 과정개설과 과목개설과 연결
  AND OS.SUB_CODE = SU.SUB_CODE(+)          -- 과목명 추출
  AND SC.OPENS_CODE = OS.OPENS_CODE(+)
  AND SC.REGISTER_CODE = RE.REGISTER_CODE(+)
  AND FA.REGISTER_CODE(+) = RE.REGISTER_CODE;
--==>> View VIEW_STUDENT이(가) 생성되었습니다.

--수강신청 VIEW (과정명, 과정시작일자, 과정종료일자)
CREATE OR REPLACE VIEW VIEW_REGISTER
AS
SELECT OC.OPENC_CODE"과정개설코드", C.CRS_NAME"과정명", OC.CRS_START"과정시작일자", OC.CRS_END"과정종료일자"
FROM TBL_OPENC OC, TBL_COURSE C
WHERE OC.CRS_CODE = C.CRS_CODE(+)
  AND CRS_START > SYSDATE;
--==>> View VIEW_REGISTER이(가) 생성되었습니다.

-- 로그인한 학생이 선택한 과목 출력 뷰 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_STUDENT_SUBINFO_VIEW
(   V_STD_CODE IN TBL_STUDENT.STD_CODE%TYPE   -- 학생코드=로그인ID
,   V_OPENS_CODE IN TBL_OPENS.OPENS_CODE%TYPE   -- 과목개설코드=학생이 선택한 과목
)
IS
    V_STD_NAME  TBL_STUDENT.STD_NAME%TYPE;     -- 학생명
    V_CRS_NAME  TBL_COURSE.CRS_NAME%TYPE;      -- 과정명
    V_SUB_NAME  TBL_SUBJECT.SUB_NAME%TYPE;     -- 과목명
    V_CRS_START TBL_OPENC.CRS_START%TYPE;      -- 교육시작일자
    V_CRS_END   TBL_OPENC.CRS_END%TYPE;        -- 교육종료일자
    -->> 이미 끝난 과목을 클릭했으니까 수강 기간 출력
    V_BOOK_NAME TBL_BOOK.BOOK_NAME%TYPE;       -- 교재명
    V_C_SCORE   TBL_SCORE.C_SCORE%TYPE;        -- 출결
    V_P_SCORE   TBL_SCORE.P_SCORE%TYPE;        -- 필기
    V_S_SCORE   TBL_SCORE.S_SCORE%TYPE;        -- 실기
    V_TOTAL     NUMBER(3);                     -- 총점
    V_RANK      NUMBER(3);                     -- 등수
    
    CURSOR CUR_STUDENT_SUBINFO_VIEW
    IS
    SELECT T.학생명 "학생명", T.과정명 "과정명", T.과목명 "과목명", T.교육시작일자 "교육시작일자"
     , T.교육종료일자 "교육종료일자", T.교재명 "교재명", T.출결 "출결", T.실기 "실기", T."필기"
     , T.총점, DENSE_RANK() OVER(PARTITION BY T.과목개설코드 ORDER BY T.총점 DESC) "등수"
    FROM       
    (     
    SELECT TS.STD_CODE "학생코드", TS.STD_NAME "학생명", TC.CRS_NAME "과정명", TSJ.SUB_CODE "과목코드", TSJ.SUB_NAME "과목명", TOC.CRS_START "교육시작일자"
         , TOC.CRS_END "교육종료일자", TB.BOOK_NAME "교재명", TSC.C_SCORE "출결", TSC.S_SCORE "실기", TSC.P_SCORE "필기"
         , (TSC.C_SCORE + TSC.S_SCORE + TSC.P_SCORE) "총점", TSC.OPENS_CODE "과목개설코드"
    FROM TBL_STUDENT TS LEFT JOIN TBL_REGISTER TR
    ON TS.STD_CODE = TR.STD_CODE
       LEFT JOIN TBL_OPENC TOC
         ON TR.OPENC_CODE = TOC.OPENC_CODE
            LEFT JOIN TBL_COURSE TC
            ON TOC.CRS_CODE = TC.CRS_CODE
               LEFT JOIN TBL_SCORE TSC
               ON TR.REGISTER_CODE = TSC.REGISTER_CODE
                  LEFT JOIN TBL_OPENS TOS
                  ON TSC.OPENS_CODE = TOS.OPENS_CODE
                     LEFT JOIN TBL_BOOK TB
                     ON TOS.BOOK_CODE = TB.BOOK_CODE
                        LEFT JOIN TBL_SUBJECT TSJ
                        ON TOS.SUB_CODE = TSJ.SUB_CODE
    )T
    WHERE T.학생코드 = V_STD_CODE
      AND T.과목개설코드 = V_OPENS_CODE;
BEGIN
    OPEN CUR_STUDENT_SUBINFO_VIEW;
    
    LOOP
    FETCH CUR_STUDENT_SUBINFO_VIEW INTO V_STD_NAME, V_CRS_NAME, V_SUB_NAME, V_CRS_START, V_CRS_END, V_BOOK_NAME, V_C_SCORE, V_P_SCORE, V_S_SCORE, V_TOTAL, V_RANK;
    EXIT WHEN CUR_STUDENT_SUBINFO_VIEW%NOTFOUND;
    
    -- 출력
    DBMS_OUTPUT.PUT_LINE('이름 : ' || V_STD_NAME || ' | 과정명 : ' || V_CRS_NAME || ' | 과목명 : ' || V_SUB_NAME || ' | 교육일자 : ' 
                         || V_CRS_START || ' - ' || V_CRS_END || ' | 교재명 : ' || V_BOOK_NAME || ' | 출결 : ' || V_C_SCORE || ' 필기 : ' 
                         || V_P_SCORE || ' 실기 : ' || V_S_SCORE || ' 총점 : ' || V_TOTAL || ' 등수 : ' || V_RANK);
    END LOOP;
    
    CLOSE CUR_STUDENT_SUBINFO_VIEW;
END;

-- 로그인한 학생이 자신이 수강 끝낸 과목을 확인할 수 있는 뷰 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_STUDENT_SUB_VIEW
(   V_STD_CODE IN TBL_STUDENT.STD_CODE%TYPE   -- 학생코드=로그인ID
)
IS

    V_CRS_NAME   TBL_COURSE.CRS_NAME%TYPE;      -- 과정명
    V_SUB_NAME   TBL_SUBJECT.SUB_NAME%TYPE;     -- 과목명
    V_SUB_START  TBL_OPENS.SUB_START%TYPE;      -- 과목시작일자
    V_SUB_END    TBL_OPENS.SUB_END%TYPE;        -- 과목종료일자
    V_SUB_STATUS VARCHAR2(50);                   -- 수강상태
    
    
    CURSOR CUR_STUDENT_SUB_VIEW
    IS
    SELECT T.과정명 "과정명", T.과목명 "과목명", T.과목시작일자 "과목시작일자", T.과목종료일자 "과목종료일자"
     , DECODE(T.중도탈락명단확인, NULL, '수강완료', '중도탈락') "수강상태"
    FROM
    (
     SELECT TS.STD_CODE "학생코드", TC.CRS_NAME "과정명", TSJ.SUB_NAME "과목명", TOS.SUB_START "과목시작일자", TOS.SUB_END "과목종료일자", TF.REGISTER_CODE "중도탈락명단확인"
     FROM TBL_STUDENT TS LEFT JOIN TBL_REGISTER TR
     ON TS.STD_CODE = TR.STD_CODE
           LEFT JOIN TBL_OPENC TOC
             ON TR.OPENC_CODE = TOC.OPENC_CODE
                LEFT JOIN TBL_COURSE TC
                ON TOC.CRS_CODE = TC.CRS_CODE
                      LEFT JOIN TBL_OPENS TOS
                      ON TOC.OPENC_CODE = TOS.OPENC_CODE
                            LEFT JOIN TBL_SUBJECT TSJ
                            ON TOS.SUB_CODE = TSJ.SUB_CODE
                               LEFT JOIN TBL_FAIL TF
                               ON TR.REGISTER_CODE = TF.REGISTER_CODE
    )T
    WHERE T.학생코드 = V_STD_CODE
      AND T.과목종료일자 < SYSDATE;
BEGIN
    OPEN CUR_STUDENT_SUB_VIEW;
    
    LOOP
    FETCH CUR_STUDENT_SUB_VIEW INTO V_CRS_NAME, V_SUB_NAME, V_SUB_START, V_SUB_END, V_SUB_STATUS;
    EXIT WHEN CUR_STUDENT_SUB_VIEW%NOTFOUND;
    
    -- 출력
    DBMS_OUTPUT.PUT_LINE('과정명 : ' || V_CRS_NAME || ' | 과목명 : ' || V_SUB_NAME || ' | 과목일자 : ' || V_SUB_START || ' - ' || V_SUB_END || ' 수강상태 : ' || V_SUB_STATUS);
    END LOOP;
    
    CLOSE CUR_STUDENT_SUB_VIEW;
END;

-- 교수의 성적 전체 출력 뷰 프로시저 생성

CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_SCOREINFO_VIEW
( V_PROF_CODE IN TBL_PROFESSOR.PROF_CODE%TYPE ) -- 교수코드
IS
    V_OPENS_CODE TBL_OPENS.OPENS_CODE%TYPE;
    V_SUB_NAME  TBL_SUBJECT.SUB_NAME%TYPE;      -- 과정명
    V_SUB_START TBL_OPENS.SUB_START%TYPE;       -- 과목시작일
    V_SUB_END   TBL_OPENS.SUB_END%TYPE;         -- 과목종료일
    V_BOOK_NAME TBL_BOOK.BOOK_NAME%TYPE;        -- 교재이름
    V_STD_NAME  TBL_STUDENT.STD_NAME%TYPE;      -- 학생이름
    V_C_SCORE   TBL_SCORE.C_SCORE%TYPE;         -- 출결
    V_S_SCORE   TBL_SCORE.S_SCORE%TYPE;         -- 실기
    V_P_SCORE   TBL_SCORE.P_SCORE%TYPE;         -- 필기
    V_TOTAL     NUMBER;                         -- 총점
    V_RANK      NUMBER;                         -- 등수
    V_STATUS    VARCHAR2(50);                   -- 수강상태
    
    CURSOR CUR_PROFESSOR_SCOREINFO_VIEW
    IS
    SELECT T.과목개설코드, T.과목명, T.과목시작일자, T.과목종료일자, T.교재명, T.학생이름
         , T.출결, T.실기, T.필기, T.출결 +  T.실기 + T.필기 "총점"
         , RANK() OVER(PARTITION BY T.과목개설코드 ORDER BY (T.출결 + T.실기 + T.필기) DESC)
         , DECODE(T.중도탈락명단확인, NULL, '수강완료', '중도탈락') "수강상태" 
    FROM 
    (
        SELECT O.OPENS_CODE "과목개설코드", SUB.SUB_NAME "과목명", O.SUB_START "과목시작일자", O.SUB_END "과목종료일자"
             , B.BOOK_NAME "교재명" 
             , ST.STD_NAME "학생이름", NVL(SC.C_SCORE, 0) "출결", NVL(SC.S_SCORE, 0) "실기", NVL(SC.P_SCORE, 0) "필기"
             , F.REGISTER_CODE "중도탈락명단확인"
        FROM TBL_OPENS O LEFT JOIN TBL_SUBJECT SUB
        ON O.SUB_CODE = SUB.SUB_CODE
            LEFT JOIN TBL_PROFESSOR P
            ON O.PROF_CODE = P.PROF_CODE
                LEFT JOIN TBL_BOOK B
                ON O.BOOK_CODE = B.BOOK_CODE
                    LEFT JOIN TBL_SCORE SC
                    ON O.OPENS_CODE = SC.OPENS_CODE
                        LEFT JOIN TBL_REGISTER R
                        ON SC.REGISTER_CODE = R.REGISTER_CODE
                            LEFT JOIN TBL_FAIL F
                                ON R.REGISTER_CODE = F.REGISTER_CODE
                                    LEFT JOIN TBL_STUDENT ST
                                    ON R.STD_CODE = ST.STD_CODE                                
        WHERE O.PROF_CODE = V_PROF_CODE AND O.SUB_END <= SYSDATE 
    ) T;   
BEGIN
    -- 커서 오픈
    OPEN CUR_PROFESSOR_SCOREINFO_VIEW;
    
    LOOP
        FETCH CUR_PROFESSOR_SCOREINFO_VIEW INTO V_OPENS_CODE, V_SUB_NAME, V_SUB_START, V_SUB_END, V_BOOK_NAME, V_STD_NAME
            , V_C_SCORE, V_S_SCORE, V_P_SCORE, V_TOTAL, V_RANK, V_STATUS;

        EXIT WHEN CUR_PROFESSOR_SCOREINFO_VIEW%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('과목명 : ' || V_SUB_NAME || '|' ||  ' 과목기간 : ' || V_SUB_START || '|' || ' - ' || V_SUB_END
                         || '|' || ' 교재명 : ' || V_BOOK_NAME || '|' || ' 학생 이름 : ' || V_STD_NAME
                         || '|' || ' 출결 : ' || V_C_SCORE || '|' || ' 필기 : ' || V_P_SCORE || '|' || ' 실기 : ' || V_S_SCORE
                         || '|' || ' 총점 : ' || V_TOTAL || '|' || ' 등수 : ' || V_RANK || '|' || ' 수강상태 : ' || V_STATUS);        
    END LOOP;
END;


--==>> Procedure PRC_PROFESSOR_SCOREINFO_VIEW이(가) 컴파일되었습니다.

-- 교수의 로그인 이후 자신이강의한 과목출력 뷰 프로시저 생성
CREATE OR REPLACE PROCEDURE PRC_PROF_SUBJECT_VIEW
(
    V_PROF_CODE      IN TBL_PROFESSOR.PROF_CODE%TYPE
)
IS
    V_PROF_NAME       TBL_PROFESSOR.PROF_NAME%TYPE;    --이름
    V_SUB_NAME        TBL_SUBJECT.SUB_NAME%TYPE;      --과목
    V_SUB_START       TBL_OPENS.SUB_START%TYPE;       --시작일
    V_SUB_END         TBL_OPENS.SUB_END%TYPE;         --종료일
    V_BOOK_NAME       TBL_BOOK.BOOK_NAME%TYPE;        --교재명


    CURSOR CUR_PRO_VIEW_SELECT
    IS
    SELECT T.교수이름, T.과목명, T.시작일, T.종료일, T.교재명 
    FROM(
    SELECT PR.PROF_CODE"교수코드", PR.PROF_NAME "교수이름", SU.SUB_NAME "과목명", OS.SUB_START"시작일", OS.SUB_END"종료일", BO.BOOK_NAME"교재명"
    FROM TBL_PROFESSOR PR LEFT JOIN TBL_OPENS OS
    ON PR.PROF_CODE = OS.PROF_CODE
        LEFT JOIN TBL_BOOK BO
        ON OS.BOOK_CODE=BO.BOOK_CODE
            LEFT JOIN TBL_SUBJECT SU
            ON OS.SUB_CODE=SU.SUB_CODE
                LEFT JOIN TBL_OPENC OC
                ON OS.OPENC_CODE= OC.OPENC_CODE)T   
    WHERE T.교수코드 = V_PROF_CODE
        AND T.종료일 < SYSDATE;
 
 BEGIN
 
    OPEN CUR_PRO_VIEW_SELECT;
 
    LOOP
    FETCH CUR_PRO_VIEW_SELECT INTO V_PROF_NAME, V_SUB_NAME, V_SUB_START, V_SUB_END, V_BOOK_NAME;
    EXIT WHEN CUR_PRO_VIEW_SELECT%NOTFOUND;
        -- 출력
        DBMS_OUTPUT.PUT_LINE(V_PROF_NAME || ' , ' || V_SUB_NAME || ' , ' || V_SUB_START || ' , ' || V_SUB_END || ' , ' ||  V_BOOK_NAME );                                                             
    END LOOP;
    
    CLOSE CUR_PRO_VIEW_SELECT;
END;
--==>> Procedure PRC_PROF_SUBJECT_VIEW이(가) 컴파일되었습니다.

--교수 성적 입력 전 뷰프로시저
CREATE OR REPLACE PROCEDURE PRC_PROFESSOR_SCORE_VIEW
(   V_PROF_CODE  IN TBL_PROFESSOR.PROF_CODE%TYPE
,   V_OPENS_CODE IN TBL_SCORE.OPENS_CODE%TYPE
)
IS
    V_SUB_NAME  TBL_SUBJECT.SUB_NAME%TYPE;  --과목명
    V_SUB_START TBL_OPENS.SUB_START%TYPE;   --시작일
    V_SUB_END   TBL_OPENS.SUB_END%TYPE;     --종료일
    V_STD_NAME  TBL_STUDENT.STD_NAME%TYPE;  -- 학생이름
    V_C_SCORE   TBL_SCORE.C_SCORE%TYPE;     -- 출결
    V_S_SCORE   TBL_SCORE.S_SCORE%TYPE;     -- 실기
    V_P_SCORE   TBL_SCORE.P_SCORE%TYPE;     -- 필기
    V_SUB_STATUS VARCHAR2(50);              -- 수강상태
    
    CURSOR CUR_PROF_SCORE_VIEW
    IS
    SELECT T.과목명, T.과목시작일, T.과목종료일, T.학생이름, T.출결, T.실기, T.필기
     , T.과정수강상태
    FROM
    (
    SELECT TOS.OPENS_CODE "과목개설코드", TOS.PROF_CODE "교수코드", TSJ.SUB_NAME "과목명", TOS.SUB_START "과목시작일", TOS.SUB_END "과목종료일"
         , TSU.STD_NAME "학생이름", TS.C_SCORE "출결", TS.S_SCORE "실기", TS.P_SCORE "필기", TF.REGISTER_CODE "수강신청코드", DECODE(TF.REGISTER_CODE, NULL, '수강완료', '중도탈락') "과정수강상태", TF.FAIL_DATE "중도탈락날짜"
    FROM TBL_OPENS TOS LEFT JOIN TBL_SUBJECT TSJ
    ON TOS.SUB_CODE = TSJ.SUB_CODE
       LEFT JOIN TBL_SCORE TS
       ON TOS.OPENS_CODE = TS.OPENS_CODE
          LEFT JOIN TBL_REGISTER TR
          ON TS.REGISTER_CODE = TR.REGISTER_CODE
             LEFT JOIN TBL_STUDENT TSU
             ON TR.STD_CODE = TSU.STD_CODE
                LEFT JOIN TBL_FAIL TF
                ON TR.REGISTER_CODE = TF.REGISTER_CODE
    )T
    WHERE T.교수코드 = V_PROF_CODE AND T.과목개설코드 = V_OPENS_CODE
      AND T.과목종료일 < SYSDATE 
      AND ((T.중도탈락날짜 NOT BETWEEN T.과목시작일 AND T.과목종료일) OR (T.수강신청코드 IS NULL));
      
BEGIN
    OPEN CUR_PROF_SCORE_VIEW;

    LOOP
    FETCH CUR_PROF_SCORE_VIEW INTO V_SUB_NAME, V_SUB_START, V_SUB_END, V_STD_NAME, V_C_SCORE, V_S_SCORE, V_P_SCORE, V_SUB_STATUS;
    EXIT WHEN CUR_PROF_SCORE_VIEW%NOTFOUND;
    
    
    
    -- 출력
    DBMS_OUTPUT.PUT_LINE('과목명 : ' || V_SUB_NAME || ' | 과목기간 : ' 
                         || V_SUB_START || ' - ' || V_SUB_END || ' | 학생명 : ' || V_STD_NAME || ' | 출결 : ' || V_C_SCORE || ' | 실기 : ' 
                         || V_S_SCORE || ' | 필기 : ' || V_P_SCORE || ' | 수강상태 : ' || V_SUB_STATUS);
    END LOOP;
    
    CLOSE CUR_PROF_SCORE_VIEW;
END;
--==>> Procedure PRC_PROF_SCORE_VIEW이(가) 컴파일되었습니다.

-----------------------------트리거 생성-----------------------------------------

--수강신청 INSERT(수강신청코드, 과정개설코드, 학생코드, 수강신청일자) 발생하면 해당 수강신청 코드와 해당하는 과목개설코드가 성적 테이블에 업데이트되어야 함 
CREATE OR REPLACE TRIGGER TRG_INSERT_SCORE
        AFTER
        INSERT ON TBL_REGISTER
        FOR EACH ROW
DECLARE
    
    V_OPENS_CODE    TBL_OPENS.OPENS_CODE%TYPE;          --과목코드 담아둘변수

    --커서에 집어넣을내용
    CURSOR CUR_INSERT_SCORE
    IS
    SELECT OPENS_CODE
    FROM TBL_OPENS
    WHERE OPENC_CODE =:NEW.OPENC_CODE;

BEGIN 
    --커서오픈
    OPEN CUR_INSERT_SCORE;
    
    -- 커서 오픈 시 쏟아져 나오는 데이터들 처리(잡아내기)
    LOOP
        -- 한 행 한 행 끄집어내어 가져오는 행위 → 『FETCH』
        FETCH CUR_INSERT_SCORE INTO V_OPENS_CODE;
        
        EXIT WHEN CUR_INSERT_SCORE%NOTFOUND; -- 더이상 꺼낼 데이터가 없을 때 반복종료.
        
        -- 행삽입
        INSERT INTO TBL_SCORE(REGISTER_CODE, OPENS_CODE)
        VALUES(:NEW.REGISTER_CODE, V_OPENS_CODE);          -- 현재 INSERT 된 TBL_REGISTER의 REGISTER CODE, 수강신청한 과정의 과목

    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_INSERT_SCORE;

END;
--==>> Trigger TRG_INSERT_SCORE이(가) 컴파일되었습니다.

--수강신청 DELETE 시 성적에 들어있는 정보 삭제 트리거
CREATE OR REPLACE TRIGGER TRG_DELETE_SCORE
        BEFORE
        DELETE ON TBL_REGISTER
        FOR EACH ROW
DECLARE
BEGIN
    IF (DELETING)
        THEN DELETE
             FROM TBL_SCORE
             WHERE REGISTER_CODE = :OLD.REGISTER_CODE;
    END IF;

END;
--==>> Trigger TRG_DELETE_SCORE이(가) 컴파일되었습니다.
--------------------------------------------------------------------------------




