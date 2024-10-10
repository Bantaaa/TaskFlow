<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task and User Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        function openModal(modalId) {
            document.getElementById(modalId).classList.remove('hidden');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.add('hidden');
        }

        function submitForm(formId) {
            document.getElementById(formId).submit();
        }

        function populateEditForm(id, username, email) {
            document.getElementById('editId').value = id;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            openModal('editModal');
        }

        function populateEditTaskForm(id, title, description, dueDate, status) {
            document.getElementById('editTaskId').value = id;
            document.getElementById('editTaskTitle').value = title;
            document.getElementById('editTaskDescription').value = description;
            document.getElementById('editTaskDueDate').value = dueDate;
            document.getElementById('editTaskStatus').value = status;
            openModal('editTaskModal');
        }

        function drag(ev) {
            ev.dataTransfer.setData("text", ev.target.id);
        }

        function allowDrop(ev) {
            ev.preventDefault();
        }

        function drop(ev) {
            ev.preventDefault();
            var data = ev.dataTransfer.getData("text");
            ev.target.closest('.task-column').appendChild(document.getElementById(data));

            // Update task status
            var taskId = data.split('-')[1];
            var newStatus = ev.target.closest('.task-column').id;
            updateTaskStatus(taskId, newStatus);
        }

        function updateTaskStatus(taskId, newStatus) {
            // Send AJAX request to update task status
            fetch('${pageContext.request.contextPath}/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=updateTaskStatus&id=${taskId}&status=${newStatus}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('Task status updated successfully');
                    } else {
                        console.error('Failed to update task status');
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        }
    </script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-8 text-indigo-600">Task and User Dashboard</h1>

    <div class="space-y-8">
        <!-- Tasks Section (Sprint Board Style) -->
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-semibold mb-4 text-indigo-800">Tasks</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- To Do Column -->
                <div id="TODO" class="task-column bg-gray-100 p-4 rounded-lg" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">To Do</h3>
                    <div class="space-y-3">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'TODO'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow" draggable="true" ondragstart="drag(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center justify-between mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                        <div>
                                            <i onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}')" class="fas fa-edit text-blue-500 hover:text-blue-700 cursor-pointer mr-2"></i>
                                            <i onclick="submitForm('deleteTask-${task.id}')" class="fas fa-trash-alt text-red-500 hover:text-red-700 cursor-pointer"></i>
                                            <form id="deleteTask-${task.id}" action="${pageContext.request.contextPath}/" method="post" class="hidden">
                                                <input type="hidden" name="action" value="deleteTask">
                                                <input type="hidden" name="id" value="${task.id}">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- In Progress Column -->
                <div id="IN_PROGRESS" class="task-column bg-gray-100 p-4 rounded-lg" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">In Progress</h3>
                    <div class="space-y-3">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'IN_PROGRESS'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow border-l-4 border-yellow-400" draggable="true" ondragstart="drag(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center justify-between mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                        <div>
                                            <i onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}')" class="fas fa-edit text-blue-500 hover:text-blue-700 cursor-pointer mr-2"></i>
                                            <i onclick="submitForm('deleteTask-${task.id}')" class="fas fa-trash-alt text-red-500 hover:text-red-700 cursor-pointer"></i>
                                            <form id="deleteTask-${task.id}" action="${pageContext.request.contextPath}/" method="post" class="hidden">
                                                <input type="hidden" name="action" value="deleteTask">
                                                <input type="hidden" name="id" value="${task.id}">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- Done Column -->
                <div id="DONE" class="task-column bg-gray-100 p-4 rounded-lg" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">Done</h3>
                    <div class="space-y-3">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'DONE'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow border-l-4 border-green-400" draggable="true" ondragstart="drag(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center justify-between mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                        <div>
                                            <i onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}')" class="fas fa-edit text-blue-500 hover:text-blue-700 cursor-pointer mr-2"></i>
                                            <i onclick="submitForm('deleteTask-${task.id}')" class="fas fa-trash-alt text-red-500 hover:text-red-700 cursor-pointer"></i>
                                            <form id="deleteTask-${task.id}" action="${pageContext.request.contextPath}/" method="post" class="hidden">
                                                <input type="hidden" name="action" value="deleteTask">
                                                <input type="hidden" name="id" value="${task.id}">
                                            </form>
                                        </div>
                                    </div>
                                </div>
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

        <!-- Users Section -->
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-semibold mb-4 text-indigo-800">Team Members</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <c:forEach var="user" items="${users}">
                    <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4">
                        <img src="/api/placeholder/48/48" alt="${user.username}" class="w-12 h-12 rounded-full bg-gray-300">
                        <div>
                            <p class="font-medium">${user.username}</p>
                            <p class="text-sm text-gray-500">${user.email}</p>
                        </div>
                        <div class="ml-auto">
                            <i onclick="populateEditForm(${user.id}, '${user.username}', '${user.email}')" class="fas fa-edit text-blue-500 hover:text-blue-700 cursor-pointer mr-2"></i>
                            <i onclick="submitForm('deleteUser-${user.id}')" class="fas fa-trash-alt text-red-500 hover:text-red-700 cursor-pointer"></i>
                            <form id="deleteUser-${user.id}" action="${pageContext.request.contextPath}/" method="post" class="hidden">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${user.id}">
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="mt-4">
                <button onclick="openModal('createModal')" class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
                    Add New User
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ... -->


    <!-- Create User Modal -->
    <div id="createModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <h3 class="text-lg font-bold mb-4">Create New User</h3>
            <form id="createForm" action="${pageContext.request.contextPath}/" method="post">
                <input type="hidden" name="action" value="create">
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
            <form id="editForm" action="${pageContext.request.contextPath}/" method="post">
                <input type="hidden" name="action" value="edit">
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
            <form id="createTaskForm" action="${pageContext.request.contextPath}/" method="post">
                <input type="hidden" name="action" value="createTask">
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
            <form id="editTaskForm" action="${pageContext.request.contextPath}/" method="post">
                <input type="hidden" name="action" value="editTask">
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
</div>
</body>
</html>