--liquibase formatted sql

--changeset kmpk:init_schema
DROP TABLE IF EXISTS USER_ROLE;
DROP TABLE IF EXISTS CONTACT;
DROP TABLE IF EXISTS MAIL_CASE;
DROP TABLE IF EXISTS PROFILE;
DROP TABLE IF EXISTS TASK_TAG;
DROP TABLE IF EXISTS USER_BELONG;
DROP TABLE IF EXISTS ACTIVITY;
DROP TABLE IF EXISTS TASK;
DROP TABLE IF EXISTS SPRINT;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS REFERENCE;
DROP TABLE IF EXISTS ATTACHMENT;
DROP TABLE IF EXISTS USERS;

-- Create sequences
--CREATE SEQUENCE USER_ROLE_ID_SEQ;
--CREATE SEQUENCE CONTACT_ID_SEQ;
--CREATE SEQUENCE MAIL_CASE_ID_SEQ;
--CREATE SEQUENCE PROFILE_ID_SEQ;
--CREATE SEQUENCE TASK_TAG_ID_SEQ;
--CREATE SEQUENCE USER_BELONG_ID_SEQ;
--CREATE SEQUENCE ACTIVITY_ID_SEQ;
--CREATE SEQUENCE TASK_ID_SEQ;
--CREATE SEQUENCE SPRINT_ID_SEQ;
--CREATE SEQUENCE PROJECT_ID_SEQ;
--CREATE SEQUENCE REFERENCE_ID_SEQ;
--CREATE SEQUENCE ATTACHMENT_ID_SEQ;
--CREATE SEQUENCE USERS_ID_SEQ;

create table PROJECT
(
    ID          integer primary key,
    CODE        varchar(32)   not null
        constraint UK_PROJECT_CODE unique,
    TITLE       varchar(1024) not null,
    DESCRIPTION varchar(4096) not null,
    TYPE_CODE   varchar(32)   not null,
    STARTPOINT  timestamp,
    ENDPOINT    timestamp,
    PARENT_ID   bigint,
    constraint FK_PROJECT_PARENT foreign key (PARENT_ID) references PROJECT (ID) on delete cascade
);

create table MAIL_CASE
(
    ID        integer primary key,
    EMAIL     varchar(255) not null,
    NAME      varchar(255) not null,
    DATE_TIME timestamp    not null,
    RESULT    varchar(255) not null,
    TEMPLATE  varchar(255) not null
);

create table SPRINT
(
    ID          integer primary key,
    STATUS_CODE varchar(32) not null,
    STARTPOINT  timestamp,
    ENDPOINT    timestamp,
    CODE        varchar(32) not null,
    PROJECT_ID  bigint      not null,
    constraint FK_SPRINT_PROJECT foreign key (PROJECT_ID) references PROJECT (ID) on delete cascade
);

create table REFERENCE
(
    ID         integer primary key,
    CODE       varchar(32)   not null,
    REF_TYPE   smallint      not null,
    ENDPOINT   timestamp,
    STARTPOINT timestamp,
    TITLE      varchar(1024) not null,
    AUX        varchar,
    constraint UK_REFERENCE_REF_TYPE_CODE unique (REF_TYPE, CODE)
);

create table USERS
(
    ID           integer primary key,
    DISPLAY_NAME varchar(32)  not null
        constraint UK_USERS_DISPLAY_NAME unique,
    EMAIL        varchar(128) not null
        constraint UK_USERS_EMAIL unique,
    FIRST_NAME   varchar(32)  not null,
    LAST_NAME    varchar(32),
    PASSWORD     varchar(128) not null,
    ENDPOINT     timestamp,
    STARTPOINT   timestamp
);

create table PROFILE
(
    ID                 bigint primary key,
    LAST_LOGIN         timestamp,
    LAST_FAILED_LOGIN  timestamp,
    MAIL_NOTIFICATIONS bigint,
    constraint FK_PROFILE_USERS foreign key (ID) references USERS (ID) on delete cascade
);

create table CONTACT
(
    ID      bigint       not null,
    CODE    varchar(32)  not null,
    "VALUE" varchar(256) not null,
    primary key (ID, CODE),
    constraint FK_CONTACT_PROFILE foreign key (ID) references PROFILE (ID) on delete cascade
);

create table TASK
(
    ID          integer primary key,
    TITLE       varchar(1024) not null,
    TYPE_CODE   varchar(32)   not null,
    STATUS_CODE varchar(32)   not null,
    PROJECT_ID  bigint        not null,
    SPRINT_ID   bigint,
    PARENT_ID   bigint,
    STARTPOINT  timestamp,
    ENDPOINT    timestamp,
    constraint FK_TASK_SPRINT foreign key (SPRINT_ID) references SPRINT (ID) on delete set null,
    constraint FK_TASK_PROJECT foreign key (PROJECT_ID) references PROJECT (ID) on delete cascade,
    constraint FK_TASK_PARENT_TASK foreign key (PARENT_ID) references TASK (ID) on delete cascade
);

create table ACTIVITY
(
    ID            integer primary key,
    AUTHOR_ID     bigint not null,
    TASK_ID       bigint not null,
    UPDATED       timestamp,
    COMMENT       varchar(4096),
--     history of task field change
    TITLE         varchar(1024),
    DESCRIPTION   varchar(4096),
    ESTIMATE      integer,
    TYPE_CODE     varchar(32),
    STATUS_CODE   varchar(32),
    PRIORITY_CODE varchar(32)
);

create table TASK_TAG
(
    TASK_ID bigint      not null,
    TAG     varchar(32) not null,
    constraint UK_TASK_TAG unique (TASK_ID, TAG),
    constraint FK_TASK_TAG foreign key (TASK_ID) references TASK (ID) on delete cascade
);

create table USER_BELONG
(
    ID             integer primary key,
    OBJECT_ID      bigint      not null,
    OBJECT_TYPE    smallint    not null,
    USER_ID        bigint      not null,
    USER_TYPE_CODE varchar(32) not null,
    STARTPOINT     timestamp,
    ENDPOINT       timestamp
);

create table ATTACHMENT
(
    ID          integer primary key,
    NAME        varchar(128)  not null,
    FILE_LINK   varchar(2048) not null,
    OBJECT_ID   bigint        not null,
    OBJECT_TYPE smallint      not null,
    USER_ID     bigint        not null,
    DATE_TIME   timestamp
);

create table USER_ROLE
(
    USER_ID bigint   not null,
    ROLE    smallint not null,
    constraint UK_USER_ROLE unique (USER_ID, ROLE),
    constraint FK_USER_ROLE foreign key (USER_ID) references USERS (ID) on delete cascade
);

--changeset kmpk:populate_data
--============ References =================
insert into REFERENCE (ID, CODE, TITLE, REF_TYPE)
-- TASK
values (1, 'task', 'Task', 2),
       (2, 'story', 'Story', 2),
       (3, 'bug', 'Bug', 2),
       (4, 'epic', 'Epic', 2),
-- SPRINT_STATUS
       (5, 'planning', 'Planning', 4),
       (6, 'active', 'Active', 4),
       (7, 'finished', 'Finished', 4),
-- USER_TYPE
       (8, 'author', 'Author', 5),
       (9, 'developer', 'Developer', 5),
       (10, 'reviewer', 'Reviewer', 5),
       (11, 'tester', 'Tester', 5),
-- PROJECT
       (12, 'scrum', 'Scrum', 1),
       (13, 'task_tracker', 'Task tracker', 1),
-- CONTACT
       (14, 'skype', 'Skype', 0),
       (15, 'tg', 'Telegram', 0),
       (16, 'mobile', 'Mobile', 0),
       (17, 'phone', 'Phone', 0),
       (18, 'website', 'Website', 0),
       (19, 'linkedin', 'LinkedIn', 0),
       (20, 'github', 'GitHub', 0),
-- PRIORITY
       (21, 'critical', 'Critical', 7),
       (22, 'high', 'High', 7),
       (23, 'normal', 'Normal', 7),
       (24, 'low', 'Low', 7),
       (25, 'neutral', 'Neutral', 7);

insert into REFERENCE (ID, CODE, TITLE, REF_TYPE, AUX)
-- MAIL_NOTIFICATION
values (26, 'assigned', 'Assigned', 6, '1'),
       (27, 'three_days_before_deadline', 'Three days before deadline', 6, '2'),
       (28, 'two_days_before_deadline', 'Two days before deadline', 6, '4'),
       (29, 'one_day_before_deadline', 'One day before deadline', 6, '8'),
       (30, 'deadline', 'Deadline', 6, '16'),
       (31, 'overdue', 'Overdue', 6, '32'),
-- TASK_STATUS
       (32, 'todo', 'ToDo', 3, 'in_progress,canceled'),
       (33, 'in_progress', 'In progress', 3, 'ready_for_review,canceled'),
       (34, 'ready_for_review', 'Ready for review', 3, 'review,canceled'),
       (35, 'review', 'Review', 3, 'in_progress,ready_for_test,canceled'),
       (36, 'ready_for_test', 'Ready for test', 3, 'test,canceled'),
       (37, 'test', 'Test', 3, 'done,in_progress,canceled'),
       (38, 'done', 'Done', 3, 'canceled'),
       (39, 'canceled', 'Canceled', 3, null);

--changeset gkislin:change_backtracking_tables


create unique index UK_SPRINT_PROJECT_CODE on SPRINT (PROJECT_ID, CODE);

--changeset ishlyakhtenkov:change_task_status_reference

delete
from REFERENCE
where REF_TYPE = 3;
insert into REFERENCE (ID, CODE, TITLE, REF_TYPE, AUX)
values (40, 'todo', 'ToDo', 3, 'in_progress,canceled'),
       (41, 'in_progress', 'In progress', 3, 'ready_for_review,canceled'),
       (42, 'ready_for_review', 'Ready for review', 3, 'in_progress,review,canceled'),
       (43, 'review', 'Review', 3, 'in_progress,ready_for_test,canceled'),
       (44, 'ready_for_test', 'Ready for test', 3, 'review,test,canceled'),
       (45, 'test', 'Test', 3, 'done,in_progress,canceled'),
       (46, 'done', 'Done', 3, 'canceled'),
       (47, 'canceled', 'Canceled', 3, null);

--changeset gkislin:users_add_on_delete_cascade
alter table ACTIVITY
    add constraint FK_ACTIVITY_USERS foreign key (AUTHOR_ID) references USERS (ID) on delete cascade;

alter table USER_BELONG
    add constraint FK_USER_BELONG foreign key (USER_ID) references USERS (ID) on delete cascade;

alter table ATTACHMENT
    add constraint FK_ATTACHMENT foreign key (USER_ID) references USERS (ID) on delete cascade;

--changeset valeriyemelyanov:change_user_type_reference

delete
from REFERENCE
where REF_TYPE = 5;
insert into REFERENCE (ID, CODE, TITLE, REF_TYPE)
-- USER_TYPE
values (48, 'project_author', 'Author', 5),
       (49, 'project_manager', 'Manager', 5),
       (50, 'sprint_author', 'Author', 5),
       (51, 'sprint_manager', 'Manager', 5),
       (52, 'task_author', 'Author', 5),
       (53, 'task_developer', 'Developer', 5),
       (54, 'task_reviewer', 'Reviewer', 5),
       (55, 'task_tester', 'Tester', 5);

--changeset apolik:refactor_reference_aux

-- TASK_TYPE
delete
from REFERENCE
where REF_TYPE = 3;
insert into REFERENCE (ID, CODE, TITLE, REF_TYPE, AUX)
values (56, 'todo', 'ToDo', 3, 'in_progress,canceled|'),
       (57, 'in_progress', 'In progress', 3, 'ready_for_review,canceled|task_developer'),
       (58, 'ready_for_review', 'Ready for review', 3, 'in_progress,review,canceled|'),
       (59, 'review', 'Review', 3, 'in_progress,ready_for_test,canceled|task_reviewer'),
       (60, 'ready_for_test', 'Ready for test', 3, 'review,test,canceled|'),
       (61, 'test', 'Test', 3, 'done,in_progress,canceled|task_tester'),
       (62, 'done', 'Done', 3, 'canceled|'),
       (63, 'canceled', 'Canceled', 3, null);