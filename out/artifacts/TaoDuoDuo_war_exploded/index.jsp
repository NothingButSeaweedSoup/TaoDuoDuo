<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2025/12/4
  Time: 08:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品查询</title>
</head>
<body>
<%--测试用--%>
<form method="get" action="${pageContext.request.contextPath}/ProductDetailServlet">
    <label for="id">商品ID:</label>
    <input type="number" id="id" name="id" required>
    <input type="submit" value="查看商品详情">
</form>
</body>
</html>
