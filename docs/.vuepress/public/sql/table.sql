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
VALUES ('2022-05-14 04:45:38', '2022-06-07 08:54:59', null, '系统管理', 'SuperAdmin', '系统管理设置权限', null, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 04:51:01', '2022-06-07 08:28:45', null, '用户管理', 'AdminUser', '用户管理路由权限', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 05:05:28', '2022-06-06 13:26:23', null, '添加用户', 'super-admin_user_add', '添加用户按钮展示', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-05-14 05:07:13', '2022-06-07 08:28:00', null, '工具管理', 'Tool', '工具管理权限', null, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 12:43:39', '2022-06-05 07:49:49', null, '角色管理', 'AdminRole', '角色管理路由', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 12:44:30', '2022-06-05 09:34:21', null, '权限管理', 'AdminPermission', '权限管理路由', 1, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 14:29:21', '2022-06-05 07:46:03', null, '修改用户', 'super-admin_user_update', '修改用户权限', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-03 14:30:01', '2022-06-05 07:46:15', null, '删除用户', 'super-admin_user_delete', '删除用户权限', 2, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 07:49:49', '2022-06-06 13:26:07', null, '添加角色', 'super-admin_role_add', '添加角色权限', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:31:48', '2022-06-05 09:31:48', null, '删除角色', 'super-admin_role_delete', '删除角色权限', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:33:22', '2022-06-05 09:33:22', null, '编辑角色', 'super-admin_role_update', '编辑角色权限', 5, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:34:21', '2022-06-05 11:56:30', null, '添加权限', 'super-admin_permission_add', '添加权限数据权限', 6, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 09:36:51', '2022-06-05 11:35:26', null, '删除权限', 'super-admin_permission_delete', '删除权限功能', 6,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 11:58:06', '2022-06-05 11:58:06', null, '编辑权限', 'super-admin_permission_update', '更新权限数据', 6,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-05 12:46:29', '2022-06-05 12:46:29', null, '设置角色权限', 'super-admin_role_permission', '设置角色权限', 5,
        0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:28:00', '2022-06-07 08:38:37', null, '插件管理', 'ToolPlugin', '插件管理', 4, 1);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:38:37', '2022-06-07 08:38:37', null, '添加插件', 'tool_plugin_add', '添加插件权限', 27, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:39:35', '2022-06-07 08:39:35', null, '修改插件', 'tool_plugin_update', '修改插件功能', 27, 0);
INSERT INTO permission (create_time, update_time, delete_time, title, key, description, parentId, hasChildren)
VALUES ('2022-06-07 08:43:41', '2022-06-07 08:43:41', null, '删除插件', 'tool_plugin_delete', '删除插件', 27, 0);

INSERT INTO role (create_time, update_time, delete_time, title, description)
VALUES ('2022-05-14 04:45:32', '2022-06-03 07:28:15', null, '管理员', '拥有基础权限信息，处理后台管理系统基础设置');
INSERT INTO role (create_time, update_time, delete_time, title, description)
VALUES ('2022-05-14 07:54:15', '2022-05-14 07:54:15', null, '运营者', '运营者角色');

INSERT INTO user (create_time, update_time, delete_time, username, nickname, mobile, gender, address, avatar, password)
VALUES ('2022-05-14 04:45:23', '2022-06-06 14:02:27', null, 'super-admin', '超级管理员', '', 1, null, null,
        '$2a$10$aSRwOHnesbDdHoeExUy9hOo.vqAdfzspvE9/U4lCX9lI7tbdDIugG');
INSERT INTO user (create_time, update_time, delete_time, username, nickname, mobile, gender, address, avatar, password)
VALUES ('2022-06-06 14:02:01', '2022-06-06 14:02:07', null, 'test_user', '测试用户', null, 1, null, null,
        '$2a$10$CDXaMJgBXMzs27IXIlEiP.jjhNc4xEKAEP/x5bCnAgPyYibjvbDL.');

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
