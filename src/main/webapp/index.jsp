<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task and User Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
    </style>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center mb-8 text-indigo-600">Task and User Dashboard</h1>

    <div class="space-y-8">
        <!-- Tasks Section (Sprint Board Style with Drag and Drop) -->
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-semibold mb-4 text-indigo-800">Tasks</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- To Do Column -->
                <div class="bg-gray-100 p-4 rounded-lg task-column" data-status="TODO">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">To Do</h3>
                    <div class="space-y-3 task-list">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'TODO'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative" draggable="true">
                                    <div class="absolute top-2 right-2 flex items-center">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="text-blue-500 hover:text-blue-700 p-1">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                            </svg>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" class="inline-block">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
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
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'IN_PROGRESS'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative border-l-4 border-yellow-400" draggable="true">
                                    <div class="absolute top-2 right-2 flex items-center">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="text-blue-500 hover:text-blue-700 p-1">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                            </svg>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" class="inline-block">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
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

                <!-- Done Column -->
                <div class="bg-gray-100 p-4 rounded-lg task-column" data-status="DONE">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">Done</h3>
                    <div class="space-y-3 task-list">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'DONE'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow relative border-l-4 border-green-400" draggable="true">
                                    <div class="absolute top-2 right-2 flex items-center">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="text-blue-500 hover:text-blue-700 p-1">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                                            </svg>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" class="inline-block">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="text-red-500 hover:text-red-700 p-1">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
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
                            <form action="${pageContext.request.contextPath}/" method="post" class="inline-block">
                                <input type="hidden" name="action" value="deleteUser">
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
            <div class="mt-4">
                <button onclick="openModal('createModal')" class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded">
                    Add New User
                </button>
            </div>
        </div>
    </div>
</div>
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
        <form id="createTaskForm" action="${pageContext.request.contextPath}/" method="post" onsubmit="return validateForm('createTaskForm')">
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
            <div class="mb-4">
                <label for="taskTags" class="block text-gray-700 text-sm font-bold mb-2">Tags:</label>
                <div id="taskTagContainer" class="tag-container">
                    <input type="text" id="taskTags" class="tag-input" placeholder="Type and press space to add tags">
                </div>
                <input type="hidden" id="taskTagsHidden" name="tags" required>
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

<!-- Edit Task Modal (Continued) -->
<div id="editTaskModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-bold mb-4">Edit Task</h3>
        <form id="editTaskForm" action="${pageContext.request.contextPath}/" method="post" onsubmit="return validateForm('editTaskForm')">
            <input type="hidden" name="action" value="updateTask">
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

    function updateTaskTags(taskId, tags) {
        const tagContainer = document.getElementById(`tags-${taskId}`);
        tagContainer.innerHTML = '';
        tags.split(',').forEach(tag => {
            const tagElement = document.createElement('span');
            tagElement.classList.add('tag', 'mr-2', 'mb-2');
            tagElement.textContent = tag.trim();
            tagContainer.appendChild(tagElement);
        });
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

    function initDragAndDrop() {
        const tasks = document.querySelectorAll('[draggable="true"]');
        const columns = document.querySelectorAll('.task-column');

        tasks.forEach(task => {
            task.addEventListener('dragstart', dragStart);
            task.addEventListener('dragend', dragEnd);
            console.log('Attached drag listeners to task:', task.id);
        });

        columns.forEach(column => {
            column.addEventListener('dragover', dragOver);
            column.addEventListener('dragenter', dragEnter);
            column.addEventListener('dragleave', dragLeave);
            column.addEventListener('drop', drop);
            console.log('Attached drop listener to column:', column.dataset.status);
        });

        console.log('Drag and drop initialized');
    }

    function dragStart(e) {
        e.dataTransfer.setData('text/plain', e.target.id);
        console.log('Drag started, setting data:', e.target.id);
        setTimeout(() => {
            e.target.classList.add('opacity-50');
        }, 0);
    }

    function dragEnd(e) {
        e.target.classList.remove('opacity-50');
        console.log('Drag ended:', e.target.id);
    }

    function dragOver(e) {
        e.preventDefault();
        // console.log('Drag over');
    }

    function dragEnter(e) {
        e.preventDefault();
        const column = e.target.closest('.task-column');
        if (column) {
            column.classList.add('bg-gray-200');
            console.log('Entered column:', column.dataset.status);
        }
    }

    function dragLeave(e) {
        const column = e.target.closest('.task-column');
        if (column) {
            column.classList.remove('bg-gray-200');
            console.log('Left column:', column.dataset.status);
        }
    }

    function drop(e) {
        e.preventDefault();
        console.log('Drop event triggered');
        const column = e.target.closest('.task-column');
        if (!column) {
            console.log('Drop target is not a column');
            return;
        }

        column.classList.remove('bg-gray-200');
        const fullTaskId = e.dataTransfer.getData('text');
        console.log('Retrieved full task ID:', fullTaskId);
        const taskId = fullTaskId.split('-')[1];
        console.log('Extracted task ID:', taskId);
        const taskElement = document.getElementById(fullTaskId);

        if (taskElement) {
            const newStatus = column.dataset.status;
            const taskList = column.querySelector('.task-list');
            taskList.appendChild(taskElement);
            updateTaskStatus(taskId, newStatus);

            // Update task's visual state based on new status
            taskElement.classList.remove('border-l-4', 'border-yellow-400', 'border-green-400');
            if (newStatus === 'IN_PROGRESS') {
                taskElement.classList.add('border-l-4', 'border-yellow-400');
            } else if (newStatus === 'DONE') {
                taskElement.classList.add('border-l-4', 'border-green-400');
            }
            console.log('Task dropped:', taskId, 'New status:', newStatus);
        } else {
            console.log('Task element not found:', fullTaskId);
        }
    }

    function updateTaskStatus(taskId, newStatus) {
        console.log('Updating task status:', taskId, newStatus);
        const form = new FormData();
        form.append('action', 'updateTaskStatus');
        form.append('id', taskId);
        form.append('status', newStatus);

        axios.post('${pageContext.request.contextPath}/', form)
            .then(function (response) {
                console.log('Task status updated successfully:', response.data);
            })
            .catch(function (error) {
                console.error('Error updating task status:', error);
                if (error.response) {
                    console.error('Response data:', error.response.data);
                    console.error('Response status:', error.response.status);
                    console.error('Response headers:', error.response.headers);
                }
            });
    }

    function populateEditTaskForm(id, title, description, dueDate, status, tags) {
        document.getElementById('editTaskId').value = id;
        document.getElementById('editTaskTitle').value = title;
        document.getElementById('editTaskDescription').value = description;
        document.getElementById('editTaskDueDate').value = dueDate;
        document.getElementById('editTaskStatus').value = status;

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

    function reinitializeDragAndDrop() {
        console.log('Reinitializing drag and drop');
        initDragAndDrop();
    }

    function handleTaskUpdate() {
        console.log('Handling task update');
        // Update task list or perform other necessary actions
        reinitializeDragAndDrop();
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM fully loaded');
        createTagInput('taskTagContainer', 'taskTags', 'taskTagsHidden');
        createTagInput('editTaskTagContainer', 'editTaskTags', 'editTaskTagsHidden');
        initDragAndDrop();

        // Add event listeners for form submissions
        document.getElementById('createTaskForm').addEventListener('submit', function(e) {
            if (!validateForm('createTaskForm')) {
                e.preventDefault();
            } else {
                // Close the modal and reinitialize drag and drop after successful submission
                closeModal('createTaskModal');
                setTimeout(reinitializeDragAndDrop, 500); // Give some time for the DOM to update
            }
        });

        document.getElementById('editTaskForm').addEventListener('submit', function(e) {
            if (!validateForm('editTaskForm')) {
                e.preventDefault();
            } else {
                // Close the modal and reinitialize drag and drop after successful submission
                closeModal('editTaskModal');
                setTimeout(reinitializeDragAndDrop, 500); // Give some time for the DOM to update
            }
        });

        // Log when the script has finished loading
        console.log('Task management script loaded');
    });
</script>
</body>
</html>