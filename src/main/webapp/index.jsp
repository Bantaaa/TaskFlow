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
            <h2 class="text-2xl font-semibold mb-4 text-indigo-800">Team Members</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users == null || users.isEmpty()) {
                %>
                <tr>
                    <td colspan="4">No users found.</td>
                </tr>
                <%
                } else {
                    for (User user : users) {
                %>
                <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4">
                    <img src="/api/placeholder/48/48" alt="User 1" class="w-12 h-12 rounded-full bg-gray-300">
                    <div>
                        <p class="font-medium"><%= user.getUsername() %></p>
                        <p class="text-sm text-gray-500"><%= user.getEmail() %></p>
                    </div>
                </div>
                <%
                        }
                    }
                %>
<%--                <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4">--%>
<%--                    <img src="/api/placeholder/48/48" alt="User 2" class="w-12 h-12 rounded-full bg-gray-300">--%>
<%--                    <div>--%>
<%--                        <p class="font-medium">Jane Smith</p>--%>
<%--                        <p class="text-sm text-gray-500">UX Designer</p>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4">--%>
<%--                    <img src="/api/placeholder/48/48" alt="User 3" class="w-12 h-12 rounded-full bg-gray-300">--%>
<%--                    <div>--%>
<%--                        <p class="font-medium">Mike Johnson</p>--%>
<%--                        <p class="text-sm text-gray-500">Project Manager</p>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="bg-gray-50 p-4 rounded-lg flex items-center space-x-4">--%>
<%--                    <img src="/api/placeholder/48/48" alt="User 4" class="w-12 h-12 rounded-full bg-gray-300">--%>
<%--                    <div>--%>
<%--                        <p class="font-medium">Sarah Lee</p>--%>
<%--                        <p class="text-sm text-gray-500">QA Tester</p>--%>
<%--                    </div>--%>
<%--                </div>--%>
            </div>
        </div>
    </div>
</div>
</body>
</html>
