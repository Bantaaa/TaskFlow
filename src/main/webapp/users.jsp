<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>User Management - DevSync</title>
</head>
<body>
<h1>User Management</h1>

<h2>User List</h2>
<ul>
    <c:forEach items="${users}" var="user">
        <li>${user.username} - ${user.email}</li>
    </c:forEach>
</ul>

<h2>Create New User</h2>
<form action="${pageContext.request.contextPath}/users" method="post">
    Username: <input type="text" name="username" required><br>
    Password: <input type="password" name="password" required><br>
    First Name: <input type="text" name="firstName"><br>
    Last Name: <input type="text" name="lastName"><br>
    Email: <input type="email" name="email" required><br>
    <input type="submit" value="Create User">
</form>
</body>
</html>