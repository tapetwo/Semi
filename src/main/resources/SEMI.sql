DROP TABLE ATTACH;
DROP TABLE UPLOAD_BOARD;
DROP TABLE COMMENTS;     -- ���
DROP TABLE LOVES;       -- ���ƿ�
DROP TABLE GALLERY_BOARD;
DROP TABLE FREE_BOARD;
DROP TABLE ACCESS_LOG;
DROP TABLE USERS;
DROP TABLE RETIRE_USERS;
DROP TABLE SLEEP_USERS;

-- ȸ�� ���̺�
CREATE TABLE USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    PW VARCHAR2(64 BYTE) NOT NULL,  -- ��ȣȭ�� ��� �ִ� 64����Ʈ.
    NAME VARCHAR2(50 BYTE) NOT NULL,
    GENDER VARCHAR2(2 BYTE) NOT NULL,  -- M, F, NO
    EMAIL VARCHAR2(50 BYTE) NOT NULL UNIQUE,  -- �̸��� ���� ������ UNIQUE
    MOBILE VARCHAR2(11 BYTE) NOT NULL,  -- �޴���ȭ��ȣ(������ ���� �ִ� 11�ڸ�)
    BIRTHYEAR VARCHAR2(4 BYTE) NOT NULL,  -- ����⵵(YYYY)
    BIRTHDAY VARCHAR2(4 BYTE) NOT NULL,  -- ����(MMDD)
    POSTCODE VARCHAR2(5 BYTE),           -- �����ȣ
    ROAD_ADDRESS VARCHAR2(100 BYTE),     -- ���θ��ּ�
    JIBUN_ADDRESS VARCHAR2(100 BYTE),    -- �����ּ�
    DETAIL_ADDRESS VARCHAR2(100 BYTE),   -- ���ּ�
    EXTRA_ADDRESS VARCHAR2(100 BYTE),    -- �����׸�
    AGREE_CODE NUMBER NOT NULL,          -- ���ǿ���(0:�ʼ�, 1:�ʼ�+��ġ, 2:�ʼ�+���θ��, 3:�ʼ�+��ġ+���θ��)
    SNS_TYPE VARCHAR2(10 BYTE),          -- ����������(����Ʈ����:null, �׾Ʒ�:naver)
    JOIN_DATE DATE NOT NULL,             -- ������
    PW_MODIFY_DATE DATE,                 -- ��� ������
    INFO_MODIFY_DATE DATE,               -- ȸ������ ������
    SESSION_ID VARCHAR2(32 BYTE),        -- ���� ���̵�
    SESSION_LIMIT_DATE DATE,             -- ���� ������
    POINT NUMBER                         -- ����Ʈ
);

-- ȸ�����ӱ�� (�ֱ� ���� ��� 1���� ����)
CREATE TABLE ACCESS_LOG(
    ACCESS_LOG_NO   NUMBER NOT NULL,
    ID              VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    LAST_LOGIN_DATE DATE NOT NULL          -- ������ �α�����
);

-- USERS �⺻Ű
ALTER TABLE USERS
    ADD CONSTRAINT USERS_PK
        PRIMARY KEY(USER_NO);
-- ACCESS_LOG �⺻Ű
ALTER TABLE ACCESS_LOG
    ADD CONSTRAINT ACCESS_LOG_PK
        PRIMARY KEY(ACCESS_LOG_NO);
-- ACCESS_LOG �ܷ�Ű
ALTER TABLE ACCESS_LOG
    ADD CONSTRAINT ACCESS_LOG_USERS_FK
        FOREIGN KEY(ID) REFERENCES USERS(ID)
            ON DELETE CASCADE;
-- ������
DROP SEQUENCE USERS_SEQ;
DROP SEQUENCE ACCESS_LOG_SEQ;
CREATE SEQUENCE USERS_SEQ NOCACHE;
CREATE SEQUENCE ACCESS_LOG_SEQ NOCACHE;

-- Ż�� ���̺�(�� ������ ���̵�� �簡���ϰų� Ż���� ���̵� �����ϴ� ���� �Ұ���)
CREATE TABLE RETIRE_USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    JOIN_DATE DATE,                         -- ������
    RETIRE_DATE DATE                        -- Ż����
);

-- �޸� ���̺�
CREATE TABLE SLEEP_USERS(
    USER_NO NUMBER NOT NULL,
    ID VARCHAR2(30 BYTE) NOT NULL UNIQUE,
    PW VARCHAR2(64 BYTE) NOT NULL,               -- ��ȣȭ�� ��� �ִ� 64����Ʈ.
    NAME VARCHAR2(50 BYTE) NOT NULL,             -- �̸�
    GENDER VARCHAR2(2 BYTE) NOT NULL,            -- M, F, NO
    EMAIL VARCHAR2(50 BYTE) NOT NULL UNIQUE,     -- �̸��� ���� ������ UNIQUE
    MOBILE VARCHAR2(11 BYTE) NOT NULL,           -- �޴���ȭ��ȣ(������ ���� �ִ� 11�ڸ�)
    BIRTHYEAR VARCHAR2(4 BYTE) NOT NULL,         -- ����⵵(YYYY)
    BIRTHDAY VARCHAR2(4 BYTE) NOT NULL,          -- ����(MMDD)
    POSTCODE VARCHAR2(5 BYTE),                   -- �����ȣ
    ROAD_ADDRESS VARCHAR2(100 BYTE),             -- ���θ��ּ�
    JIBUN_ADDRESS VARCHAR2(100 BYTE),            -- �����ּ�
    DETAIL_ADDRESS VARCHAR2(100 BYTE),           -- ���ּ�
    EXTRA_ADDRESS VARCHAR2(100 BYTE),            -- �����׸�
    AGREE_CODE NUMBER NOT NULL,                  -- ���ǿ���(0:�ʼ�, 1:�ʼ�+��ġ, 2:�ʼ�+���θ��, 3:�ʼ�+��ġ+���θ��)
    SNS_TYPE VARCHAR2(10 BYTE),                  -- ����������(����Ʈ����:null, �׾Ʒ�:naver)
    JOIN_DATE DATE,                              -- ������
    LAST_LOGIN_DATE DATE,                        -- ������ �α�����
    SLEEP_DATE DATE,                             -- �޸�ó����
    POINT NUMBER                                 -- ����Ʈ
);

-- ���̵�/���(id01/1111, id02/2222, id03/3333, id04/4444, id05/5555)
INSERT INTO USERS VALUES(USERS_SEQ.NEXTVAL, 'admin', '0FFE1ABD1A08215353C233D6E009613E95EEC4253832A761AF28FF37AC5A150C', 'NAME1', 'M', 'id01@naver.com', '01011111111', '1999', '0101', '11111', 'ROAD1', 'JIBUN1', 'DETAIL1', 'EXTRA1', 0, NULL, TO_DATE('20201010', 'YYYYMMDD'), NULL, NULL, NULL, NULL, 0);
COMMIT;

DROP SEQUENCE FREE_BOARD_SEQ;
CREATE SEQUENCE FREE_BOARD_SEQ NOCACHE;

CREATE TABLE FREE_BOARD(
  FREE_BOARD_NO     NUMBER NOT NULL,                -- PK
  ID                VARCHAR2(30 BYTE),              -- FK
  FREE_TITLE        VARCHAR2(1000 BYTE) NOT NULL,   -- ����
  FREE_CONTENT      VARCHAR2(4000 BYTE) NOT NULL,   -- ����
  IP                VARCHAR2(30 BYTE),
  CREATE_DATE       DATE   NOT NULL,                -- �ۼ���
  MODIFY_DATE       DATE,                           -- ������
  STATE             NUMBER(1),                      /* ���� : 1, ���� : 0 */
  DEPTH             NUMBER(2),                      -- ��۵鿩����
  GROUP_NO          NUMBER,                         -- �׷��ȣ
  GROUP_ORDER       NUMBER,                         /* ���� �׷� �� ǥ�� ���� */
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

CREATE TABLE LOVES(                         -- ���ƿ�
    ID                  VARCHAR2(30 BYTE),  -- USER ID
    GALLERY_BOARD_NO    NUMBER              -- ������ �� ��ȣ
);

CREATE TABLE COMMENTS(                                --���
    COMMENTS_NO         NUMBER      NOT NULL,         -- PK
    ID                  VARCHAR2(30 BYTE),            -- USER ID, �ۼ���
    GALLERY_BOARD_NO    NUMBER,                       -- �۹�ȣ
    CREATE_DATE         DATE,                         -- �ۼ���
    COMM_CONTENT        VARCHAR2(700 BYTE) NOT NULL,  -- ����
    IP                  VARCHAR2(30 BYTE),
    STATE               NUMBER(1),                    -- /* ���� : 1, ���� : 0 */
    DEPTH               NUMBER(2),                    -- ��۵鿩����
    GROUP_NO            NUMBER,                       -- �׷��ȣ
    GROUP_ORDER         NUMBER,                       -- �׷����
CONSTRAINT PK_COMMENTS PRIMARY KEY(COMMENTS_NO)
);

CREATE TABLE GALLERY_BOARD(
   GALLERY_BOARD_NO NUMBER NOT NULL,
   ID               VARCHAR2(30 byte),               -- USERID, �ۼ���
   GALLERY_TITLE    VARCHAR2(100 BYTE)  NOT NULL,    -- ����
   GALLERY_CONTENT  VARCHAR2(4000 BYTE) NOT NULL,    -- ����
   IP               VARCHAR2(30 BYTE),
   CREATE_DATE      DATE                NOT NULL,    -- �ۼ���
   MODIFY_DATE      DATE,                            -- ������
   HIT              NUMBER,                          -- ��ȸ��
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
    PATH                VARCHAR2(300 BYTE),  -- ������ ���
    ORIGIN              VARCHAR2(300 BYTE),  -- ������ ���� �̸�
    FILESYSTEM          VARCHAR2(300 BYTE),  -- ������ ����� �̸�
    DOWNLOAD_CNT        NUMBER,              -- �ٿ�ε� Ƚ��
    UPLOAD_BOARD_NO     NUMBER,              -- �Խñ� ��ȣ, FK
CONSTRAINT PK_ATTACH PRIMARY KEY(ATTACH_NO)
);

CREATE TABLE UPLOAD_BOARD(
    UPLOAD_BOARD_NO NUMBER NOT NULL,                -- PK
    ID              VARCHAR2(30 BYTE),    -- USER ID, �ۼ���
    UPLOAD_TITLE    VARCHAR2(100 BYTE) NOT NULL,    -- ����
    UPLOAD_CONTENT  VARCHAR2(100 BYTE) NOT NULL,    -- ����
    IP              VARCHAR2(30 BYTE),              -- IP
    CREATE_DATE     DATE               NOT NULL,    -- �ۼ���
    MODIFY_DATE     DATE,                           -- ������
    HIT             NUMBER,                         -- ��ȸ��
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