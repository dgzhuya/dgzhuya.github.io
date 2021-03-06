drop table if exists permission;
create table permission
(
    id          integer      not null
        primary key autoincrement,
    create_time datetime default (datetime('now')) not null,
    update_time datetime default (datetime('now')) not null,
    delete_time datetime,
    title       varchar(100) not null,
    key         varchar(100),
    description varchar(200),
    parentId    integer,
    hasChildren boolean  default 0 not null
);
drop table if exists role;
create table role
(
    id          integer     not null
        primary key autoincrement,
    create_time datetime default (datetime('now')) not null,
    update_time datetime default (datetime('now')) not null,
    delete_time datetime,
    title       varchar(30) not null
        constraint UQ_4a74ca47fe1aa34a28a6db3c722
            unique,
    description varchar(200)
);
drop table if exists user;
create table user
(
    id          integer      not null
        primary key autoincrement,
    create_time datetime default (datetime('now')) not null,
    update_time datetime default (datetime('now')) not null,
    delete_time datetime,
    username    varchar(30)  not null
        constraint UQ_78a916df40e02a9deb1c4b75edb
            unique,
    nickname    varchar(30),
    mobile      varchar,
    gender      bigint,
    address     varchar(30),
    avatar      varchar(100),
    password    varchar(100) not null
);
drop table if exists user_role;
create table user_role
(
    id      integer not null
        primary key autoincrement,
    roleId  integer not null,
    userId  integer not null,
    isMajor tinyint default 0 not null
);
drop table if exists role_permission;
create table role_permission
(
    id           integer not null
        primary key autoincrement,
    roleId       integer not null,
    permissionId integer not null
);

INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 04:45:38', '2022-06-07 08:54:59', null, '????????????', 'SuperAdmin', '????????????????????????', null, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 04:51:01', '2022-06-07 08:28:45', null, '????????????', 'AdminUser', '????????????????????????', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 05:05:28', '2022-06-06 13:26:23', null, '????????????', 'super-admin_user_add', '????????????????????????', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 05:07:13', '2022-06-07 08:28:00', null, '????????????', 'Tool', '??????????????????', null, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 12:43:39', '2022-06-05 07:49:49', null, '????????????', 'AdminRole', '??????????????????', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 12:44:30', '2022-06-05 09:34:21', null, '????????????', 'AdminPermission', '??????????????????', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 14:29:21', '2022-06-05 07:46:03', null, '????????????', 'super-admin_user_update', '??????????????????', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 14:30:01', '2022-06-05 07:46:15', null, '????????????', 'super-admin_user_delete', '??????????????????', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 07:49:49', '2022-06-06 13:26:07', null, '????????????', 'super-admin_role_add', '??????????????????', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:31:48', '2022-06-05 09:31:48', null, '????????????', 'super-admin_role_delete', '??????????????????', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:33:22', '2022-06-05 09:33:22', null, '????????????', 'super-admin_role_update', '??????????????????', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:34:21', '2022-06-05 11:56:30', null, '????????????', 'super-admin_permission_add', '????????????????????????', 6, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:36:51', '2022-06-05 11:35:26', null, '????????????', 'super-admin_permission_delete', '??????????????????', 6,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 11:58:06', '2022-06-05 11:58:06', null, '????????????', 'super-admin_permission_update', '??????????????????', 6,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 12:46:29', '2022-06-05 12:46:29', null, '??????????????????', 'super-admin_role_permission', '??????????????????', 5,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:28:00', '2022-06-07 08:38:37', null, '????????????', 'ToolPlugin', '????????????', 4, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:38:37', '2022-06-07 08:38:37', null, '????????????', 'tool_plugin_add', '??????????????????', 27, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:39:35', '2022-06-07 08:39:35', null, '????????????', 'tool_plugin_update', '??????????????????', 27, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:43:41', '2022-06-07 08:43:41', null, '????????????', 'tool_plugin_delete', '????????????', 27, 0);

INSERT INTO role (create_time, update_time, delete_time, title, description)
VALUES ('2022-05-14 04:45:32', '2022-06-03 07:28:15', null, '?????????', '???????????????????????????????????????????????????????????????');
INSERT INTO role (create_time, update_time, delete_time, title, description)
VALUES ('2022-05-14 07:54:15', '2022-05-14 07:54:15', null, '?????????', '???????????????');

INSERT INTO user (create_time, update_time, delete_time, username, nickname, mobile, gender, address, avatar, password)
VALUES ('2022-05-14 04:45:23', '2022-06-06 14:02:27', null, 'super-admin', '???????????????', '', 1, null, null,
        '$2a$10$aSRwOHnesbDdHoeExUy9hOo.vqAdfzspvE9/U4lCX9lI7tbdDIugG');

INSERT INTO user_role (roleId, userId, isMajor)
VALUES (1, 1, 1);
INSERT INTO user_role (roleId, userId, isMajor)
VALUES (2, 1, 0);

INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 1);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 2);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 3);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 4);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 5);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 6);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 7);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 8);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 9);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 10);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 11);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 12);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 13);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 14);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 15);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 16);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 17);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 18);
INSERT INTO role_permission (roleId, permissionId)
VALUES (1, 19);
