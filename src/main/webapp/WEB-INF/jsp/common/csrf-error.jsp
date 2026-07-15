<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>请求被拒绝 - 云借阅图书管理系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Microsoft Yahei", "PingFang SC", sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-card {
            background: white;
            border-radius: 16px;
            padding: 50px 40px;
            max-width: 480px;
            width: 90%;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .error-icon {
            font-size: 72px;
            margin-bottom: 20px;
        }
        .error-code {
            font-size: 48px;
            font-weight: 700;
            color: #e74c3c;
            margin-bottom: 10px;
        }
        .error-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 16px;
        }
        .error-message {
            font-size: 15px;
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .btn-group {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        .btn {
            padding: 12px 28px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-outline {
            background: transparent;
            color: #666;
            border: 2px solid #ddd;
        }
        .btn-outline:hover {
            border-color: #999;
            color: #333;
        }
    </style>
</head>
<body>
<div class="error-card">
    <div class="error-icon">🔒</div>
    <div class="error-code">403</div>
    <div class="error-title">请求被拒绝</div>
    <div class="error-message">
        ${not empty errorMsg ? errorMsg : '您的请求未能通过安全验证，可能是页面已过期或请求来源不合法。请返回上一页重试。'}
    </div>
    <div class="btn-group">
        <a href="javascript:history.back()" class="btn btn-outline">返回上一页</a>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">回到首页</a>
    </div>
</div>
</body>
</html>
