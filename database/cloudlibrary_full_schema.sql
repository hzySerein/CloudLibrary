-- ============================================================
-- CloudLibrary 云借阅图书管理系统 - 数据库初始化脚本
-- ============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS cloudlibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE cloudlibrary;

-- 删除现有表（按外键依赖顺序）
DROP TABLE IF EXISTS borrow;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS user;

-- ============================================================
-- 用户表（存储管理员和普通用户）
-- ============================================================
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名（登录账号）',
    password VARCHAR(60) NOT NULL COMMENT '密码（BCrypt哈希）',
    name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '电话号码',
    status INT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    role VARCHAR(20) NOT NULL COMMENT '角色：admin-管理员，user-普通用户',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT='用户表';

-- ============================================================
-- 图书表
-- ============================================================
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '图书ID',
    name VARCHAR(100) NOT NULL COMMENT '书名',
    author VARCHAR(100) NOT NULL COMMENT '作者',
    isbn VARCHAR(50) UNIQUE COMMENT 'ISBN号（唯一）',
    stock INT DEFAULT 0 COMMENT '库存数量',
    type VARCHAR(50) COMMENT '图书类型（如：计算机、文学、科幻、历史）',
    status INT DEFAULT 1 COMMENT '状态：1-可借，0-不可借',
    cover VARCHAR(200) COMMENT '封面图片路径',
    description TEXT COMMENT '图书介绍',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT='图书表';

-- ============================================================
-- 借阅表
-- ============================================================
CREATE TABLE borrow (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '借阅ID',
    book_id INT NOT NULL COMMENT '图书ID',
    user_id INT NOT NULL COMMENT '用户ID',
    borrow_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '借阅时间',
    due_time DATETIME NOT NULL COMMENT '应归还时间',
    return_time DATETIME COMMENT '实际归还时间',
    status INT DEFAULT 0 COMMENT '状态：0-未归还，1-已归还，2-待确认归还',
    FOREIGN KEY (book_id) REFERENCES book(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
) COMMENT='借阅表';

-- ============================================================
-- 索引
-- ============================================================

-- 图书表索引
CREATE INDEX idx_book_name ON book(name);
CREATE INDEX idx_book_type ON book(type);
CREATE INDEX idx_book_status ON book(status);

-- 借阅表索引
CREATE INDEX idx_borrow_user ON borrow(user_id);
CREATE INDEX idx_borrow_book ON borrow(book_id);
CREATE INDEX idx_borrow_status ON borrow(status);
CREATE INDEX idx_borrow_user_time ON borrow(user_id, borrow_time);
CREATE INDEX idx_borrow_overdue ON borrow(status, due_time);

-- 用户表索引
CREATE INDEX idx_user_status ON user(status);
CREATE INDEX idx_user_role ON user(role);

-- ============================================================
-- 初始数据
-- ============================================================

-- 默认管理员账户（密码：123456，BCrypt哈希）
INSERT INTO user (username, password, name, phone, role) VALUES
('admin', '$2b$10$jpt0J5bOmV7i6YykB5ksPOswovInGCdLPjaCw.p5Ot0sCWwJqC0Lm', '管理员', '13800138000', 'admin');

-- 示例用户（密码均为 123456）
INSERT INTO user (username, password, name, phone, role) VALUES
('user1', '$2b$10$ai2s/8AWDB89Y1D0T5PFA.rykFS5p4UIfdbRymdiN3htzWIwgukBi', '张三', '13800138001', 'user'),
('user2', '$2b$10$GPYjX1lOzVpCFn0y3NBuFubXjgSaOEY9tVLKNc8PHW/xl5N8eqGo.', '李四', '13800138002', 'user'),
('user3', '$2b$10$AHo1fHJ9.I7FRZUasgAejuD3ywqBhYqP3snpqNf833JyqZNmv/iYe', '王五', '13800138003', 'user');

-- 示例图书
INSERT INTO book (name, author, isbn, stock, type, status, description) VALUES
('Java核心技术', 'Cay S. Horstmann', '9787111272258', 5, '计算机', 1, '《JAVA核心技术》出版以来，一直备受广大Java程序员的青睐，畅销不衰。'),
('深入理解Java虚拟机', '周志明', '9787111272259', 3, '计算机', 1, '本书共分为五大部分，围绕内存管理、执行子系统、程序编译与优化、高效并发等核心主题对JVM进行了全面而深入的分析。'),
('设计模式', 'Gang of Four', '9787111272260', 2, '计算机', 1, '设计模式是程序员必备的知识，这本书是设计模式领域的经典之作。'),
('算法导论', 'Thomas H. Cormen', '9787111272261', 4, '计算机', 1, '本书提供了对当代计算机算法研究的一个全面、综合性的介绍。'),
('重构:改善既有代码的设计', 'Martin Fowler', '9787111272262', 2, '计算机', 1, '本书清晰揭示了重构的过程，解释了重构的原理和最佳实践方式。'),
('活着', '余华', '9787111272263', 6, '文学', 1, '《活着》讲述了农村人福贵悲惨的人生遭遇。'),
('百年孤独', '加西亚·马尔克斯', '9787111272264', 3, '文学', 1, '《百年孤独》是诺贝尔文学奖获得者加西亚·马尔克斯的代表作。'),
('三体', '刘慈欣', '9787111272265', 5, '科幻', 1, '《三体》是刘慈欣创作的系列长篇科幻小说。'),
('人类简史', '尤瓦尔·赫拉利', '9787111272266', 4, '历史', 1, '《人类简史》是以色列作家尤瓦尔·赫拉利创作的历史类著作。'),
('明朝那些事儿', '当年明月', '9787111272267', 7, '历史', 1, '《明朝那些事儿》由当年明月所著，讲述了从1344年到1644年这三百年间关于明朝的一些故事。');

-- 示例借阅记录
-- 管理员的借阅记录
INSERT INTO borrow (book_id, user_id, due_time, status) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 7 DAY), 0),   -- 逾期7天
(2, 1, DATE_ADD(NOW(), INTERVAL 3 DAY), 0),    -- 未逾期
(3, 1, DATE_SUB(NOW(), INTERVAL 12 DAY), 1);   -- 已归还

-- 张三的借阅记录
INSERT INTO borrow (book_id, user_id, due_time, status) VALUES
(4, 2, DATE_SUB(NOW(), INTERVAL 5 DAY), 0),    -- 逾期5天
(5, 2, DATE_ADD(NOW(), INTERVAL 2 DAY), 0),     -- 未逾期
(6, 2, DATE_SUB(NOW(), INTERVAL 10 DAY), 1);    -- 已归还

-- 李四的借阅记录
INSERT INTO borrow (book_id, user_id, due_time, status) VALUES
(7, 3, DATE_SUB(NOW(), INTERVAL 3 DAY), 0),    -- 逾期3天
(8, 3, DATE_ADD(NOW(), INTERVAL 5 DAY), 0),     -- 未逾期
(9, 3, DATE_SUB(NOW(), INTERVAL 15 DAY), 1);    -- 已归还

-- 王五的借阅记录
INSERT INTO borrow (book_id, user_id, due_time, status) VALUES
(10, 4, DATE_ADD(NOW(), INTERVAL 7 DAY), 0),    -- 未逾期
(1, 4, DATE_ADD(NOW(), INTERVAL 3 DAY), 0),     -- 未逾期
(2, 4, DATE_SUB(NOW(), INTERVAL 20 DAY), 1);    -- 已归还

SELECT '数据库初始化完成!' AS 'Message';
