<%@ page import="java.time.LocalDateTime" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${sessionScope.user == null}">
    <c:redirect url="auth?form=login" />
</c:if>
<body class="bg-gradient-to-r from-slate-50 to-sky-50">
<c:set var="now" value="<%= LocalDateTime.now() %>" />

<jsp:include page="includes/navbar.jsp"/>

<h1 class="pt-4 px-12 text-2xl font-semibold text-teal-800">Dashboard </h1>
<p class="text-[10px] px-12">Enhanced collaboration and project success, aimed at simplifying the complexities of task management for individuals, team leaders, and managers in dynamic work environments.</p>

<div class="p-1 flex  flex-wrap items-center justify-center">


    <div class="flex-shrink-0 m-4 relative overflow-hidden bg-teal-800 rounded-lg max-w-3xl shadow-lg group" style="flex-basis: 75%; flex-grow: 1;">
        <svg class="absolute bottom-0 left-0 mb-8 scale-150 group-hover:scale-[1.65] transition-transform" viewBox="0 0 375 283" fill="none"
             style="opacity: 0.1;">
            <rect x="159.52" y="175" width="152" height="152" rx="8" transform="rotate(-45 159.52 175)" fill="white" />
            <rect y="107.48" width="152" height="152" rx="8" transform="rotate(-45 0 107.48)" fill="white" />
        </svg>
        <div class="relative pt-10 px-10 flex items-center justify-center group-hover:scale-110 transition-transform">
            <div class="block absolute w-48 h-48 bottom-0 left-0 -mb-24 ml-3"
                 style="background: radial-gradient(black, transparent 0%); transform: rotate3d(0, 0, 1, 20deg) scale3d(1, 0.6, 1); opacity: 0.2;">
            </div>
        </div>
        <div class="relative text-white px-6 pb-6 mt-6">
            <span class="block opacity-75 -mb-1">Home For Your Tasks Management Tools</span>
            <div class="flex justify-between">
                <span class="block font-semibold text-xl">DEVSYNC</span>
                <button data-modal-target="top-right-modal" data-modal-toggle="top-right-modal" class="mt-4 block bg-white rounded-full text-teal-500 text-xs font-bold px-3 py-2 leading-none flex items-center">ADD NEW TASK</button>
            </div>
        </div>
    </div>


    <div class="flex-basis-0 m-4 relative overflow-hidden bg-yellow-400 rounded-lg max-w-sm  shadow-xs group" style="flex-basis: 25%; flex-grow: 1;">
        <svg class="absolute bottom-0 left-0 mb-8 scale-150 group-hover:scale-[1.65] transition-transform"
             viewBox="0 0 375 283" fill="none" style="opacity: 0.1;">
            <rect x="159.52" y="175" width="152" height="152" rx="8" transform="rotate(-45 159.52 175)" fill="white" />
            <rect y="107.48" width="152" height="152" rx="8" transform="rotate(-45 0 107.48)" fill="white" />
        </svg>
        <div class="relative pt-10 px-10 flex items-center justify-center group-hover:scale-110 transition-transform">
            <div class="block absolute w-48 h-48 bottom-0 left-0 -mb-24 ml-3"
                 style="background: radial-gradient(black, transparent 0%); transform: rotate3d(0, 0, 1, 20deg) scale3d(1, 0.6, 1); opacity: 0.2;">
            </div>
        </div>
        <div class="relative text-white px-6 pb-6 mt-6">
            <span class="block opacity-75 -mb-1">Project Time Frame</span>
            <div class="flex justify-between">
                <span class="block font-semibold text-xl">Exclusive Tools</span>
                <span class="block bg-white rounded-full text-yellow-500 text-xs font-bold px-3 py-2 leading-none flex items-center mt-4">CHECK TOOLS</span>
            </div>
        </div>
    </div>


    <div id="top-right-modal" data-modal-placement="top-right" tabindex="-1" class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto md:inset-0 h-[calc(100%-1rem)] max-h-full">
        <div class="relative w-full max-w-2xl max-h-full">
            <!-- Modal content -->
            <div class="relative bg-white rounded-sm shadow dark:bg-gray-700">
                <!-- Modal header -->
                <div class="flex items-center justify-between p-4 md:p-5  rounded-t dark:border-gray-600">
                    <h3 class="text-xl font-medium text-gray-900 dark:text-white">
                        Add New Task
                    </h3>
                    <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="top-right-modal">
                        <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                        </svg>
                        <span class="sr-only">Close modal</span>
                    </button>
                </div>
                <!-- Modal body -->
                <div class=" md:p-5 space-y-4">
                    <form action="task" method="post" class="max-w-xl mx-auto">
                        <input type="hidden" name="action" value="add" />
                        <div class="relative z-0 w-full mb-5 group">
                            <input type="text" name="title" id="floating_title" class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder=" " required />
                            <label for="floating_title" class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Title</label>
                        </div>
                        <div class="relative z-0 w-full mb-5 group">
                            <textarea name="description" id="floating_description" class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer" placeholder=" " required></textarea>
                            <label for="floating_description" class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:start-0 rtl:peer-focus:translate-x-1/4 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Description</label>
                        </div>
                        <div class="relative z-0 w-full mb-5 group">
                            <input type="datetime-local" class="block w-full py-2.5 px-0 text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none focus:outline-none focus:ring-0 focus:border-blue-600 peer" id="dueDate" name="dueDate" required />
                            <label for="dueDate" class="peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6">Due Date</label>
                        </div>

                       <div class="mb-2">

                           <label class="block text-gray-600  text-sm mb-2" for="multipleSelect">
                               Select multiple Tags:
                           </label>
                           <select id="multipleSelect" name="selectedTags" multiple class="chosen-select">
                               <c:forEach items="${tags}" var="tag">
                                   <option value="${tag.id}">${tag.name}</option>
                               </c:forEach>
                           </select>
                       </div>


                        <button type="submit" class="text-white bg-blue-900  focus:ring-0 focus:outline-none focus:ring-slate-300 font-medium rounded-md text-sm w-full sm:w-auto px-5 py-2.5 text-center ">ADD</button>
                    </form>

                </div>
            </div>
        </div>
    </div>

</div>




<div class="grid grid-cols-3 gap-1">
    <div class="... pl-6 mt-8">

        <h2 class="py-2 text-lg font-semibold text-teal-800">Your Tasks</h2>


        <div class="relative h-auto  sm:rounded-lg">
            <table class="w-auto text-left rtl:text-right text-gray-500 dark:text-gray-400">
                <thead class="text-[10px] text-gray-700 uppercase dark:text-gray-400">
                <tr>
                    <th scope="col" class="px-4 bg-gray-50 dark:bg-gray-800">
                        Task Description
                    </th>
                    <th scope="col" class="px-4 text-md py-3">
                        Due Date
                    </th>
                    <th scope="col" class="px-4 py-3 bg-gray-50 dark:bg-gray-800">
                        Status
                    </th>
                    <th scope="col" class="px-4 py-3">
                        Assigned To
                    </th>
                </tr>
                </thead>
                <tbody class="text-[10px]">
<c:forEach items="${ tasks }" var="task" varStatus="status">

<c:if test="${!task.dueDate.isBefore(now)}">
<tr class="border-b border-gray-200 dark:border-gray-700">
                    <td scope="row" class="pl-2 text-[9px] text-gray-900 whitespace-nowrap bg-gray-50 dark:text-white dark:bg-gray-800">
                        <c:choose>
                        <c:when test="${fn:length(task.description) > 25}">
                            <c:out value="${fn:substring(task.description, 0, 25)}"/>...
                        </c:when>
                        <c:otherwise>
                            <c:out value="${task.description}"/>
                        </c:otherwise>
                    </c:choose>
                        <button data-popover-target="pop${task.id}" data-popover-placement="bottom-end" type="button">.<span class="sr-only">Show information</span></button></p>
                        <div data-popover id="pop${task.id}" role="tooltip" class="absolute z-10 w-auto invisible inline-block text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 w-72 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-400">
                            <div class="p-3 space-y-2">
                                <p class="text-[8px]">${task.description}</p>
                            </div>
                            <div data-popper-arrow></div>
                        </div>
                    </td>
                    <td class="px-4 py-3">
                        <c:out value="${taskRemainingDays[task]} Days"/>
                    </td>
                    <td class="px-4 py-3 bg-gray-50 dark:bg-gray-800">
                        <c:choose>
                            <c:when test="${task.dueDate.isBefore(now)}">
                                <span class="bg-gray-100 text-gray-800 text-[7px] font-medium inline-flex items-center px-0.5 py-0.5 rounded  dark:bg-gray-700 dark:text-gray-400 border border-gray-500 ">
<svg class="w-2.5 h-2.5 me-1.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
<path d="M10 0a10 10 0 1 0 10 10A10.011 10.011 0 0 0 10 0Zm3.982 13.982a1 1 0 0 1-1.414 0l-3.274-3.274A1.012 1.012 0 0 1 9 10V6a1 1 0 0 1 2 0v3.586l2.982 2.982a1 1 0 0 1 0 1.414Z"/>
</svg>
<c:out value="OVERDUE"/>
</span>

                            </c:when>
                            <c:otherwise>

                        <span class="inline-flex items-center  px-2 rounded-lg text-xs font-semibold
                <c:choose>
                    <c:when test="${task.status == 'ONGOING'}">
                            bg-green-200 hover:bg-green-300 text-green-600
                    </c:when>
                    <c:when test="${task.status == 'TODO'}">
                             bg-red-200 hover:bg-red-300 text-red-600
                    </c:when>
                    <c:when test="${task.status == 'COMPLETED'}">
                             bg-blue-200 hover:bg-blue-300 text-blue-600
                    </c:when>

                    <c:otherwise>
                             bg-gray-200 hover:bg-gray-300 text-gray-600
                    </c:otherwise>
                 </c:choose>
                            ">
                            <span class="text-[8px]">
	  <c:out value="${task.status}"/>
	</span>
  </span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="px-4 py-3">
                        <c:choose>
                            <c:when test="${task.assignee == null}">
                                <c:out value="No one"/>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${task.assignee.username}"/>
                            </c:otherwise>
                        </c:choose>


                    </td>
                </tr>
</c:if>
</c:forEach>

                </tbody>
            </table>
        </div>


        <h2 class="py-2 mt-8 text-lg font-semibold text-teal-800">Uncompleted Tasks</h2>

        <div class="relative h-auto  sm:rounded-lg">
            <table class="w-auto text-left rtl:text-right text-gray-500 dark:text-gray-400">
                <thead class="text-[10px] text-gray-700 uppercase dark:text-gray-400">
                <tr>
                    <th scope="col" class="px-4 bg-gray-50 dark:bg-gray-800">
                        Task Description
                    </th>
                    <th scope="col" class="px-4 py-3 bg-gray-50 dark:bg-gray-800">
                        Status
                    </th>
                    <th scope="col" class="px-4 py-3">
                        Assigned To
                    </th>
                </tr>
                </thead>
                <tbody class="text-[10px]">
                <c:forEach items="${ tasks }" var="task" varStatus="status">

                    <c:if test="${task.dueDate.isBefore(now) and task.status == 'UNCOMPLETED'}">
                        <tr class="border-b border-gray-200 dark:border-gray-700">
                            <td scope="row" class="pl-2 text-[9px] text-gray-900 whitespace-nowrap bg-gray-50 dark:text-white dark:bg-gray-800">
                                <c:choose>
                                    <c:when test="${fn:length(task.description) > 25}">
                                        <c:out value="${fn:substring(task.description, 0, 25)}"/>...
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${task.description}"/>
                                    </c:otherwise>
                                </c:choose>
                                <button data-popover-target="pop${task.id}" data-popover-placement="bottom-end" type="button">.<span class="sr-only">Show information</span></button></p>
                                <div data-popover id="pop${task.id}" role="tooltip" class="absolute z-10 w-auto invisible inline-block text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 w-72 dark:bg-gray-800 dark:border-gray-600 dark:text-gray-400">
                                    <div class="p-3 space-y-2">
                                        <p class="text-[8px]">${task.description}</p>
                                    </div>
                                    <div data-popper-arrow></div>
                                </div>
                            </td>
                            <td class="px-4 py-3 bg-gray-50 dark:bg-gray-800">


                        <span class="inline-flex bg-gray-200 items-center  px-2 rounded-lg text-xs font-semibold">
                            <span class="text-[8px]">
	  <c:out value="${task.status}"/>
	</span>
  </span>

                            </td>
                            <td class="px-4 py-3">
                                <c:choose>
                                    <c:when test="${task.assignee == null}">
                                        <c:out value="No one"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${task.assignee.username}"/>
                                    </c:otherwise>
                                </c:choose>


                            </td>
                        </tr>
                    </c:if>
                </c:forEach>

                </tbody>
            </table>
        </div>


    </div>
    <div class="col-span-2 ... relative px-8 bg-slate-50 rounded-xl  min-h-72 shadow-sky-200 m-8">
        <c:if test="${not empty sessionScope.error}">
            <div id="toast-danger" class="flex absolute z-50 items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800" role="alert">
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

        <c:if test="${not empty sessionScope.taskRequestSuccess}">
            <div id="toast-success" class="flex items-center w-full max-w-xs p-4 mb-4 text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800" role="alert">
                <div class="inline-flex items-center justify-center flex-shrink-0 w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-800 dark:text-green-200">
                    <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5Zm3.707 8.207-4 4a1 1 0 0 1-1.414 0l-2-2a1 1 0 0 1 1.414-1.414L9 10.586l3.293-3.293a1 1 0 0 1 1.414 1.414Z"/>
                    </svg>
                    <span class="sr-only">Check icon</span>
                </div>
                <div class="ms-3 text-sm font-normal">${sessionScope.taskRequestSuccess}</div>
                <button type="button" class="ms-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex items-center justify-center h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700" data-dismiss-target="#toast-success" aria-label="Close">
                    <span class="sr-only">Close</span>
                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                    </svg>
                </button>
            </div>
            <c:remove var="taskRequestSuccess" scope="session" />
        </c:if>



        <h2 class="py-3  text-lg font-semibold text-teal-800">Your Board</h2>
        <div class="grid grid-cols-3 h-[450px] overflow-y-auto gap-4 min-h-96">
            <div class="bg-teal-50/50 max-h-screen" id="todo-column">
                <div class="bg-slate-50 px-4 pb-2">
                    <span class="bg-red-400 text-red-800 text-xs font-medium me-2 px-1.5 rounded-full dark:bg-red-900 dark:text-red-300"></span>
                    <span class="font-semibold text-xs">To Do</span>
                </div>

<c:forEach items="${ tasks }" var="task" varStatus="status">

    <c:if test="${task.status == 'TODO'}">

        <div class="">
            <div class="relative  max-w-sm max-h-lg min-h-md shadow-lg  draggable-card mb-[12px]" id="card-${task.id}">

                <c:choose>
                    <c:when test="${task.refused and user.role == 'INDIVIDUAL'}">

                    </c:when>
                    <c:otherwise>
                        <button data-modal-target="popup-mod${task.id}" data-modal-toggle="popup-mod${task.id}"  type="button" class="absolute hover:bg-red-400 top-0 right-0 z-10 text-white bg-transparent  focus:ring-0 focus:ring-blue-300 font-medium  text-sm px-2 py-1  mb-2 dark:bg-blue-600  focus:outline-none dark:focus:ring-blue-800">
                            <img width="10" height="10" src="https://img.icons8.com/ios-filled/50/delete-sign--v1.png" alt="delete-sign--v1"/>
                        </button>
                    </c:otherwise>
                </c:choose>


    <div class="relative h-32 p-2  bg-white border-l-4 border-red-500 ">
                    <div class="flex items-center -mt-1">
                        <h3 class="ml-3 text-xs font-bold text-gray-800"><c:out value="${task.title}" /></h3>
                    </div>
                    <p class=" text-[9px]  text-gray-600"><c:out value="${fn:substring(task.description, 0, 70)}"/></p>

        <div class="flex items-center space-x-4 absolute bottom-1 ">
            <c:if test="${!task.dueDate.isBefore(now)}">


            <button class="inline-flex mt-[2px] items-center px-1 h-4 bg-gray-200 hover:bg-gray-300 text-gray-800 text-[9px] rounded-sm">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                                </svg>
                                <c:out value="${task.dueDate.toLocalDate()}" />
                            </button>

                        <div class="flex gap-1 items-center">
                            <c:choose>
                            <c:when test="${not empty task.assignee}">
                            <div class="flex-shrink-0">
                                <img class="w-4 h-4 rounded-full" src="https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" alt="Default Avatar">
                            </div>
                            <div class="flex-1 min-w-0">

                                        <p class="text-[9px] font-medium text-gray-900 truncate dark:text-white">
                                                ${task.assignee.firstName.toUpperCase()} ${task.assignee.lastName.toUpperCase()}
                                        </p>
                                        <p class="text-[7px] text-gray-500 truncate dark:text-gray-400">
                                                ${task.assignee.role}
                                        </p>

                            </div>
                            </c:when>
                                <c:otherwise>
                                    <p class="text-[8px] ml-4 font-bold  text-red-900 truncate dark:text-white">
                                        Assign To Someone
                                    </p>
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${task.refused and user.role == 'INDIVIDUAL'}">

                                </c:when>
                                <c:otherwise>
                                    <button id="dropdownUsersButton-${task.id}" data-dropdown-toggle="dropdownUsers-${task.id}" data-dropdown-placement="bottom"
                                            class="bg-transparent focus:ring-0  font-medium rounded-lg text-sm inline-flex items-center">
                                        <svg class="w-2.5 h-2.5 " aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                                            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4" />
                                        </svg>
                                    </button>
                                </c:otherwise>
                            </c:choose>




                            <!-- Dropdown menu -->
                            <div id="dropdownUsers-${task.id}" class="z-50 hidden bg-white rounded-lg shadow w-60 dark:bg-gray-700">
                                <ul class="h-auto py-2 overflow-y-auto text-gray-700 dark:text-gray-200" aria-labelledby="dropdownUsersButton-${task.id}">
                                    <c:choose>
                                        <c:when test="${user.role == 'INDIVIDUAL'}">

                                            <c:if test="${task.createdBy.role == 'MANAGER'}">
                                                <div class="flex space-x-2 items-center p-2 text-xs font-medium text-blue-600 border-t border-gray-200 rounded-b-lg bg-gray-50 dark:border-gray-600 hover:bg-gray-100 dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-blue-500 hover:underline">
                                                    <p>Change The Task</p>
                                                    <div class="flex">
                                                        <img width="16" height="10" src="https://img.icons8.com/color/48/cheap--v1.png" alt="cheap--v1"/>
                                                        <p><c:out value="${user.token.dailyModificationTokens} Tokens Left"/></p>
                                                    </div>

                                                </div>
                                                <c:forEach items="${ unassignedTasks }" var="unassignedtask" varStatus="status">

                                                    <li>
                                                        <a href="#" class="change-task flex items-center text-[10px] px-2 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                                                           data-user-id="${user.id}" data-task-id="${unassignedtask.id}" data-oldtask-id="${task.id}">
                                                            <img class="w-4 h-4 me-2 rounded-full" src="https://th.bing.com/th/id/R.dc8b1732c919ca17845aab44dc3afb27?rik=qOkrlNPk9Y4cBg&pid=ImgRaw&r=0" alt="image">
                                                                ${unassignedtask.title}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                            </c:if>
                                            <c:if test="${task.createdBy.id == user.id}">
                                                <li>
                                                    <a href="#" class="update-assignee flex items-center text-[10px] px-2 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                                                       data-user-id="${user.id}" data-task-id="${task.id}">
                                                        <img class="w-4 h-4 me-2 rounded-full" src="https://th.bing.com/th/id/R.dc8b1732c919ca17845aab44dc3afb27?rik=qOkrlNPk9Y4cBg&pid=ImgRaw&r=0" alt="image">
                                                        Assign To Yourself
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" class="update-assignee flex items-center text-[10px] px-2 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                                                       data-user-id=" " data-task-id="${task.id}">
                                                        <img class="w-4 h-4 me-2 rounded-full" src="https://th.bing.com/th/id/R.dc8b1732c919ca17845aab44dc3afb27?rik=qOkrlNPk9Y4cBg&pid=ImgRaw&r=0" alt="image">
                                                        DISMISS
                                                    </a>
                                                </li>

                                            </c:if>


                                        </c:when>
                                        <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <li>
                                            <a href="#" class="update-assignee flex items-center text-[10px] px-2 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                                               data-user-id="${user.id}" data-task-id="${task.id}">
                                                <img class="w-4 h-4 me-2 rounded-full" src="https://th.bing.com/th/id/R.dc8b1732c919ca17845aab44dc3afb27?rik=qOkrlNPk9Y4cBg&pid=ImgRaw&r=0" alt="image">
                                                    ${user.firstName} ${user.lastName}
                                            </a>
                                        </li>

                                    </c:forEach>
                                        </c:otherwise>

                                    </c:choose>
                                </ul>

                            </div>
                        </div>
            </c:if>

            <c:if test="${task.dueDate.isBefore(now)}">
                <button class="inline-flex mt-[2px] w-52 items-center px-1 h-4 bg-red-500 hover:bg-red-600 text-white text-[9px] rounded-sm" disabled>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                    </svg>
                    Task Overdue! has passed deadline
                </button>
            </c:if>
        </div>


        <p class="text-[7px] absolute bottom-12 mt-1 text-slate-500">Tags</p>

        <div class="flex absolute bottom-8 gap-1 mt-1 flex-wrap">
            <c:forEach items="${task.tags}" var="tag" varStatus="status">
                <c:if test="${status.index < 4}">
                            <span class="inline-block px-1  text-[8px] font-medium text-white bg-cyan-800 rounded-md">
                    <c:out value="${tag.name}" />
                </span>
                </c:if>
            </c:forEach>
        </div>

                </div>





                    <c:if test="${user.role == 'MANAGER' && task.refused && task.assignee == null}">
                        <div class="absolute mt-12 p-3 h-2/5 inset-0 z-20 bg-red-600 pointer-events-none">
                            <p class="text-white font-semibold text-xs">THIS TASK HAS BEEN CHANGED</p>
                            <p class="text-white font-medium text-[10px]">Assign it to someone else</p>
                        </div>
                    </c:if>


            </div>
        </div>
    </c:if>

    <div id="popup-mod${task.id}" tabindex="-1" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
        <div class="relative p-4 w-full max-w-md max-h-full">
            <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                <button type="button" class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="popup-mod${task.id}">
                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                    </svg>
                    <span class="sr-only">Close modal</span>
                </button>
                <div class="p-4 md:p-5 text-center">
                    <h3 class="mb-5 text-xs font-normal text-gray-500 dark:text-gray-400">Are you sure you want to delete this task?</h3>

                    <form action="task" method="POST">
                        <input type="hidden" name="taskId" value="${task.id}">
                        <input type="hidden" name="action" value="delete">

                        <button type="submit" class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center">
                            Yes, I'm sure
                        </button>

                        <button data-modal-hide="popup-mod${task.id}" type="button" class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">
                            No, cancel
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

</c:forEach>
</div>

            <div class="bg-teal-50/50  max-h-screen" id="ongoing-column" >
                <div class="bg-slate-50 px-4 pb-2">
                    <span class="bg-green-400 text-red-800 text-xs font-medium me-2 px-1.5 rounded-full dark:bg-red-900 dark:text-red-300"></span>
                    <span class="font-semibold text-xs">On Going</span>
                </div>
                <c:forEach items="${ tasks }" var="task" varStatus="status">

                    <c:if test="${task.status == 'ONGOING'}">

                        <div class="">
                            <div class="relative max-w-sm max-h-12   draggable-card mb-[92px]" id="card-${task.id}">
                                <button data-modal-target="popup-mod${task.id}" data-modal-toggle="popup-mod${task.id}"  type="button" class="absolute hover:bg-red-400 top-0 right-0 z-10 text-white bg-transparent  focus:ring-0 focus:ring-blue-300 font-medium  text-sm px-2 py-1  mb-2 dark:bg-blue-600  focus:outline-none dark:focus:ring-blue-800">
                                    <img width="10" height="10" src="https://img.icons8.com/ios-filled/50/delete-sign--v1.png" alt="delete-sign--v1"/>
                                </button>
                                <div class="relative h-32 p-2  bg-white   border-l-4 border-green-500 ">
                                    <div class="flex items-center -mt-1">
                                        <h3 class="ml-3 text-xs font-bold text-gray-800"><c:out value="${task.title}" /></h3>
                                    </div>
                                    <p class=" text-[9px] leading-3 text-gray-600"><c:out value="${fn:substring(task.description, 0, 70)}"/></p>
                                    <div class="flex items-center space-x-8 absolute bottom-1 ">


                                        <button class="inline-flex mt-[2px] items-center px-1 h-4  bg-gray-200 hover:bg-gray-300 text-gray-800 text-[10px]  rounded-sm">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                                            </svg>

                                            <c:out value="${task.dueDate.toLocalDate()}" />

                                        </button>
                                        <div class="flex items-center gap-1">
                                            <c:choose>
                                                <c:when test="${not empty task.assignee}">
                                                    <div class="flex-shrink-0">
                                                        <img class="w-4 h-4 rounded-full" src="https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" alt="Default Avatar">
                                                    </div>
                                                    <div class="flex-1 min-w-0">

                                                        <p class="text-[9px] font-medium text-gray-900 truncate dark:text-white">
                                                                ${task.assignee.firstName.toUpperCase()} ${task.assignee.lastName.toUpperCase()}
                                                        </p>
                                                        <p class="text-[7px] text-gray-500 truncate dark:text-gray-400">
                                                                ${task.assignee.role}
                                                        </p>

                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-[8px] font-bold  text-red-900 truncate dark:text-white">
                                                        Assign To Someone
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>

                                    <p class="text-[7px] absolute bottom-12 mt-1 text-slate-500">Tags</p>

                                    <div class="flex absolute bottom-8 gap-1 mt-1 flex-wrap">
                                        <c:forEach items="${task.tags}" var="tag" varStatus="status">
                                            <c:if test="${status.index < 4}">
                            <span class="inline-block px-1  text-[8px] font-medium text-white bg-cyan-800 rounded-md">
                    <c:out value="${tag.name}" />
                </span>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:if>
                    <div id="popup-mod${task.id}" tabindex="-1" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
                        <div class="relative p-4 w-full max-w-md max-h-full">
                            <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                                <button type="button" class="absolute top-3 end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white" data-modal-hide="popup-mod${task.id}">
                                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                                    </svg>
                                    <span class="sr-only">Close modal</span>
                                </button>
                                <div class="p-4 md:p-5 text-center">
                                    <h3 class="mb-5 text-xs font-normal text-gray-500 dark:text-gray-400">Are you sure you want to delete this task?</h3>

                                    <form action="task" method="POST">
                                        <input type="hidden" name="taskId" value="${task.id}">
                                        <input type="hidden" name="action" value="delete">

                                        <button type="submit" class="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:focus:ring-red-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center">
                                            Yes, I'm sure
                                        </button>

                                        <button data-modal-hide="popup-mod${task.id}" type="button" class="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-100 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">
                                            No, cancel
                                        </button>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                </c:forEach>


            </div>

            <div class="bg-teal-50/50" id="completed-column">
                <div class="bg-slate-50 px-4 pb-2">
                    <span class="bg-blue-400 text-red-800 text-xs font-medium me-2 px-1.5 rounded-full dark:bg-red-900 dark:text-red-300"></span>
                    <span class="font-semibold text-xs">Completed</span>
                </div>
                <c:forEach items="${ tasks }" var="task" varStatus="status">

                    <c:if test="${task.status == 'COMPLETED'}">

                        <div class="">
                            <div class="relative max-w-sm max-h-12 draggable-card  mb-[92px]" id="card-${task.id}">
                                <button data-modal-target="popup-mod${task.id}" data-modal-toggle="popup-mod${task.id}"  type="button" class="absolute hover:bg-red-400 top-0 right-0 z-10 text-white bg-transparent  focus:ring-0 focus:ring-blue-300 font-medium  text-sm px-2 py-1  mb-2 dark:bg-blue-600  focus:outline-none dark:focus:ring-blue-800">
                                    <img width="10" height="10" src="https://img.icons8.com/ios-filled/50/delete-sign--v1.png" alt="delete-sign--v1"/>
                                </button>
                                <div class="relative h-32 p-2  bg-white   border-l-4 border-blue-500">
                                    <div class="flex items-center -mt-1">
                                        <h3 class="ml-3 text-xs font-bold text-gray-800"><c:out value="${task.title}" /></h3>
                                    </div>
                                    <p class=" text-[9px] text-gray-600"><c:out value="${fn:substring(task.description, 0, 70)}"/></p>
                                    <div class="flex items-center space-x-8 absolute bottom-1 ">


                                        <button class="inline-flex mt-[2px] items-center px-1 h-4  bg-gray-200 hover:bg-gray-300 text-gray-800 text-[10px]  rounded-sm">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                                            </svg>

                                            <c:out value="${task.dueDate.toLocalDate()}" />

                                        </button>
                                        <div class="flex items-center gap-1">
                                            <c:choose>
                                                <c:when test="${not empty task.assignee}">
                                                    <div class="flex-shrink-0">
                                                        <img class="w-4 h-4 rounded-full" src="https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" alt="Default Avatar">
                                                    </div>
                                                    <div class="flex-1 min-w-0">

                                                        <p class="text-[9px] font-medium text-gray-900 truncate dark:text-white">
                                                                ${task.assignee.firstName.toUpperCase()} ${task.assignee.lastName.toUpperCase()}
                                                        </p>
                                                        <p class="text-[7px] text-gray-500 truncate dark:text-gray-400">
                                                                ${task.assignee.role}
                                                        </p>

                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-[8px] font-bold  text-red-900 truncate dark:text-white">
                                                        Assign To Someone
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>

                                    <p class="text-[7px] absolute bottom-12 mt-1 text-slate-500">Tags</p>

                                    <div class="flex absolute bottom-8 gap-1 mt-1 flex-wrap">
                                        <c:forEach items="${task.tags}" var="tag" varStatus="status">
                                            <c:if test="${status.index < 4}">
                            <span class="inline-block px-1  text-[8px] font-medium text-white bg-cyan-800 rounded-md">
                    <c:out value="${tag.name}" />
                </span>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>






</div>
</div>





<script>
    $(function() {
        $(".draggable-card").draggable({
            revert: "invalid",
            cursor: "move",
            containment: ".grid"
        });

        $("#todo-column, #ongoing-column, #completed-column").droppable({
            accept: ".draggable-card",
            hoverClass: "bg-gray-100",
            drop: function(event, ui) {
                $(this).append(ui.draggable);
                ui.draggable.css({ top: "0", left: "0" });

                let taskId = ui.draggable.attr("id").split('-')[1];
                let newStatus = "";

                if ($(this).attr('id') === 'todo-column') {
                    newStatus = "TODO";
                    ui.draggable.find(".border-2").removeClass("border-green-500 border-blue-500").addClass("border-red-500");
                } else if ($(this).attr('id') === 'ongoing-column') {
                    newStatus = "ONGOING";
                    ui.draggable.find(".border-2").removeClass("border-red-500 border-blue-500").addClass("border-green-500");
                } else if ($(this).attr('id') === 'completed-column') {
                    newStatus = "COMPLETED";
                    ui.draggable.find(".border-2").removeClass("border-red-500 border-green-500").addClass("border-blue-500");
                }

                updateTaskStatus(taskId, newStatus);
            }
        });
    });

    function updateTaskStatus(taskId, newStatus) {
        $.ajax({
            url: window.location.origin + "/DevSync-1.0/task",
            type: 'POST',
            data: {
                action:"update",
                id: taskId,
                status: newStatus
            },

            success: function(response) {
                console.log('Task updated successfully:', response);
                location.reload();
            },
            error: function(xhr, status, error) {
                console.error('Error updating task status:', xhr.responseText);
            }
        });
    }

    $(document).ready(function() {
        $('.update-assignee').click(function(event) {
            event.preventDefault();

            let userId = $(this).data('user-id');
            const taskId = $(this).data('task-id');

            if (!userId || (typeof userId === 'string' && userId.trim() === "")) {
                userId = null;
            }

            $.ajax({
                url: '/DevSync-1.0/task',
                type: 'POST',
                data: {
                    action: 'updateAssignee',
                    user_id: userId,
                    task_id: taskId
                },
                success: function(response) {
                    location.reload();
                },
                error: function(xhr, status, error) {
                    console.error('Error updating task assignee: ' + error);
                }
            });
        });
    });

    $(document).ready(function() {
        $('.change-task').click(function(event) {
            event.preventDefault();

            const userId = $(this).data('user-id');
            const taskId = $(this).data('task-id');
            const oldtaskId = $(this).data('oldtask-id');


            $.ajax({
                url: '/DevSync-1.0/task',
                type: 'POST',
                data: {
                    action: 'changeTask',
                    user_id: userId,
                    task_id: taskId,
                    oldTask_id: oldtaskId
                },
                success: function(response) {
                    location.reload();
                },
                error: function(xhr, status, error) {
                    console.error('Error updating task: ' + error);
                }
            });
        });
    });

    $(document).ready(function(){
        $(".chosen-select").chosen({
            width: "100%"
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        var now = new Date().toISOString().slice(0, 16);
        document.getElementById('dueDate').min = now;
    });

</script>

</body>

