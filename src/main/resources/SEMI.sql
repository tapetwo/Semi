DROP TABLE ATTACH;
DROP TABLE UPLOAD_BOARD;
DROP TABLE COMMENTS;     -- 댓글
DROP TABLE LOVES;       -- 좋아요
DROP TABLE GALLERY_BOARD;
DROP TABLE FREE_BOARD;
DROP TABLE ACCESS_LOG;
DROP TABLE USERS;
DROP TABLE RETIRE_USERS;
DROP TABLE SLEEP_USERS;

-- 회원 테이블
CREATE TABLE USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    PW VARCHAR2(64 BYTE) NOT NULL,  -- 암호화된 비번 최대 64바이트.
    NAME VARCHAR2(50 BYTE) NOT NULL,
    GENDER VARCHAR2(2 BYTE) NOT NULL,  -- M, F, NO
    EMAIL VARCHAR2(50 BYTE) NOT NULL UNIQUE,  -- 이메일 인증 때문에 UNIQUE
    MOBILE VARCHAR2(11 BYTE) NOT NULL,  -- 휴대전화번호(하이픈 제외 최대 11자리)
    BIRTHYEAR VARCHAR2(4 BYTE) NOT NULL,  -- 출생년도(YYYY)
    BIRTHDAY VARCHAR2(4 BYTE) NOT NULL,  -- 생일(MMDD)
    POSTCODE VARCHAR2(5 BYTE),           -- 우편번호
    ROAD_ADDRESS VARCHAR2(100 BYTE),     -- 도로명주소
    JIBUN_ADDRESS VARCHAR2(100 BYTE),    -- 지번주소
    DETAIL_ADDRESS VARCHAR2(100 BYTE),   -- 상세주소
    EXTRA_ADDRESS VARCHAR2(100 BYTE),    -- 참고항목
    AGREE_CODE NUMBER NOT NULL,          -- 동의여부(0:필수, 1:필수+위치, 2:필수+프로모션, 3:필수+위치+프로모션)
    SNS_TYPE VARCHAR2(10 BYTE),          -- 간편가입종류(사이트가입:null, 네아로:naver)
    JOIN_DATE DATE NOT NULL,             -- 가입일
    PW_MODIFY_DATE DATE,                 -- 비번 수정일
    INFO_MODIFY_DATE DATE,               -- 회원정보 수정일
    SESSION_ID VARCHAR2(32 BYTE),        -- 세션 아이디
    SESSION_LIMIT_DATE DATE,             -- 세션 만료일
    POINT NUMBER                         -- 포인트
);

-- 회원접속기록 (최근 접속 기록 1개만 유지)
CREATE TABLE ACCESS_LOG(
    ACCESS_LOG_NO   NUMBER NOT NULL,
    ID              VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    LAST_LOGIN_DATE DATE NOT NULL          -- 마지막 로그인일
);

-- USERS 기본키
ALTER TABLE USERS
    ADD CONSTRAINT USERS_PK
        PRIMARY KEY(USER_NO);
-- ACCESS_LOG 기본키
ALTER TABLE ACCESS_LOG
    ADD CONSTRAINT ACCESS_LOG_PK
        PRIMARY KEY(ACCESS_LOG_NO);
-- ACCESS_LOG 외래키
ALTER TABLE ACCESS_LOG
    ADD CONSTRAINT ACCESS_LOG_USERS_FK
        FOREIGN KEY(ID) REFERENCES USERS(ID)
            ON DELETE CASCADE;
-- 시퀀스
DROP SEQUENCE USERS_SEQ;
DROP SEQUENCE ACCESS_LOG_SEQ;
CREATE SEQUENCE USERS_SEQ NOCACHE;
CREATE SEQUENCE ACCESS_LOG_SEQ NOCACHE;

-- 탈퇴 테이블(※ 삭제된 아이디로 재가입하거나 탈퇴한 아이디를 복구하는 것은 불가능)
CREATE TABLE RETIRE_USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    JOIN_DATE DATE,                         -- 가입일
    RETIRE_DATE DATE                        -- 탈퇴일
);

-- 휴면 테이블
CREATE TABLE SLEEP_USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    PW VARCHAR2(64 BYTE) NOT NULL,               -- 암호화된 비번 최대 64바이트.
    NAME VARCHAR2(50 BYTE) NOT NULL,             -- 이름
    GENDER VARCHAR2(2 BYTE) NOT NULL,            -- M, F, NO
    EMAIL VARCHAR2(50 BYTE) NOT NULL UNIQUE,     -- 이메일 인증 때문에 UNIQUE
    MOBILE VARCHAR2(11 BYTE) NOT NULL,           -- 휴대전화번호(하이픈 제외 최대 11자리)
    BIRTHYEAR VARCHAR2(4 BYTE) NOT NULL,         -- 출생년도(YYYY)
    BIRTHDAY VARCHAR2(4 BYTE) NOT NULL,          -- 생일(MMDD)
    POSTCODE VARCHAR2(5 BYTE),                   -- 우편번호
    ROAD_ADDRESS VARCHAR2(100 BYTE),             -- 도로명주소
    JIBUN_ADDRESS VARCHAR2(100 BYTE),            -- 지번주소
    DETAIL_ADDRESS VARCHAR2(100 BYTE),           -- 상세주소
    EXTRA_ADDRESS VARCHAR2(100 BYTE),            -- 참고항목
    AGREE_CODE NUMBER NOT NULL,                  -- 동의여부(0:필수, 1:필수+위치, 2:필수+프로모션, 3:필수+위치+프로모션)
    SNS_TYPE VARCHAR2(10 BYTE),                  -- 간편가입종류(사이트가입:null, 네아로:naver)
    JOIN_DATE DATE,                              -- 가입일
    LAST_LOGIN_DATE DATE,                        -- 마지막 로그인일
    SLEEP_DATE DATE,                             -- 휴면처리일
    POINT NUMBER                                 -- 포인트
);

-- 아이디/비번(id01/1111, id02/2222, id03/3333, id04/4444, id05/5555)
INSERT INTO USERS VALUES(USERS_SEQ.NEXTVAL, 'admin', '0FFE1ABD1A08215353C233D6E009613E95EEC4253832A761AF28FF37AC5A150C', 'NAME1', 'M', 'id01@naver.com', '01011111111', '1999', '0101', '11111', 'ROAD1', 'JIBUN1', 'DETAIL1', 'EXTRA1', 0, NULL, TO_DATE('20201010', 'YYYYMMDD'), NULL, NULL, NULL, NULL, 0);
COMMIT;

DROP SEQUENCE FREE_BOARD_SEQ;
CREATE SEQUENCE FREE_BOARD_SEQ NOCACHE;

CREATE TABLE FREE_BOARD(
  FREE_BOARD_NO     NUMBER NOT NULL,                -- PK
  ID                VARCHAR2(30 BYTE),              -- FK
  FREE_TITLE        VARCHAR2(1000 BYTE) NOT NULL,   -- 제목
  FREE_CONTENT      VARCHAR2(4000 BYTE) NOT NULL,   -- 본문
  IP                VARCHAR2(30 BYTE),
  CREATE_DATE       DATE   NOT NULL,                -- 작성일
  MODIFY_DATE       DATE,                           -- 수정일
  STATE             NUMBER(1),                      /* 정상 : 1, 삭제 : 0 */
  DEPTH             NUMBER(2),                      -- 댓글들여쓰기
  GROUP_NO          NUMBER,                         -- 그룹번호
  GROUP_ORDER       NUMBER,                         /* 동일 그룹 내 표시 순서 */
  CONSTRAINT PK_FREE_BOARD PRIMARY KEY(FREE_BOARD_NO)
);

ALTER TABLE FREE_BOARD
    ADD CONSTRAINT FK_FREE_USERS FOREIGN KEY(ID)
        REFERENCES USERS(ID)
            ON DELETE SET NULL;
            
DROP SEQUENCE GALLERY_BOARD_SEQ;
CREATE SEQUENCE GALLERY_BOARD_SEQ NOCACHE;
DROP SEQUENCE COMMENTS_SEQ;
CREATE SEQUENCE COMMENTS_SEQ NOCACHE;

CREATE TABLE LOVES(                         -- 좋아요
    ID                  VARCHAR2(30 BYTE),  -- USER ID
    GALLERY_BOARD_NO    NUMBER              -- 갤러리 글 번호
);

CREATE TABLE COMMENTS(                                --댓글
    COMMENTS_NO         NUMBER      NOT NULL,         -- PK
    ID                  VARCHAR2(30 BYTE),            -- USER ID, 작성자
    GALLERY_BOARD_NO    NUMBER,                       -- 글번호
    CREATE_DATE         DATE,                         -- 작성일
    COMM_CONTENT        VARCHAR2(700 BYTE) NOT NULL,  -- 본문
    IP                  VARCHAR2(30 BYTE),
    STATE               NUMBER(1),                    -- /* 정상 : 1, 삭제 : 0 */
    DEPTH               NUMBER(2),                    -- 댓글들여쓰기
    GROUP_NO            NUMBER,                       -- 그룹번호
    GROUP_ORDER         NUMBER,                       -- 그룹순서
CONSTRAINT PK_COMMENTS PRIMARY KEY(COMMENTS_NO)
);

CREATE TABLE GALLERY_BOARD(
   GALLERY_BOARD_NO NUMBER NOT NULL,
   ID               VARCHAR2(30 byte),               -- USERID, 작성자
   GALLERY_TITLE    VARCHAR2(100 BYTE)  NOT NULL,    -- 제목
   GALLERY_CONTENT  VARCHAR2(4000 BYTE) NOT NULL,    -- 본문
   IP               VARCHAR2(30 BYTE),
   CREATE_DATE      DATE                NOT NULL,    -- 작성일
   MODIFY_DATE      DATE,                            -- 수정일
   HIT              NUMBER,                          -- 조회수
CONSTRAINT PK_GALLERY_BOARD PRIMARY KEY(GALLERY_BOARD_NO)
);

ALTER TABLE GALLERY_BOARD
    ADD CONSTRAINT FK_GALLERY_USERS FOREIGN KEY(ID)
        REFERENCES USERS(ID)
            ON DELETE SET NULL;
        
ALTER TABLE COMMENTS
    ADD CONSTRAINT FK_COMMENTS_USERS FOREIGN KEY(ID)
        REFERENCES USERS(ID)
            ON DELETE SET NULL;

ALTER TABLE LOVES
    ADD CONSTRAINT FK_LOVES_USERS FOREIGN KEY(ID)
        REFERENCES USERS(ID)
            ON DELETE SET NULL;
        
ALTER TABLE COMMENTS
    ADD CONSTRAINT FK_COMMENTS_GALLERY FOREIGN KEY(GALLERY_BOARD_NO)
        REFERENCES GALLERY_BOARD(GALLERY_BOARD_NO)
            ON DELETE CASCADE;
            
ALTER TABLE LOVES
    ADD CONSTRAINT FK_LOVES_GALLERY FOREIGN KEY(GALLERY_BOARD_NO)
        REFERENCES GALLERY_BOARD(GALLERY_BOARD_NO)
            ON DELETE CASCADE;
            
DROP SEQUENCE UPLOAD_SEQ;
CREATE SEQUENCE UPLOAD_SEQ NOCACHE;
DROP SEQUENCE ATTACH_SEQ;
CREATE SEQUENCE ATTACH_SEQ NOCACHE;

CREATE TABLE ATTACH(
    ATTACH_NO           NUMBER NOT NULL,     -- PK
    PATH                VARCHAR2(300 BYTE),  -- 파일의 경로
    ORIGIN              VARCHAR2(300 BYTE),  -- 파일의 원래 이름
    FILESYSTEM          VARCHAR2(300 BYTE),  -- 파일의 저장된 이름
    DOWNLOAD_CNT        NUMBER,              -- 다운로드 횟수
    UPLOAD_BOARD_NO     NUMBER,              -- 게시글 번호, FK
CONSTRAINT PK_ATTACH PRIMARY KEY(ATTACH_NO)
);

CREATE TABLE UPLOAD_BOARD(
    UPLOAD_BOARD_NO NUMBER NOT NULL,                -- PK
    ID              VARCHAR2(30 BYTE),    -- USER ID, 작성자
    UPLOAD_TITLE    VARCHAR2(100 BYTE) NOT NULL,    -- 제목
    UPLOAD_CONTENT  VARCHAR2(100 BYTE) NOT NULL,    -- 내용
    IP              VARCHAR2(30 BYTE),              -- IP
    CREATE_DATE     DATE               NOT NULL,    -- 작성일
    MODIFY_DATE     DATE,                           -- 수정일
    HIT             NUMBER,                         -- 조회수
CONSTRAINT PK_UPLOAD_BOARD PRIMARY KEY(UPLOAD_BOARD_NO)
);

ALTER TABLE UPLOAD_BOARD
    ADD CONSTRAINT FK_UPLOAD_USERS
        FOREIGN KEY(ID) REFERENCES USERS(ID)
            ON DELETE SET NULL;
        
ALTER TABLE ATTACH
    ADD CONSTRAINT FK_ATTACH_UPLOAD
        FOREIGN KEY(UPLOAD_BOARD_NO) REFERENCES UPLOAD_BOARD(UPLOAD_BOARD_NO)
            ON DELETE CASCADE;