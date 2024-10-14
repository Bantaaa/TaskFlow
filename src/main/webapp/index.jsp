<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task and User Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.16/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <style>
        .tag-container {
            display: flex;
            flex-wrap: wrap;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            align-items: center;
        }
        .tag {
            display: inline-flex;
            align-items: center;
            background-color: #e2e8f0;
            color: #4a5568;
            padding: 2px 8px;
            margin: 2px;
            border-radius: 9999px;
            font-size: 0.75rem;
            line-height: 1.25rem;
        }
        .tag-remove {
            margin-left: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .tag-input {
            border: none;
            outline: none;
            flex-grow: 1;
            padding: 5px;
            font-size: 0.875rem;
        }
        .sidebar-toggle {
            position: absolute;
            bottom: 1rem;
            left: 1rem;
            z-index: 10;
        }
        .hidden {
            display: none;
        }

    </style>
</head>
<body class="bg-gray-100">
<div class="flex h-screen bg-gray-50" id="app-container">
    <!-- Compact Sidebar -->
    <aside id="sidebar-compact" class="w-20 overflow-y-auto bg-white md:block flex-shrink-0">
        <div class="py-4 text-gray-500">
            <div class="flex justify-center items-center mb-6">
                <img src="https://via.placeholder.com/150" alt="Logo" class="h-10 w-10" id="sidebar-logo-compact">
            </div>
            <button id="sidebar-toggle" class="w-full flex justify-center items-center py-2 focus:outline-none">
                <i class="fas fa-chevron-right w-5 h-5"></i>
            </button>
            <ul class="mt-6">
                <li class="relative px-2 py-3">
                    <a class="inline-flex items-center justify-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-home w-5 h-5"></i>
                    </a>
                </li>
                <li class="relative px-2 py-3">
                    <a class="inline-flex items-center justify-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-tasks w-5 h-5"></i>
                    </a>
                </li>
                <li class="relative px-2 py-3">
                    <a class="inline-flex items-center justify-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-users w-5 h-5"></i>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Expanded Sidebar -->
    <aside id="sidebar-expanded" class="w-64 overflow-y-auto bg-white md:block flex-shrink-0 hidden">
        <div class="py-4 text-gray-500">
            <div class="flex justify-center items-center mb-6">
                <img src="https://via.placeholder.com/150" alt="Logo" class="h-16 w-16" id="sidebar-logo-expanded">
            </div>
            <button id="sidebar-toggle-expanded" class="w-full flex justify-center items-center py-2 focus:outline-none">
                <i class="fas fa-chevron-left w-5 h-5"></i>
            </button>
            <ul class="mt-6">
                <li class="relative px-6 py-3">
                    <a class="inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-home w-5 h-5"></i>
                        <span class="ml-4">Dashboard</span>
                    </a>
                </li>
                <li class="relative px-6 py-3">
                    <a class="inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-tasks w-5 h-5"></i>
                        <span class="ml-4">Tasks</span>
                    </a>
                </li>
                <li class="relative px-6 py-3">
                    <a class="inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800" href="#">
                        <i class="fas fa-users w-5 h-5"></i>
                        <span class="ml-4">Team</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <div class="flex flex-col flex-1 w-full">
        <!-- Navbar -->
        <header class="z-10 py-4 bg-white shadow-md">
            <div class="container flex items-center justify-between h-full px-6 mx-auto text-purple-600">



                <!-- Search input -->
                <div class="flex justify-center flex-1 lg:mr-32">
                    <div class="hidden relative w-full max-w-xl mr-6 focus-within:text-purple-500">
                        <div class="absolute inset-y-0 flex items-center pl-2">
                            <i class="fas fa-search w-4 h-4"></i>
                        </div>
                        <input class="w-full pl-8 pr-2 text-sm text-gray-700 placeholder-gray-600 bg-gray-100 border-0 rounded-md focus:placeholder-gray-500 focus:bg-white focus:border-purple-300 focus:outline-none focus:shadow-outline-purple form-input" type="text" placeholder="Search for projects" aria-label="Search" />
                    </div>
                </div>
                <ul class="flex items-center flex-shrink-0 space-x-6">
                    <!-- Profile menu -->
                    <li class="relative">
                        <button class="align-middle rounded-full focus:shadow-outline-purple focus:outline-none" id="profile-menu-button" aria-label="Account" aria-haspopup="true">
                            <img class="object-cover w-8 h-8 rounded-full" src="https://via.placeholder.com/150" alt="" aria-hidden="true" />
                        </button>
                        <div id="profile-menu" class="absolute right-0 w-56 p-2 mt-2 space-y-2 text-gray-600 bg-white border border-gray-100 rounded-md shadow-md hidden" aria-label="submenu">
                            <a class="inline-flex items-center w-full px-2 py-1 text-sm font-semibold transition-colors duration-150 rounded-md hover:bg-gray-100 hover:text-gray-800" href="#">
                                <i class="fas fa-user mr-3 w-4 h-4"></i>
                                <span>Profile</span>
                            </a>
                            <a class="inline-flex items-center w-full px-2 py-1 text-sm font-semibold transition-colors duration-150 rounded-md hover:bg-gray-100 hover:text-gray-800" href="#">
                                <i class="fas fa-cog mr-3 w-4 h-4"></i>
                                <span>Settings</span>
                            </a>
                            <a class="inline-flex items-center w-full px-2 py-1 text-sm font-semibold transition-colors duration-150 rounded-md hover:bg-gray-100 hover:text-gray-800" href="#">
                                <i class="fas fa-sign-out-alt mr-3 w-4 h-4"></i>
                                <span>Log out</span>
                            </a>
                        </div>
                    </li>
                </ul>
            </div>
        </header>
        <!-- Main content -->
        <main class="h-full overflow-y-auto pt-8">
            <div class="container px-6 mx-auto">
                <div class="space-y-8">
                    <!-- Tasks Section -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-2xl font-semibold mb-4 text-indigo-800">My Tasks</h2>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <!-- To Do Column -->
                            <div class="bg-gray-100 p-4 rounded-lg task-column" data-status="TODO">
                                <h3 class="text-lg font-medium mb-4 text-gray-700">To Do</h3>
                                <div class="space-y-3 task-list">
                                    <!-- Task items will be populated here -->
                                    <c:forEach var="task" items="${tasks}">
                                        <c:if test="${task.status == 'TODO' && task.assignedUser.id == sessionScope.user.id}">
                                            <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative" draggable="true" data-assigned-user-id="${task.assignedUser.id}">
                                                <c:if test="${sessionScope.user.role == 'MANAGER'}">
                                                    <div class="absolute top-2 right-2 flex items-center">
                                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}', '${task.assignedUser.id}')" class="text-blue-500 hover:text-blue-700 p-1">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                                            </svg>
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/task/delete" method="post" class="inline-block">
                                                            <input type="hidden" name="id" value="${task.id}">
                                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                                </svg>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                                <h4 class="font-medium pr-14">${task.title}</h4>
                                                <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                                <div class="flex items-center mt-2">
                                                    <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                                </div>
                                                <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                                    <c:forEach var="tag" items="${task.tags}">
                                                        <span class="tag mr-2 mb-2">${tag}</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>

                                </div>
                            </div>

                            <!-- In Progress Column -->
                            <div class="bg-gray-100 p-4 rounded-lg task-column" data-status="IN_PROGRESS">
                                <h3 class="text-lg font-medium mb-4 text-gray-700">In Progress</h3>
                                <div class="space-y-3 task-list">
                                    <!-- Task items will be populated here -->
                                    <c:forEach var="task" items="${tasks}">
                                        <c:if test="${task.status == 'IN_PROGRESS' && task.assignedUser.id == sessionScope.user.id}">
                                            <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative border-l-4 border-yellow-400" draggable="true" data-assigned-user-id="${task.assignedUser.id}">
                                                <c:if test="${sessionScope.user.role == 'MANAGER'}">
                                                    <div class="absolute top-2 right-2 flex items-center">
                                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}', '${task.assignedUser.id}')" class="text-blue-500 hover:text-blue-700 p-1">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                                            </svg>
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/task/delete" method="post" class="inline-block">
                                                            <input type="hidden" name="id" value="${task.id}">
                                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                                </svg>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                                <h4 class="font-medium pr-14">${task.title}</h4>
                                                <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                                <div class="flex items-center mt-2">
                                                    <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                                </div>
                                                <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                                    <c:forEach var="tag" items="${task.tags}">
                                                        <span class="tag mr-2 mb-2">${tag}</span>
                                                    </c:forEach>
                                                </div>                                </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Done Column -->
                            <div class="bg-gray-100 p-4 rounded-lg task-column" data-status="DONE">
                                <h3 class="text-lg font-medium mb-4 text-gray-700">Done</h3>
                                <div class="space-y-3 task-list">
                                    <!-- Task items will be populated here -->
                                    <c:forEach var="task" items="${tasks}">
                                        <c:if test="${task.status == 'DONE' && task.assignedUser.id == sessionScope.user.id}">
                                            <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative border-l-4 border-green-400" draggable="true" data-assigned-user-id="${task.assignedUser.id}">
                                                <c:if test="${sessionScope.user.role == 'MANAGER'}">
                                                    <div class="absolute top-2 right-2 flex items-center">
                                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}', '${task.assignedUser.id}')" class="text-blue-500 hover:text-blue-700 p-1">
                                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                                            </svg>
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/task/delete" method="post" class="inline-block">
                                                            <input type="hidden" name="id" value="${task.id}">
                                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                                </svg>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                                <h4 class="font-medium pr-14">${task.title}</h4>
                                                <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                                <div class="flex items-center mt-2">
                                                    <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                                </div>
                                                <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                                    <c:forEach var="tag" items="${task.tags}">
                                                        <span class="tag mr-2 mb-2">${tag}</span>
                                                    </c:forEach>
                                                </div>                                </div>
                                        </c:if>
                                    </c:forEach>

                                </div>
                            </div>
                        </div>
                        <div class="mt-4">
                            <button onclick="openModal('createTaskModal')" class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
                                Add New Task
                            </button>
                        </div>
                    </div>

                    <!-- Users Section (Only visible to managers) -->
                    <c:if test="${sessionScope.user.role == 'MANAGER'}">
                        <div class="bg-white rounded-lg shadow-md p-6">
                            <h2 class="text-2xl font-semibold mb-4 text-indigo-800">Team Members</h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                                    <c:forEach var="user" items="${users}">
                                        <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4 relative">
                                            <img src="https://assets.audiomack.com/mulero-elijah/67cd048368eb503188164eabfcfb65ea.jpeg" alt="${user.username}" class="w-12 h-12 rounded-full bg-gray-300">
                                            <div class="flex-grow">
                                                <p class="font-medium">${user.username}</p>
                                                <p class="text-sm text-gray-500">${user.email}</p>
                                            </div>
                                            <div class="flex items-center">
                                                <button onclick="populateEditForm(${user.id}, '${user.username}', '${user.email}')" class="text-blue-500 hover:text-blue-700 p-1">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                        <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                                    </svg>
                                                </button>
                                                <form action="${pageContext.request.contextPath}/user/delete" method="post" class="inline-block">
                                                    <input type="hidden" name="id" value="${user.id}">
                                                    <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="mt-4">
                                <button onclick="openModal('createModal')" class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
                                    Add New User
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>
<!-- Create User Modal -->
<div id="createModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-bold mb-4">Create New User</h3>
        <form id="createForm" action="${pageContext.request.contextPath}/user/create" method="post">
            <div class="mb-4">
                <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username:</label>
                <input type="text" id="username" name="username" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
                <input type="email" id="email" name="email" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password:</label>
                <input type="password" id="password" name="password" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="flex items-center justify-between">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Create
                </button>
                <button type="button" onclick="closeModal('createModal')" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-bold mb-4">Edit User</h3>
        <form id="editForm" action="${pageContext.request.contextPath}/user/update" method="post">
            <input type="hidden" id="editId" name="id">
            <div class="mb-4">
                <label for="editUsername" class="block text-gray-700 text-sm font-bold mb-2">Username:</label>
                <input type="text" id="editUsername" name="username" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="editEmail" class="block text-gray-700 text-sm font-bold mb-2">Email:</label>
                <input type="email" id="editEmail" name="email" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="editPassword" class="block text-gray-700 text-sm font-bold mb-2">Password (leave blank to keep current):</label>
                <input type="password" id="editPassword" name="password" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="flex items-center justify-between">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Update
                </button>
                <button type="button" onclick="closeModal('editModal')" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Create Task Modal -->
<div id="createTaskModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-bold mb-4">Create New Task</h3>
        <form id="createTaskForm" action="${pageContext.request.contextPath}/task/create" method="post" onsubmit="return validateForm('createTaskForm')">
            <div class="mb-4">
                <label for="taskTitle" class="block text-gray-700 text-sm font-bold mb-2">Title:</label>
                <input type="text" id="taskTitle" name="title" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="taskDescription" class="block text-gray-700 text-sm font-bold mb-2">Description:</label>
                <textarea id="taskDescription" name="description" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" rows="3"></textarea>
            </div>
            <div class="mb-4">
                <label for="taskDueDate" class="block text-gray-700 text-sm font-bold mb-2">Due Date:</label>
                <input type="date" id="taskDueDate" name="dueDate" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="taskStatus" class="block text-gray-700 text-sm font-bold mb-2">Status:</label>
                <select id="taskStatus" name="status" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                    <option value="TODO">To Do</option>
                    <option value="IN_PROGRESS">In Progress</option>
                    <option value="DONE">Done</option>
                </select>
            </div>
            <div class="mb-4">
                <label for="taskTags" class="block text-gray-700 text-sm font-bold mb-2">Tags:</label>
                <div id="taskTagContainer" class="tag-container">
                    <input type="text" id="taskTags" class="tag-input" placeholder="Type and press space to add tags">
                </div>
                <input type="hidden" id="taskTagsHidden" name="tags" required>
            </div>
            <div class="mb-4">
                <label for="taskAssignedUser" class="block text-gray-700 text-sm font-bold mb-2">Assign To:</label>
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'MANAGER'}">
                        <select id="taskAssignedUser" name="assignedUserId" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                            <option value="">Select User</option>
                            <c:forEach var="user" items="${users}">
                                <option value="${user.id}">${user.username}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" id="taskAssignedUser" name="assignedUserId" value="${sessionScope.user.id}">
                        <p class="text-gray-700">This task will be assigned to you.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="flex items-center justify-between">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Create
                </button>
                <button type="button" onclick="closeModal('createTaskModal')" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Task Modal -->
<div id="editTaskModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-bold mb-4">Edit Task</h3>
        <form id="editTaskForm" action="${pageContext.request.contextPath}/task/update" method="post" onsubmit="return validateForm('editTaskForm')">
            <input type="hidden" id="editTaskId" name="id">
            <div class="mb-4">
                <label for="editTaskTitle" class="block text-gray-700 text-sm font-bold mb-2">Title:</label>
                <input type="text" id="editTaskTitle" name="title" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="editTaskDescription" class="block text-gray-700 text-sm font-bold mb-2">Description:</label>
                <textarea id="editTaskDescription" name="description" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" rows="3"></textarea>
            </div>
            <div class="mb-4">
                <label for="editTaskDueDate" class="block text-gray-700 text-sm font-bold mb-2">Due Date:</label>
                <input type="date" id="editTaskDueDate" name="dueDate" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
            </div>
            <div class="mb-4">
                <label for="editTaskStatus" class="block text-gray-700 text-sm font-bold mb-2">Status:</label>
                <select id="editTaskStatus" name="status" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                    <option value="TODO">To Do</option>
                    <option value="IN_PROGRESS">In Progress</option>
                    <option value="DONE">Done</option>
                </select>
            </div>
            <div class="mb-4">
                <label for="editTaskTags" class="block text-gray-700 text-sm font-bold mb-2">Tags:</label>
                <div id="editTaskTagContainer" class="tag-container">
                    <input type="text" id="editTaskTags" class="tag-input" placeholder="Type and press space to add tags">
                </div>
                <input type="hidden" id="editTaskTagsHidden" name="tags" required>
            </div>
            <div class="mb-4">
                <label for="editTaskAssignedUser" class="block text-gray-700 text-sm font-bold mb-2">Assign To:</label>
                <select id="editTaskAssignedUser" name="assignedUserId" required class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                    <option value="">Select User</option>
                    <c:forEach var="user" items="${users}">
                        <option value="${user.id}">${user.username}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex items-center justify-between">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Update
                </button>
                <button type="button" onclick="closeModal('editTaskModal')" class="bg-gray-500 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                    Cancel
                </button>
            </div>
        </form>
    </div>
</div>

<script>

    document.addEventListener('DOMContentLoaded', function() {
        const sidebarCompact = document.getElementById('sidebar-compact');
        const sidebarExpanded = document.getElementById('sidebar-expanded');
        const sidebarToggle = document.getElementById('sidebar-toggle');
        const sidebarToggleExpanded = document.getElementById('sidebar-toggle-expanded');
        const mainContent = document.querySelector('.main-content');

        function toggleSidebar() {
            if (sidebarCompact.classList.contains('hidden')) {
                sidebarCompact.classList.remove('hidden');
                sidebarExpanded.classList.add('hidden');
                mainContent.style.marginLeft = '5rem';
            } else {
                sidebarCompact.classList.add('hidden');
                sidebarExpanded.classList.remove('hidden');
                mainContent.style.marginLeft = '16rem';
            }
        }

        sidebarToggle.addEventListener('click', toggleSidebar);
        sidebarToggleExpanded.addEventListener('click', toggleSidebar);
    });

    // Add these styles to your existing <style> section or CSS file
    document.head.insertAdjacentHTML('beforeend', `
<style>
    .task-column.drag-over {
        background-color: #e2e8f0;
        transition: background-color 0.3s ease;
    }
    .task[draggable="true"] {
        cursor: move;
    }
    .task.dragging {
        opacity: 0.5;
        transition: opacity 0.3s ease;
    }
</style>
`);

    // Sidebar toggle
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');
    const appContainer = document.getElementById('app-container');

    sidebarToggle.addEventListener('click', () => {
        sidebar.classList.toggle('hidden');
        appContainer.classList.toggle('md:ml-64');
    });

    // Profile menu toggle
    const profileMenuButton = document.getElementById('profile-menu-button');
    const profileMenu = document.getElementById('profile-menu');

    profileMenuButton.addEventListener('click', () => {
        profileMenu.classList.toggle('hidden');
    });

    // Close profile menu when clicking outside
    document.addEventListener('click', (e) => {
        if (!profileMenuButton.contains(e.target) && !profileMenu.contains(e.target)) {
            profileMenu.classList.add('hidden');
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM fully loaded');
        initializePage();
    });

    function initializePage() {
        createTagInput('taskTagContainer', 'taskTags', 'taskTagsHidden');
        createTagInput('editTaskTagContainer', 'editTaskTags', 'editTaskTagsHidden');
        initDragAndDrop();

        // Add event listeners for form submissions
        document.getElementById('createTaskForm').addEventListener('submit', handleFormSubmit);
        document.getElementById('editTaskForm').addEventListener('submit', handleFormSubmit);

        console.log('Task management script loaded');
    }

    function handleFormSubmit(e) {
        const formId = e.target.id;
        if (!validateForm(formId)) {
            e.preventDefault();
        } else {
            const modalId = formId === 'createTaskForm' ? 'createTaskModal' : 'editTaskModal';
            closeModal(modalId);
            setTimeout(() => {
                refreshTaskList();
            }, 500);
        }
    }

    function initDragAndDrop() {
        console.log('Initializing drag and drop');
        document.removeEventListener('dragstart', dragStart);
        document.removeEventListener('dragend', dragEnd);
        document.removeEventListener('dragover', dragOver);
        document.removeEventListener('dragenter', dragEnter);
        document.removeEventListener('dragleave', dragLeave);
        document.removeEventListener('drop', drop);

        document.addEventListener('dragstart', dragStart);
        document.addEventListener('dragend', dragEnd);
        document.addEventListener('dragover', dragOver);
        document.addEventListener('dragenter', dragEnter);
        document.addEventListener('dragleave', dragLeave);
        document.addEventListener('drop', drop);
    }

    function canMoveTask(taskElement) {
        if (!taskElement) return false;
        const isManager = ${sessionScope.user.role == 'MANAGER'};
        const taskAssignedUserId = taskElement.dataset ? taskElement.dataset.assignedUserId : null;
        const currentUserId = '${sessionScope.user.id}';
        return isManager || (taskAssignedUserId === currentUserId);
    }

    function dragStart(e) {
        const taskElement = e.target.closest('[draggable="true"]');
        if (taskElement && canMoveTask(taskElement)) {
            e.dataTransfer.setData('text/plain', taskElement.id);
            console.log('Drag started, setting data:', taskElement.id);
            setTimeout(() => {
                taskElement.classList.add('dragging');
            }, 0);
        } else {
            e.preventDefault();
        }
    }

    function dragEnd(e) {
        if (e.target.getAttribute('draggable') === 'true') {
            e.target.classList.remove('dragging');
            console.log('Drag ended:', e.target.id);
        }
    }

    function dragOver(e) {
        if (e.target.closest('.task-column')) {
            e.preventDefault();
        }
    }

    function dragEnter(e) {
        const column = e.target.closest('.task-column');
        if (column) {
            e.preventDefault();
            column.classList.add('drag-over');
            console.log('Entered column:', column.dataset.status);
        }
    }

    function dragLeave(e) {
        const column = e.target.closest('.task-column');
        if (column) {
            column.classList.remove('drag-over');
            console.log('Left column:', column.dataset.status);
        }
    }

    function drop(e) {
        const column = e.target.closest('.task-column');
        if (column) {
            e.preventDefault();
            console.log('Drop event triggered');
            column.classList.remove('drag-over');
            const fullTaskId = e.dataTransfer.getData('text');
            console.log('Retrieved full task ID:', fullTaskId);
            const taskId = fullTaskId.split('-')[1];
            console.log('Extracted task ID:', taskId);
            const taskElement = document.getElementById(fullTaskId);

            if (taskElement && canMoveTask(taskElement)) {
                const newStatus = column.dataset.status;
                const taskList = column.querySelector('.task-list');
                taskList.appendChild(taskElement);
                const assignedUserId = taskElement.dataset.assignedUserId;
                updateTaskStatus(taskId, newStatus, assignedUserId);

                // Update task's visual state based on new status
                taskElement.classList.remove('border-l-4', 'border-yellow-400', 'border-green-400');
                if (newStatus === 'IN_PROGRESS') {
                    taskElement.classList.add('border-l-4', 'border-yellow-400');
                } else if (newStatus === 'DONE') {
                    taskElement.classList.add('border-l-4', 'border-green-400');
                }
                console.log('Task dropped:', taskId, 'New status:', newStatus, 'Assigned to:', assignedUserId);
            } else {
                console.log('Task element not found or user not allowed to move this task:', fullTaskId);
            }
        }
    }

    function updateTaskStatus(taskId, newStatus, assignedUserId) {
        console.log('Updating task status:', taskId, newStatus, 'Assigned to:', assignedUserId);

        const params = new URLSearchParams();
        params.append('id', taskId);
        params.append('status', newStatus);
        params.append('assignedUserId', assignedUserId);

        axios.post('${pageContext.request.contextPath}/task/updateStatus', params, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
            .then(function (response) {
                console.log('Task status updated successfully:', response.data);
                // Optionally, update the UI or refresh the task list here
            })
            .catch(function (error) {
                console.error('Error updating task status:', error);
                if (error.response) {
                    console.error('Response data:', error.response.data);
                    console.error('Response status:', error.response.status);
                    console.error('Response headers:', error.response.headers);
                }
                // Optionally, show an error message to the user
            });
    }

    function refreshTaskList() {
        axios.get('${pageContext.request.contextPath}/tasks')
            .then(function (response) {
                // Assuming the response contains HTML for the updated task list
                document.querySelector('.task-list-container').innerHTML = response.data;
                reinitializeDragAndDrop();
            })
            .catch(function (error) {
                console.error('Error refreshing task list:', error);
            });
    }

    function reinitializeDragAndDrop() {
        console.log('Reinitializing drag and drop');
        initDragAndDrop();
    }

    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    function createTagInput(containerId, inputId, hiddenInputId) {
        const container = document.getElementById(containerId);
        const input = document.getElementById(inputId);
        const hiddenInput = document.getElementById(hiddenInputId);
        const tags = [];

        function addTag(tag) {
            tag = tag.trim();
            if (tag && !tags.includes(tag)) {
                tags.push(tag);
                updateTags();
            }
        }

        function removeTag(tag) {
            const index = tags.indexOf(tag);
            if (index > -1) {
                tags.splice(index, 1);
                updateTags();
            }
        }

        function updateTags() {
            container.innerHTML = '';
            tags.forEach(tag => {
                const tagElement = document.createElement('span');
                tagElement.classList.add('tag');
                tagElement.textContent = tag;
                const removeButton = document.createElement('span');
                removeButton.textContent = '×';
                removeButton.classList.add('tag-remove');
                removeButton.onclick = function() {
                    removeTag(tag);
                };
                tagElement.appendChild(removeButton);
                container.appendChild(tagElement);
            });
            container.appendChild(input);
            hiddenInput.value = tags.join(',');
        }

        input.addEventListener('keydown', function(e) {
            if ((e.key === ' ' || e.key === 'Enter') && this.value.trim()) {
                e.preventDefault();
                addTag(this.value.trim());
                this.value = '';
            }
        });

        input.addEventListener('blur', function() {
            if (this.value.trim()) {
                addTag(this.value.trim());
                this.value = '';
            }
        });

        // Initialize tags if there are existing values
        if (hiddenInput.value) {
            hiddenInput.value.split(',').forEach(tag => addTag(tag.trim()));
        }

        return { addTag, removeTag, updateTags };
    }

    function validateTags(inputId) {
        const hiddenInput = document.getElementById(inputId);
        const tags = hiddenInput.value.split(',').filter(tag => tag.trim() !== '');
        return tags.length >= 2;
    }

    function validateForm(formId) {
        const form = document.getElementById(formId);
        const tagsValid = validateTags(formId === 'createTaskForm' ? 'taskTagsHidden' : 'editTaskTagsHidden');
        if (!tagsValid) {
            alert('Please enter at least two tags.');
            return false;
        }
        return form.checkValidity();
    }

    function populateEditTaskForm(id, title, description, dueDate, status, tags, assignedUserId) {
        document.getElementById('editTaskId').value = id;
        document.getElementById('editTaskTitle').value = title;
        document.getElementById('editTaskDescription').value = description;
        document.getElementById('editTaskDueDate').value = dueDate;
        document.getElementById('editTaskStatus').value = status;
        document.getElementById('editTaskAssignedUser').value = assignedUserId;

        const editTagInput = createTagInput('editTaskTagContainer', 'editTaskTags', 'editTaskTagsHidden');
        document.getElementById('editTaskTagsHidden').value = tags;
        tags.split(',').forEach(tag => editTagInput.addTag(tag.trim()));

        openModal('editTaskModal');
    }

    function populateEditForm(id, username, email) {
        document.getElementById('editId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editEmail').value = email;
        openModal('editModal');
    }
</script>
</body>
</html>