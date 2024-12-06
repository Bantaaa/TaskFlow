<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:if test="${sessionScope.user == null}">
  <c:redirect url="auth?form=login" />
</c:if>
<!DOCTYPE html>
<html>
<head>
  <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %></h1>
<br/>
<a href="${pageContext.request.contextPath}/users">SHOW USERS</a>
<br>
<a href="${pageContext.request.contextPath}/users?id=1">SHOW PROFILE</a>
<br>
<form action="auth" method="POST">
  <input type="hidden" name="form" value="logout" />
  <button type="submit">Logout</button>
</form>

</body>
</html>

