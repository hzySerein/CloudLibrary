# CloudLibrary - 云借阅图书管理系统 / Cloud Library Management System

[中文](#中文说明) | [English](#english-description)

---

## 中文说明

`CloudLibrary` 是一个基于经典的 **SSM (Spring + Spring MVC + MyBatis)** 架构开发的云借阅图书管理系统。该项目具有现代化的 UI 界面与交互动效，提供完善的图书、读者、借阅以及系统统计管理功能。

### 🌟 核心功能

#### 👥 读者面板
*   **图书借阅申请**：分页浏览馆藏图书，支持关键词搜索，一键提交借阅申请并设定预计归还日期。
*   **热门图书排行榜**：实时查看最受欢迎的前 10 本图书。
*   **个人借阅历史**：跟踪已借阅、待确认归还及已归还的借阅记录，查看逾期状态与逾期天数。
*   **归还申请**：一键提交归还请求，等待管理员审核。
*   **个人信息修改**：支持修改真实姓名、联系电话以及修改登录密码。

#### 👨‍💼 管理员面板
*   **系统数据大屏 (Dashboard)**：
    *   实时汇总系统指标（总图书、总用户、总借阅量、待归还量）。
    *   统计图表显示图书类型分布比例以及近 6 个月的借阅趋势。
    *   展示热门图书排行（Top 10）和活跃读者排行（Top 10）。
*   **图书管理**：图书的增删改查（支持上传/更新图书封面图片、启用/禁用图书）。若图书处于借阅中则禁止删除。
*   **用户管理**：读者账号的注册、修改与删除。
*   **借阅审核与归还确认**：处理普通读者的借阅/归还流程。确认归还后自动恢复对应图书的库存。
*   **逾期催还**：单独展示所有逾期未还的记录及逾期天数，方便管理员催还。

### 🛠️ 技术栈
*   **后端**：Spring Framework 5.3.x, Spring MVC, MyBatis 3.5.x
*   **数据库**：MySQL 8.0, Druid 数据源
*   **安全/加密**：`jbcrypt` 密码加密哈希，全局 `CsrfFilter` 抵御跨站请求伪造，`SecurityHeaderFilter` 增强 HTTP 响应头安全。
*   **前端**：JSP, JSTL, 原生 CSS 变量与动画（现代 Bootstrap 风格主题）。

### 🚀 快速启动

1.  **数据库初始化**：
    导入 [database/cloudlibrary_full_schema.sql](file:///d:/Code/Develop/cloudlibrary/database/cloudlibrary_full_schema.sql) 文件到您的 MySQL 数据库中。
2.  **配置修改**：
    编辑 [src/main/resources/jdbc.properties](file:///d:/Code/Develop/cloudlibrary/src/main/resources/jdbc.properties)，配置您的数据库连接 URL、用户名和密码：
    ```properties
    jdbc.driver=com.mysql.cj.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/cloudlibrary?useSSL=false&serverTimezone=UTC
    jdbc.username=your_username
    jdbc.password=your_password
    ```
3.  **编译打包**：
    ```bash
    mvn clean package
    ```
4.  **部署运行**：
    将生成的 `target/cloudlibrary.war` 部署到 **Apache Tomcat 9.0+** 中，或者在 IntelliJ IDEA 中配置本地 Tomcat Server 运行。

#### 🔑 初始测试账号（密码均为 `123456`）
*   **管理员**：`admin`
*   **普通用户**：`user1`、`user2`、`user3`

---

## English Description

`CloudLibrary` is a cloud-based library management system built on the classic **SSM (Spring + Spring MVC + MyBatis)** framework. It features a modern, clean UI design with responsive CSS transitions, providing comprehensive capabilities for book catalogs, reader profiles, borrow workflows, and admin system statistics.

### 🌟 Key Features

#### 👥 Reader (User) Panel
*   **Book Catalog & Request**: Paginated view of available books, keywords search, and online borrow requests with selectable due dates.
*   **Popular Rankings**: Real-time display of the Top 10 most borrowed books.
*   **Borrow History**: Track borrow logs (borrowed, pending return confirmation, returned) with calculated overdue days.
*   **Return Request**: Submit return requests for admin approval.
*   **Profile Management**: Update name, phone number, and change passwords securely.

#### 👨‍💼 Admin Panel
*   **System Dashboard**:
    *   Aggregate counters (total books, users, borrows, unreturned).
    *   Graphical ratios of book types and borrowing trends over the last 6 months.
    *   Leaderboards for popular books (Top 10) and active readers (Top 10).
*   **Book Management**: CRUD operations on books (supports cover image uploads, toggling availability status).
*   **User Management**: Register, modify, or delete reader accounts.
*   **Workflow Auditing**: Confirm returned books to restore stock inventory automatically.
*   **Overdue Tracking**: List all overdue records and overdue days.

### 🛠️ Tech Stack
*   **Backend**: Spring Framework 5.3.x, Spring MVC, MyBatis 3.5.x
*   **Database**: MySQL 8.0, Druid Connection Pool
*   **Security**: `jbcrypt` password hashing, global `CsrfFilter` for CSRF defense, `SecurityHeaderFilter` for secure HTTP headers.
*   **Frontend**: JSP, JSTL, Vanilla CSS with custom properties & transitions (Modern Bootstrap-like styling).

### 🚀 Quick Start

1.  **Initialize Database**:
    Import the [database/cloudlibrary_full_schema.sql](file:///d:/Code/Develop/cloudlibrary/database/cloudlibrary_full_schema.sql) file into your local MySQL database.
2.  **Configuration**:
    Modify [src/main/resources/jdbc.properties](file:///d:/Code/Develop/cloudlibrary/src/main/resources/jdbc.properties) to set your MySQL URL, username, and password:
    ```properties
    jdbc.driver=com.mysql.cj.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/cloudlibrary?useSSL=false&serverTimezone=UTC
    jdbc.username=your_username
    jdbc.password=your_password
    ```
3.  **Build & Package**:
    ```bash
    mvn clean package
    ```
4.  **Deploy**:
    Deploy the compiled `target/cloudlibrary.war` file to **Apache Tomcat 9.0+**, or configure a local Tomcat Server run profile in IntelliJ IDEA.

#### 🔑 Initial Accounts (Passwords are all `123456`)
*   **Administrator**: `admin`
*   **Regular Users**: `user1`, `user2`, `user3`
