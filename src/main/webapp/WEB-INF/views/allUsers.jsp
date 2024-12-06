<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Title</title>
</head>
<body>


<div class="my-16 bg-gradient-to-r from-cyan-500 to-blue-500 ...">
    <h1 class="py-8 text-center text-white text-xl font-medium">LIST OF USERS</h1>
</div>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 p-4">

    <c:forEach items="${ users }" var="user" varStatus="status">
        <div
                class="py-8 px-4 max-w-sm mx-auto bg-white rounded-xl shadow-lg space-y-2 sm:py-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-6">

            <img class="block mx-auto h-24 rounded-full sm:mx-0 sm:shrink-0"
                 src="https://th.bing.com/th/id/OIP.PoS7waY4-VeqgNuBSxVUogAAAA?rs=1&pid=ImgDetMain" alt="Face">

                <div class="text-center space-y-2 sm:text-left">
                <div class="space-y-0.5">
                    <p class="text-sm text-black font-semibold">
                        <c:out value="${user.firstName.toUpperCase()}"/> <c:out value="${user.lastName.toUpperCase()}"/>
                    </p>
                    <p class="text-slate-500 text-xs font-medium">
                        Username: <c:out value="${user.username}"/>
                    </p>
                    <p class="text-[8px]">Membre Since: <c:out value="${user.registeredAt}"/></p>

                </div>
                <span class="inline-flex items-center m-2 px-3 py-1 rounded-md text-xs font-semibold
                <c:choose>
                    <c:when test="${user.role == 'INDIVIDUAL'}">
                            bg-green-200 hover:bg-green-300 text-green-600
                    </c:when>
                    <c:when test="${user.role == 'MANAGER'}">
                             bg-red-200 hover:bg-red-300 text-red-600
                    </c:when>
                    <c:when test="${user.role == 'TEAMLEADER'}">
                             bg-blue-200 hover:bg-blue-300 text-blue-600
                    </c:when>
                    <c:otherwise>
                             bg-gray-200 hover:bg-gray-300 text-gray-600
                    </c:otherwise>
                 </c:choose>
                            ">
	<span class="ml-1">
	  <c:out value="${user.role}"/>
	</span>
  </span></div>
        </div>
    </c:forEach>
</div>


</body>
</html>
