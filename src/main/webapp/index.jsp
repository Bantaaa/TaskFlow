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
        }
        .tag {
            border-radius: 9999px;
            padding: 2px 8px;
            margin: 2px;
            display: inline-flex;
            align-items: center;
            font-size: 0.75rem;
            color: white;
        }
        .tag-remove {
            margin-left: 4px;
            cursor: pointer;
        }
        .tag-input {
            border: none;
            outline: none;
            flex-grow: 1;
            padding: 5px;
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
                <div class="bg-gray-100 p-4 rounded-lg task-column" ondragover="dragOver(event)" ondrop="drop(event, 'TODO')">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">To Do</h3>
                    <div class="space-y-3 task-list">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'TODO'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow" draggable="true" ondragstart="dragStart(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                    </div>
                                    <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                        <c:forTokens items="${task.tags}" delims="," var="tag">
                                            <span class="tag mr-2 mb-2">${tag}</span>
                                        </c:forTokens>
                                    </div>
                                    <div class="mt-2 flex space-x-2">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-1 px-2 rounded text-sm">
                                            Edit
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-2 rounded text-sm">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- In Progress Column -->
                <div class="bg-gray-100 p-4 rounded-lg task-column" ondragover="dragOver(event)" ondrop="drop(event, 'IN_PROGRESS')">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">In Progress</h3>
                    <div class="space-y-3 task-list">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'IN_PROGRESS'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow border-l-4 border-yellow-400" draggable="true" ondragstart="dragStart(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                    </div>
                                    <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                        <c:forTokens items="${task.tags}" delims="," var="tag">
                                            <span class="tag mr-2 mb-2">${tag}</span>
                                        </c:forTokens>
                                    </div>
                                    <div class="mt-2 flex space-x-2">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-1 px-2 rounded text-sm">
                                            Edit
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-2 rounded text-sm">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <!-- Done Column -->
                <div class="bg-gray-100 p-4 rounded-lg task-column" ondragover="dragOver(event)" ondrop="drop(event, 'DONE')">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">Done</h3>
                    <div class="space-y-3 task-list">
                        <c:forEach var="task" items="${tasks}">
                            <c:if test="${task.status == 'DONE'}">
                                <div id="task-${task.id}" class="bg-white p-3 rounded shadow border-l-4 border-green-400" draggable="true" ondragstart="dragStart(event)">
                                    <h4 class="font-medium">${task.title}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${task.description}</p>
                                    <div class="flex items-center mt-2">
                                        <span class="text-xs text-gray-500">Due: ${task.dueDate}</span>
                                    </div>
                                    <div class="mt-2 flex flex-wrap" id="tags-${task.id}">
                                        <c:forTokens items="${task.tags}" delims="," var="tag">
                                            <span class="tag mr-2 mb-2">${tag}</span>
                                        </c:forTokens>
                                    </div>
                                    <div class="mt-2 flex space-x-2">
                                        <button onclick="populateEditTaskForm(${task.id}, '${task.title}', '${task.description}', '${task.dueDate}', '${task.status}', '${task.tags}')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-1 px-2 rounded text-sm">
                                            Edit
                                        </button>
                                        <form action="${pageContext.request.contextPath}/" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteTask">
                                            <input type="hidden" name="id" value="${task.id}">
                                            <button type="submit" class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-2 rounded text-sm">
                                                Delete
                                            </button>
                                        </form>
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
                        <div class="ml-auto flex space-x-2">
                            <button onclick="populateEditForm(${user.id}, '${user.username}', '${user.email}')" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-1 px-2 rounded text-sm">
                                Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="deleteUser">
                                <input type="hidden" name="id" value="${user.id}">
                                <button type="submit" class="bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-2 rounded text-sm">
                                    Delete
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
            if (!tags.includes(tag)) {
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
                tagElement.classList.add('tag', 'mr-2', 'mb-2');
                tagElement.textContent = tag;
                tagElement.style.backgroundColor = getRandomColor();
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
            if (e.key === ' ' || e.key === 'Enter') {
                e.preventDefault();
                const tag = this.value.trim();
                if (tag) {
                    addTag(tag);
                    this.value = '';
                }
            }
        });

        // Initialize tags if there are existing values
        if (hiddenInput.value) {
            hiddenInput.value.split(',').forEach(tag => addTag(tag.trim()));
        }

        return { addTag, removeTag, updateTags };
    }

    function getRandomColor() {
        const letters = '0123456789ABCDEF';
        let color = '#';
        for (let i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }

    function updateTaskTags(taskId, tags) {
        const tagContainer = document.getElementById(`tags-${taskId}`);
        tagContainer.innerHTML = '';
        tags.split(',').forEach(tag => {
            const tagElement = document.createElement('span');
            tagElement.classList.add('tag', 'mr-2', 'mb-2');
            tagElement.textContent = tag.trim();
            tagElement.style.backgroundColor = getRandomColor();
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

    function updateTaskStatus(taskId, newStatus) {
        axios.post('${pageContext.request.contextPath}/', {
            action: 'updateTaskStatus',
            id: taskId,
            status: newStatus
        }, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
            .then(function (response) {
                console.log('Task status updated successfully');
                updateTaskColor(taskId, newStatus);
            })
            .catch(function (error) {
                console.error('Error updating task status:', error);
            });
    }

    function updateTaskColor(taskId, status) {
        const taskElement = document.getElementById(`task-${taskId}`);
        taskElement.classList.remove('border-l-4', 'border-yellow-400', 'border-green-400');
        if (status === 'IN_PROGRESS') {
            taskElement.classList.add('border-l-4', 'border-yellow-400');
        } else if (status === 'DONE') {
            taskElement.classList.add('border-l-4', 'border-green-400');
        }
    }

    function dragStart(event) {
        event.dataTransfer.setData("text/plain", event.target.id);
    }

    function dragOver(event) {
        event.preventDefault();
    }

    function drop(event, status) {
        event.preventDefault();
        const taskId = event.dataTransfer.getData("text").split('-')[1];
        const taskElement = document.getElementById(`task-${taskId}`);
        const targetColumn = event.target.closest('.task-column');
        if (targetColumn) {
            targetColumn.querySelector('.task-list').appendChild(taskElement);
            updateTaskStatus(taskId, status);
        }
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

    document.addEventListener('DOMContentLoaded', function() {
        createTagInput('taskTagContainer', 'taskTags', 'taskTagsHidden');
        createTagInput('editTaskTagContainer', 'editTaskTags', 'editTaskTagsHidden');

        // Color all existing tags
        document.querySelectorAll('.tag').forEach(tag => {
            tag.style.backgroundColor = getRandomColor();
        });

        // Add drag and drop event listeners
        document.querySelectorAll('.task-column').forEach(column => {
            column.addEventListener('dragover', dragOver);
            column.addEventListener('drop', function(event) {
                const status = this.querySelector('h3').textContent.trim().toUpperCase().replace(' ', '_');
                drop(event, status);
            });
        });
    });
</script>
</body>
</html>