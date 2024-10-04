<%@ page import="org.banta.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task and User Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
                <div class="bg-gray-100 p-4 rounded-lg">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">To Do</h3>
                    <div class="space-y-3">
                        <div class="bg-white p-3 rounded shadow">
                            <h4 class="font-medium">Design new landing page</h4>
                            <p class="text-sm text-gray-600 mt-1">Create wireframes and mockups</p>
                            <div class="flex items-center mt-2">
                                <img src="/api/placeholder/24/24" alt="Assignee" class="w-6 h-6 rounded-full bg-gray-300">
                                <span class="ml-2 text-xs text-gray-500">Jane S.</span>
                            </div>
                        </div>
                        <div class="bg-white p-3 rounded shadow">
                            <h4 class="font-medium">Optimize database queries</h4>
                            <p class="text-sm text-gray-600 mt-1">Improve performance of main queries</p>
                            <div class="flex items-center mt-2">
                                <img src="/api/placeholder/24/24" alt="Assignee" class="w-6 h-6 rounded-full bg-gray-300">
                                <span class="ml-2 text-xs text-gray-500">Mike J.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- In Progress Column -->
                <div class="bg-gray-100 p-4 rounded-lg">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">In Progress</h3>
                    <div class="space-y-3">
                        <div class="bg-white p-3 rounded shadow border-l-4 border-yellow-400">
                            <h4 class="font-medium">Implement user authentication</h4>
                            <p class="text-sm text-gray-600 mt-1">Set up JWT-based auth system</p>
                            <div class="flex items-center mt-2">
                                <img src="/api/placeholder/24/24" alt="Assignee" class="w-6 h-6 rounded-full bg-gray-300">
                                <span class="ml-2 text-xs text-gray-500">John D.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Done Column -->
                <div class="bg-gray-100 p-4 rounded-lg">
                    <h3 class="text-lg font-medium mb-4 text-gray-700">Done</h3>
                    <div class="space-y-3">
                        <div class="bg-white p-3 rounded shadow border-l-4 border-green-400">
                            <h4 class="font-medium">Set up project repository</h4>
                            <p class="text-sm text-gray-600 mt-1">Initialize Git repo and add CI/CD</p>
                            <div class="flex items-center mt-2">
                                <img src="/api/placeholder/24/24" alt="Assignee" class="w-6 h-6 rounded-full bg-gray-300">
                                <span class="ml-2 text-xs text-gray-500">Sarah L.</span>
                            </div>
                        </div>
                        <div class="bg-white p-3 rounded shadow border-l-4 border-green-400">
                            <h4 class="font-medium">Write project documentation</h4>
                            <p class="text-sm text-gray-600 mt-1">Create initial README and API docs</p>
                            <div class="flex items-center mt-2">
                                <img src="/api/placeholder/24/24" alt="Assignee" class="w-6 h-6 rounded-full bg-gray-300">
                                <span class="ml-2 text-xs text-gray-500">Mike J.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Section -->
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-semibold text-indigo-800">Team Members</h2>
                <button onclick="openCreateModal()" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-full transition duration-300 ease-in-out transform hover:scale-105">
                    <i class="fas fa-plus mr-2"></i>Add User
                </button>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users == null || users.isEmpty()) {
                %>
                <div class="col-span-full text-center py-4 text-gray-500">No users found.</div>
                <%
                } else {
                    for (User user : users) {
                %>
                <div class="bg-gray-50 rounded-lg p-4 shadow hover:shadow-md transition duration-300 ease-in-out">
                    <div class="flex items-center justify-between mb-2">
                        <div class="flex items-center">
                            <img src="/api/placeholder/40/40" alt="User Avatar" class="w-10 h-10 rounded-full bg-indigo-200 mr-3">
                            <div>
                                <h3 class="font-semibold text-indigo-700"><%= user.getUsername() %></h3>
                                <p class="text-sm text-gray-600"><%= user.getEmail() %></p>
                            </div>
                        </div>
                        <div>
                            <button onclick="openEditModal(<%= user.getId() %>, '<%= user.getUsername() %>', '<%= user.getEmail() %>')" class="text-blue-500 hover:text-blue-700 mr-2 transition duration-300 ease-in-out">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button onclick="confirmDelete(<%= user.getId() %>)" class="text-red-500 hover:text-red-700 transition duration-300 ease-in-out">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>

<!-- Create User Modal -->
<div id="createModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-medium leading-6 text-gray-900 mb-4">Create New User</h3>
        <form action="user?action=create" method="post">
            <div class="mb-4">
                <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                <input type="text" name="username" id="username" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mb-4">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input type="email" name="email" id="email" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mb-4">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <input type="password" name="password" id="password" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mt-6 flex justify-end">
                <button type="button" onclick="closeModals()" class="mr-2 px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Cancel
                </button>
                <button type="submit" class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Create User
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <h3 class="text-lg font-medium leading-6 text-gray-900 mb-4">Edit User</h3>
        <form action="user?action=edit" method="post">
            <input type="hidden" name="id" id="editUserId">
            <div class="mb-4">
                <label for="editUsername" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                <input type="text" name="username" id="editUsername" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mb-4">
                <label for="editEmail" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input type="email" name="email" id="editEmail" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mb-4">
                <label for="editPassword" class="block text-sm font-medium text-gray-700 mb-1">New Password (leave blank to keep current)</label>
                <input type="password" name="password" id="editPassword" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500">
            </div>
            <div class="mt-6 flex justify-end">
                <button type="button" onclick="closeModals()" class="mr-2 px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Cancel
                </button>
                <button type="submit" class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Update User
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('createModal').classList.remove('hidden');
    }

    function openEditModal(id, username, email) {
        document.getElementById('editUserId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editEmail').value = email;
        document.getElementById('editModal').classList.remove('hidden');
    }

    function closeModals() {
        document.getElementById('createModal').classList.add('hidden');
        document.getElementById('editModal').classList.add('hidden');
    }

    function confirmDelete(userId) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                // Use fetch API to send a POST request
                fetch('user?action=delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + userId
                })
                    .then(response => {
                        if (response.ok) {
                            Swal.fire(
                                'Deleted!',
                                'The user has been deleted.',
                                'success'
                            ).then(() => {
                                window.location.reload();
                            });
                        } else {
                            throw new Error('Failed to delete user');
                        }
                    })
                    .catch(error => {
                        Swal.fire(
                            'Error!',
                            'Failed to delete user: ' + error.message,
                            'error'
                        );
                    });
            }
        });
    }

    // Close modals when clicking outside
    window.onclick = function(event) {
        if (event.target == document.getElementById('createModal') || event.target == document.getElementById('editModal')) {
            closeModals();
        }
    }
</script>

</body>
</html>