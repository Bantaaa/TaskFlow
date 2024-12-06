<%@ page import="java.time.LocalDateTime" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="auth?form=login" />
</c:if>

<c:if test="${sessionScope.user.role == 'INDIVIDUAL'}">
    <c:redirect url="home" />
</c:if>
<body class="bg-gradient-to-r from-slate-50 to-sky-50">
<c:set var="now" value="<%= LocalDateTime.now() %>" />

<jsp:include page="includes/navbar.jsp"/>

<h1 class="pt-4 px-12 text-2xl font-semibold text-teal-800">Task Change Requests </h1>
<p class="text-[10px] px-12">all the tasks that the idividuals request to change, simplifying the complexities of task management for individuals, team leaders, and managers in dynamic work environments.</p>
<c:if test="${not empty sessionScope.error}">
    <div id="toast-danger" class="mx-24 flex absolute z-50 items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800" role="alert">
        <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-red-500 bg-red-100 rounded-lg dark:bg-red-800 dark:text-red-200">
            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 11.793a1 1 0 1 1-1.414 1.414L10 11.414l-2.293 2.293a1 1 0 0 1-1.414-1.414L8.586 10 6.293 7.707a1 1 0 0 1 1.414-1.414L10 8.586l2.293-2.293a1 1 0 0 1 1.414 1.414L11.414 10l2.293 2.293Z"/>
            </svg>
            <span class="sr-only">Error icon</span>
        </div>
        <div class="ms-3 text-sm font-normal">${sessionScope.error}</div>

        <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" data-dismiss-target="#toast-danger" aria-label="Close">

            <span class="sr-only">Close</span>
            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
            </svg>
        </button>
    </div>
    <c:remove var="error" scope="session" />
</c:if>
<div class="p-8 flex  flex-wrap">


    <c:choose>
        <c:when test="${empty unApprovedRequests}">
            <c:out value="No Requests Today!"/>
        </c:when>
        <c:otherwise>
            <div class="relative mx-2 overflow-x-auto">
                <table class="w-auto text-[10px] text-left rtl:text-right text-gray-500 dark:text-gray-400">
                    <thead class=" uppercase bg-slate-50  dark:text-gray-400">
                    <tr>
                        <th scope="col" class="px-6 text-teal-800 py-3 rounded-s-lg">
                            Request By
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3">
                            Changed Task
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3">
                            Changed Task Due Date
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3">
                            New Task
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3 rounded-e-lg">
                            Requested
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3 rounded-e-lg">
                            Assign To Another
                        </th>
                        <th scope="col" class="px-6 text-teal-800 py-3 rounded-e-lg">
                            Approve
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${unApprovedRequests}" var="rqust">
                        <tr class="bg-white dark:bg-gray-800">
                            <th scope="row" class="px-6 py-4 font-medium text-gray-700 whitespace-nowrap dark:text-white">
                                <c:out value="${rqust.requestedBy.firstName}" />
                                <c:out value="${rqust.requestedBy.lastName}" />
                            </th>
                            <td class="px-6 py-4">
                                <c:out value="${rqust.oldtask.title}" />
                            </td>
                            <td class="px-6 py-4">
                                <button  data-modal-target="progress-modal" data-modal-toggle="progress-modal" class="inline-flex mx-4 items-center px-3 h-4 bg-gray-100 hover:bg-gray-300 text-gray-800  rounded-sm">
                                    <c:out value="${rqust.oldtask.dueDate.toLocalDate()}" />
                                </button>
                            </td>
                            <td class="px-6 py-4">
                                <c:out value="${rqust.newtask.title}" />
                            </td>
                            <td class="px-6 py-4">
                                <c:out value="${rqust.hoursDiff} Hours Ago"/>
                            </td>
                            <form action="task" method="post">
                                <input type="hidden" name="action" value="approveRequest">
                                <input type="hidden" name="rqustId" value="${rqust.id}">
                                <td class="px-6 py-4">
                                    <label for="underline_select" class="sr-only">Underline select</label>
                                    <select name="newUserId" id="underline_select" class="block py-1.5 px-2 w-full text-[12px] text-gray-500 bg-transparent border-0 border-b-2 border-gray-200 appearance-none dark:text-gray-400 dark:border-gray-700 focus:outline-none focus:ring-0 focus:border-gray-100 peer">
                                        <c:forEach items="${users}" var="user">
                                            <c:if test="${user.id ne rqust.requestedBy.id}">
                                                <option value="${user.id}">
                                                    <c:out value="${user.firstName}" /> <c:out value="${user.lastName}" />
                                                </option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </td>

                                <td class="px-6 py-4">
                                    <button type="submit">
                                        <img width="24" height="24" src="https://img.icons8.com/ios-glyphs/30/12B886/checked--v1.png" alt="checked--v1"/>
                                    </button>
                                </td>
                            </form>


                        </tr>



                        <div id="progress-modal" tabindex="-1" aria-hidden="true" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
                            <div class="relative p-4 w-full max-w-md max-h-full">
                                <!-- Modal content -->
                                <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                                    <button type="button" class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="progress-modal">
                                        <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                        </svg>
                                        <span class="sr-only">Close modal</span>
                                    </button>
                                    <div class="p-4 md:p-5">
                                        <h3 class="mb-3 text-xl font-bold text-gray-900 dark:text-white">Changing Task Deadline</h3>
                                        <form action="task" method="post">
                                            <input type="hidden" name="action" value="updateTaskDeadline">
                                            <input type="hidden" name="taskId" value="${rqust.oldtask.id}">

                                            <div class="relative p-4 z-0 w-full mb-5 group">
                                                <input type="datetime-local" class="block w-full py-2.5 px-0 text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer" id="dueDate" name="dueDate" required />
                                                <label for="dueDate" class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Due Date</label>
                                            </div>

                                            <button type="submit" class="bg-slate-700 px-4 py-2">CHANGE</button>

                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </c:forEach>
                    </tbody>
                </table>
            </div>

        </c:otherwise>




    </c:choose>


</div>




<script>
    document.addEventListener('DOMContentLoaded', function() {
        var now = new Date().toISOString().slice(0, 16);
        document.getElementById('dueDate').min = now;
    });
</script>
</body>

